//
//  ViewController.swift
//  Pharma+
//
//  Created by Thony on 11/13/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import GoogleSignIn
import Google

class ViewController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate
{
    
    
    
    @IBOutlet weak var pseudo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let myNetwork = NetworkTraitement()
    let session = PersonneSession()
    
    var url = ""
    //var user: NSArray = []
    
    lazy var userobject:NSArray =
        {
            let userobj: NSArray = []
            
            return userobj
    }()
    
    lazy var  userfacebookobject:NSDictionary =
    {
            let fckuserobj:NSDictionary = [:]
            return fckuserobj
    }()
    
    lazy var usergmailobject:NSMutableDictionary =
        {
       
            //let key = ["email","picture","prenom","nom"]

            let gmailobj:NSMutableDictionary =  [
                "email": "",
                "picture": "",
                "prenom": "",
                "nom": ""
            ]
            return gmailobj
    }()

    var user: Dictionary<String,Any> = [:]
    var txtpseudo = ""
    var txtpassword = ""
    lazy var kClientID = "1047687511212-ccpjo6pac2apirtivut6jp1f409af9aj.apps.googleusercontent.com"
    
    var myTimer:Timer!
    
    @objc func initAcitivityIndicator()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        print("ddsafsddcoll")
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        

    }
    
    @objc func stopActivityIndicator()
    {
        
   activityIndicator.stopAnimating()
   UIApplication.shared.endIgnoringInteractionEvents()
   myTimer.invalidate()
        
    }
    
    func goToClientMenu()
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ClientMenuController") as? ClientMenuController
            else{
                print("Could'nt find the view controller")
                return
        }
    //    self.dismiss(animated: true, completion: nil)
        navigationController?.show(mainviewcontroller, sender: nil)
        self.stopActivityIndicator()
    }
    
    func goToPharmacistMenu()
    {
        let pharmacystStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let pharmacystviewcontroller = pharmacystStoryboard.instantiateViewController(withIdentifier: "PharmacienInterfaceController") as? PharmacienInterfaceController
            else{
                print("Could'nt find the view controller")
                return
        }
        
       // navigationController?.present(pharmacystviewcontroller, animated: true, completion: nil)
        navigationController?.show(pharmacystviewcontroller,sender:  nil)
        self.stopActivityIndicator()
    }
    
    func initFaceBookCon()
    {
         let btnFBLogin = FBSDKLoginButton()
    btnFBLogin.frame = CGRect(x: 20, y: 23, width: view.frame.width - 32, height: 50)
        
         btnFBLogin.readPermissions = ["public_profile","email"]
        
         btnFBLogin.delegate = self
        
         btnFBLogin.center = view.center
        self.view.addSubview(btnFBLogin)
        
        if(FBSDKAccessToken.current() != nil)
        {
            //addAlert(titre: "Deja" , message: "Connecter")
            fetchProfile()
            //  goToClientMenu()
        }
        else
        {
            //addAlert(titre: "Pa encore" , message: "Pas encore connecte")
        }
    }
    
    func initGmailCon()
    {
        var error:NSError?
        GGLContext.sharedInstance()?.configureWithError(&error)
        let googlesigninbutton = GIDSignInButton()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = "1047687511212-ccpjo6pac2apirtivut6jp1f409af9aj.apps.googleusercontent.com"
        googlesigninbutton.center = view.center
        self.view.addSubview(googlesigninbutton)
        
        if(error  == nil)
        {
            print("ok loginn")
        }
        else
        {
            print("erreur:\(error)")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //initFaceBookCon()
        
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if(error == nil)
        {
            let email = user.profile.email!
            let gmailpic = user.profile.imageURL(withDimension: 400)!
            let prenom = user.profile.givenName!
            let nom = user.profile.familyName!
           
          
            
            self.usergmailobject.setValue(email,  forKey: "email")
            self.usergmailobject.setValue(gmailpic, forKey: "picture")
            self.usergmailobject.setValue(prenom, forKey: "prenom")
            self.usergmailobject.setValue(nom, forKey: "nom")

            
            //goToClientMenu()
         //   print(self.usergmailobject)
            
        }
        else
        {
           print(error)
        }
    }
    
    func fetchProfile()
    {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters)?.start{(connection,result,error)-> Void in
            
            if(error != nil)
            {
                print(error)
            }
            
       else
            {
                self.userfacebookobject = result  as! NSDictionary
                
              //  print(self.userfacebookobject)

                let email = self.userfacebookobject["email"] as! String
                let first_name = self.userfacebookobject["first_name"] as! String //prenom
                let last_name = self.userfacebookobject["last_name"] as! String //nom
                
                print(email)
                print(first_name)
                print(last_name)
            }
            
        }
    }
    
    func addAlert(titre: String , message: String)
    {
        let alert = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert,animated: true)
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if(error != nil)
        {
      addAlert(titre: "Error" , message: "Erreur Facebook button")
        }
        else if(result.isCancelled)
        {
        addAlert(titre: "Info" , message: "Login annule")
        }
        else
        {
           //  addAlert(titre: "Reussite" , message: "Connecte avec success")
            goToClientMenu()

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        
    }

   
    
    func userLogin(url: String,username: String, pwd: String)
    {
        if(username.count != 0 && pwd.count != 0)
        {
            myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stopActivityIndicator), userInfo: nil, repeats: false)
            myNetwork.seConnecter(url: url)
            {
                json,error in
                
                DispatchQueue.main.async
                    {
                        
                        if(error == nil)
                        {
                            self.userobject = json!
                            
                            if(self.userobject.count == 1)
                            {
                                self.user = self.userobject[0] as! Dictionary<String,Any>
                                print("Datauser:\(self.user)")
                                if(self.user["role"] as! Int == 0)
                                {
                                    
                                    guard let userid = self.user["id"] as? Int else{return}
                                    guard let email = self.user["email"] as? String else{return}
                                    guard let pseudo = self.user["pseudo"] as? String else{return}
                                    guard let password = self.user["password"] as? String else{return}
                                    guard let photo = self.user["photo"] as?  String else{return}
                                    guard let role = self.user["role"] as? Int else{return}
                                    guard let activate = self.user["activate"] as? Int else{return}
                                    
                                    
                                    self.session.CreateSession(id: userid, email: email, pseudo: pseudo, password: password, photo: photo, numeros: "", role: role, activate: activate)
                                    print("Client")
                                    self.goToClientMenu()
                                }
                                else if(self.user["role"] as! Int == 1)
                                {
                                    guard let userid = self.user["id"] as? Int else{return}
                                    guard let email = self.user["email"] as? String else{return}
                                    guard let pseudo = self.user["pseudo"] as? String else{return}
                                    guard let password = self.user["password"] as? String else{return}
                                    guard let photo = self.user["photo"] as?  String else{return}
                                    guard let numeros = self.user["numero"] as? String else{return}
                                    guard let role = self.user["role"] as? Int else{return}
                                    guard let activate = self.user["activate"] as? Int else{return}
                                    
                                    
                                    self.session.CreateSession(id: userid, email: email, pseudo: pseudo, password: password, photo: photo, numeros: numeros, role: role, activate: activate)
                                    print("Phramacien")
                                    self.goToPharmacistMenu()
                                }
                                else
                                {
                                    print(self.user["role"]);
                                    print("pas d'utilisateur")
                                    self.stopActivityIndicator()
                                }
                            }
                            else
                            {
                                self.stopActivityIndicator()
                                self.addAlert(titre: "Erreur" , message: "Non-existent account");
                                 self.stopActivityIndicator()
                            }
                        }
                        else
                        {
                        }
                }
            }
        }
        else
        {
          
           
       addAlert(titre: "Champ Vide" , message: "Vous devez entrez votre pseudo et votre password");
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
       
    }
    
    @IBAction func checkLogin(_ sender: UIButton)
    {
       // print("oklkcdjlnskvnlvf")
         initAcitivityIndicator()
        url = "http://localhost:3000/pharmacy/user/"
        url += pseudo.text!
        url += "/"
        url += password.text!
       
        userLogin(url: url,username: pseudo.text!, pwd: password.text!)
    }
    
    

    override func viewDidAppear(_ animated: Bool)
    {
     
       /* if(CheckInternet.Connection())
        {
       addAlert(titre: "Connected", message: "You are connected")
        }
        else
        {
     addAlert(titre: "Network Error", message: "Your Device is not connected with internet")
        }*/
    }
}

