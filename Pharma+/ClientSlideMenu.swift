//
//  MenuViewController.swift
//  Pharma+
//
//  Created by Thony on 12/16/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

protocol SlideMenuDelegate2
{
    func slideMenuItemSelectedAtIndex(_ index: Int32)
}

class ClientSlideMenu: UIViewController
{

    var btnMenu: UIButton!
    var delegate:SlideMenuDelegate2?
    
    var PharmacyArray:[NSManagedObject] = []

    
    @IBOutlet var btncloseMenu: UIButton!
    
    let session = PersonneSession()
    //@IBOutlet var btncloseMenu: UIButton!
    
    @IBOutlet var profileimage: UIImageView!
    
    func roundimage()
    {
     //   profileimage.layer.cornerRadius =  profileimage.frame.size.width/2
       // profileimage.clipsToBounds = true
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        roundimage()
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
    
    
    @IBAction func DisplayAllcommande(_ sender: UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "CommandeViewController") as? CommandeViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        navigationController?.show(mainviewcontroller, sender: nil)
    }
    
    
    @IBAction func DisplayFavorisMed(_ sender: UIButton)
    {
        
    }
    
    

    
    
    @IBAction func GoToAboutUs(_ sender: UIButton)
    {
        
    }
    
    
    @IBAction func MessageUs(_ sender: UIButton)
    {
        
    }
    
    
    
    
    @IBAction func GoToHome(_ sender: UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ClientMenuController") as? ClientMenuController
            else{
                print("Could'nt find the view controller")
                return
        }
        navigationController?.pushViewController(mainviewcontroller, animated: true)
    }
}
