//
//  InscriptionViewController.swift
//  Pharma+
//
//  Created by Thony on 11/14/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import Alamofire

class InscriptionViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var pseudo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var retypepassword: UITextField!
    
    lazy var userparams:Dictionary<String,Any> =
        {
            let userp:Dictionary<String,Any> = [:]
            return userp
    }()
    
    
    func addAlert(titre: String , message: String)
    {
        let alert = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert,animated: true)
    }
    
    func verifemail(myemail:String) -> (Bool)
    {
        return  false
    }
    
    func verifPasswordAndRetypePassword() -> (Bool)
    {
        return false
    }
    
    func verifpseudo() -> (Bool)
    {
      return false
    }
    
    
    func executeUrl(url: URL)
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
    }
    
    @IBAction func registerAccount(_ sender: UIButton)
    {
        if(email.text!.count != 0 && pseudo.text!.count != 0 && password.text!.count != 0 && password.text! == retypepassword.text! )
        {
            print("Reussite")

            userparams =
            [
                "email": email.text!,
                "pseudo": pseudo.text!,
                "password": password.text!,
                "photo": "mypicture.jpg",
                "role": 0
            ]
            
            

            
            let url = "http://localhost:3000/pharmacy/user/add"
            
            Alamofire.request(url, method:.post, parameters:userparams,encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    print(response)
                case .failure(let error):
                   print(error)
                }
            }

        }
        else
        {
            addAlert(titre: "Invalide", message: "Vous devez remplire tout les champs")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
