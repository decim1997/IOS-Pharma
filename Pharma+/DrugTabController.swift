//
//  DrugTabController.swift
//  Pharma+
//
//  Created by Thony on 11/25/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

class DrugTabController: UITabBarController
{
    var drugTabBaritem = UITabBarItem()
    
    lazy var pharmadata:Dictionary<String,Any> =
        {
            var phdata:Dictionary<String,Any> = [:]
            
            return phdata
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
     
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
         UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        let selectedImage1 = UIImage(named: "iconhome")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage1 =  UIImage(named: "iconhome2")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![0]
        drugTabBaritem.image = deselectedImage1
        drugTabBaritem.image = selectedImage1
        
        
        let selectedImage2 = UIImage(named: "drug")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage2 =  UIImage(named: "drug2")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![1]
        drugTabBaritem.image = deselectedImage2
        drugTabBaritem.image = selectedImage2
        
        
        let selectedImage3 = UIImage(named: "pharmacist")?.withRenderingMode(.alwaysOriginal)
        let deselectedImage3 =  UIImage(named: "pharmacist")?.withRenderingMode(.alwaysOriginal)
        drugTabBaritem = self.tabBar.items![2]
        drugTabBaritem.image = deselectedImage3
        drugTabBaritem.image = selectedImage3
        
        let numberofTabs = CGFloat(tabBar.items!.count)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberofTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imagewithcolor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: tabBarSize)

        self.selectedIndex = 0

        if(self.selectedIndex == 0)
        {
            print("Okkkkkkk")
            print(pharmadata)
        }
    }
    
  

   
}



extension UIImage
{
  class  func imagewithcolor(color: UIColor, size: CGSize) -> UIImage
    {
   let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
  
 UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
