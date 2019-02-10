//
//  MainViewController.swift
//  Pharma+
//
//  Created by Thony on 11/14/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

class MainViewController: UIViewController
{
    var sidebarView:SideBarView!
     var blackScreen: UIView!
    
    
    @objc func actionSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        
        switch recognizer.direction {
        case .up:
            print("You Swipe up")
            break
            
        case .down:
            print("You Swipe down")
            break
            
        case .left:
            print("You Swipe left")
            break
        
        case .right:
            print("You Swipe right")
            break
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(btnMenuAction))
        btnMenu.tintColor=UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = btnMenu
        
        sidebarView = SideBarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate = self
        sidebarView.layer.zPosition=100
        self.view.isUserInteractionEnabled=true
        self.navigationController?.view.addSubview(sidebarView)
        
        blackScreen=UIView(frame: self.view.bounds)
        blackScreen.backgroundColor=UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden=true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition=99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for direction in directions
        {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipeGesture))
            swipeGesture.direction =  direction
            view.addGestureRecognizer(swipeGesture)
        }
          }
    
    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
        }) { (complete) in
            self.blackScreen.frame=CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    
}


extension MainViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        switch row {
        case .editProfile:
          //  let vc=EditProfileVC()
          //  self.navigationController?.pushViewController(vc, animated: true)
            print("Edit Menu")
        case .messages:
            print("Messages")
        case .contact:
            print("Contact")
        case .settings:
            print("Settings")
        case .history:
            print("History")
        case .help:
            print("Help")
        case .signOut:
            print("Sign out")
        case .none:
            break
            //        default:  //Default will never be executed
            //            break
        }
    }
}
