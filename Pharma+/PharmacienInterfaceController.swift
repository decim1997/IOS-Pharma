//
//  PharmacienInterfaceController.swift
//  Pharma+
//
//  Created by Thony on 12/18/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

class PharmacienInterfaceController: UITabBarController
{

    var drugTabBaritem = UITabBarItem()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        
        let selectedImage1 = UIImage(named: "qrcode")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage1 =  UIImage(named: "qrcode")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![0]
        drugTabBaritem.image = deselectedImage1
        drugTabBaritem.image = selectedImage1
        
        
        let selectedImage2 = UIImage(named: "drug")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage2 =  UIImage(named: "drug")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![1]
        drugTabBaritem.image = deselectedImage2
        drugTabBaritem.image = selectedImage2
        
        
        let selectedImage3 = UIImage(named: "ordered")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage3 =  UIImage(named: "ordered")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![2]
        drugTabBaritem.image = deselectedImage3
        drugTabBaritem.image = selectedImage3
        
        
       
        
        let numberofTabs = CGFloat(tabBar.items!.count)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberofTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imagewithcolor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: tabBarSize)
        
        self.selectedIndex = 1
    }
    
}
