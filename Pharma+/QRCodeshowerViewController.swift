//
//  QRCodeshowerViewController.swift
//  Pharma+
//
//  Created by Thony on 1/13/19.
//  Copyright © 2019 Thony. All rights reserved.
//

import UIKit

class QRCodeshowerViewController: UIViewController
{

    @IBOutlet var imgqrcode: UIImageView!
    var code:String?
    
    
    func displayQrCodeCmd(mycode: String)
    {
        let codecommande = mycode
        let data = codecommande.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        let img = UIImage(ciImage: transformImage!)
        self.imgqrcode.image = img        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     displayQrCodeCmd(mycode: code!)
        
    }
    

  
    @IBAction func GoBackToCommade(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
