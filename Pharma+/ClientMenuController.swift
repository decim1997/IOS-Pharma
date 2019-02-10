//
//  ClientMenuController.swift
//  Pharma+
//
//  Created by Thony on 12/14/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

class ClientMenuController: UITabBarController
{
     var drugTabBaritem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
       
        let selectedImage1 = UIImage(named: "iconhome")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage1 =  UIImage(named: "iconhome")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![0]
        drugTabBaritem.image = deselectedImage1
        drugTabBaritem.image = selectedImage1
        
        let selectedImage2 = UIImage(named: "drug")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage2 =  UIImage(named: "drug")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![1]
        drugTabBaritem.image = deselectedImage2
        drugTabBaritem.image = selectedImage2
        
        
        let selectedImage3 = UIImage(named: "pharmacist")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage3 =  UIImage(named: "pharmacist")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![2]
        drugTabBaritem.image = deselectedImage3
        drugTabBaritem.image = selectedImage3
        
        
   
        
        
        let selectedImage4 = UIImage(named: "reminder")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage4 =  UIImage(named: "reminder")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![3]
        drugTabBaritem.image = deselectedImage4
        drugTabBaritem.image = selectedImage4
        
        let selectedImage5 = UIImage(named: "map")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage5 =  UIImage(named: "map")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![4]
        drugTabBaritem.image = deselectedImage5
        drugTabBaritem.image = selectedImage5
        
        let numberofTabs = CGFloat(tabBar.items!.count)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberofTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imagewithcolor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: tabBarSize)

        
      self.selectedIndex = 1
        
    }
    
    
}
