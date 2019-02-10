//
//  CustomerSlideController.swift
//  Pharma+
//
//  Created by Thony on 12/19/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

class CustomerSlideController: ClientOwnInterface {

    @IBOutlet var imgpf: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     addSlideMenuButton()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "CommandeViewController") as? CommandeViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        navigationController?.show(mainviewcontroller, sender: nil)
    }
    

    
}
