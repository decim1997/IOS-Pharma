//
//  MenuViewController.swift
//  Pharma+
//
//  Created by Thony on 12/16/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

protocol SlideMenuDelegate
{
    func slideMenuItemSelectedAtIndex(_ index: Int32)
}

class MenuViewController: UIViewController {

    var btnMenu: UIButton!
    var delegate:SlideMenuDelegate?
    
    var PharmacyArray:[NSManagedObject] = []

    
    @IBOutlet var btncloseMenu: UIButton!
    
    let session = PersonneSession()
    //@IBOutlet var btncloseMenu: UIButton!
    
    
    @IBOutlet var imgpharma: UIImageView!
    
    
    @IBOutlet var lbpharmaname: UILabel!
    
    
    
    @IBAction func ExitToYourApplication(_ sender: UIButton)
    {
       let alert = UIAlertController(title: "Exit", message: "Do you want to exit", preferredStyle: .alert)
        
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            exit(0)
        }
        
        let actionno = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        
        self.present(alert,animated: true)
        
    }
    
    func fetchPharmacyData()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "SessionPharmacy")
        
        do
        {
            PharmacyArray = try managedContext.fetch(fetchrequest)
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    
    func initmydata()
    {
        let mypharmacy = PharmacyArray[0]
        guard let pharmapicture = mypharmacy.value(forKey: "phamciy_picture") as? String else{ return }
        guard let pharmaname = mypharmacy.value(forKey: "adresse") as? String else{ return }
       
        
        let urlimage = URL(string: pharmapicture)
        imgpharma.af_setImage(withURL: urlimage!)
        lbpharmaname.text = pharmaname
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPharmacyData()
        initmydata()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btncloseMenuTapped(_ sender: UIButton)
    {
        btnMenu.tag = 0
        btnMenu.isHidden = false
        if(self.delegate != nil)
        {
            var index = Int32(sender.tag)
            if(sender ==  self.btncloseMenu)
            {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        },completion: {
            (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    

    
 
    @IBAction func goToHome(_ sender: UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ClientMenuController") as? ClientMenuController
            else{
                print("Could'nt find the view controller")
                return
        }
        navigationController?.pushViewController(mainviewcontroller, animated: true)
    }
    
    @IBAction func goToDrugMenu(_ sender: UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        navigationController?.pushViewController(mainviewcontroller, animated: true)
    }
    
    
    @IBAction func goToMap(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Open the map", message: "Do you want to open the map", preferredStyle: .alert)
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction
            ) in
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyMapController") as? PharmacyMapController
                else{
                    print("Could'nt find the view controller")
                    return
            }
            
            self.navigationController?.pushViewController(mainviewcontroller, animated: true)
            
        }
        
        let  actionno = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        
        self.present(alert,animated: true)
        
    }
    
    @IBAction func CallPharmacy(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: "Lauch call", message: "Do you want to call this pharmacy", preferredStyle: .alert)
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction
            ) in
            
             let pharmacy = self.PharmacyArray[0]
            guard let phonenumber = pharmacy.value(forKey: "numero_pharmacie") else {return}
            
            let url = URL(string: "telprompt://\(phonenumber)")
            UIApplication.shared.open(url!)
        }
        
        let  actionno = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        
        self.present(alert,animated: true)
        
      
    }
    
    @IBAction func SignOut(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Sign Out", message: "Do you want to sign out", preferredStyle: .alert)
        
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (actionyes) in
            self.session.EmptyPersonneSession()
          
           let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "SignUP") as? ViewController
                else{
                    print("Could'nt find the view controller")
                    return
            }
            self.show(mainviewcontroller, sender: nil)
            //self.present(mainviewcontroller,animated: true)
        }
        
        let actionno = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        self.present(alert,animated: true)
        
      
    }
    /*
     print("click to go menu")
     let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
     guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ClientMenuController") as? ClientMenuController
     else{
     print("Could'nt find the view controller")
     return
     }
     navigationController?.pushViewController(mainviewcontroller, animated: true)
     
     */
    
    /*
     let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
     guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
     else{
     print("Could'nt find the view controller")
     return
     }
     navigationController?.pushViewController(mainviewcontroller, animated: true)
     
 */
    
    
}
