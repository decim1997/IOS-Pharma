//
//  DetaiDrugViewController.swift
//  Pharma+
//
//  Created by Thony on 11/28/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import AlamofireImage

class DetaiDrugViewController: UIViewController
{
    

    @IBOutlet var viewmed: UIView!
    
    @IBOutlet var viewdetail: UIView!
    
    @IBOutlet var lbmedname: UILabel!
    @IBOutlet var lbqtemed: UILabel!
    @IBOutlet var medprice: UILabel!
    @IBOutlet var medpic: UIImageView!
    @IBOutlet var txtdescription: UITextView!
    
    var nommed:String?
    var quantitemed:Int?
    var prximed:Double?
    var imgmed:String?
    var meddesc:String?
    
    @IBAction func AddToReminder(_ sender: UIButton)
    {
        
    }
    
    @IBAction func ShareMed(_ sender: UIButton)
    {
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        viewmed.layer.cornerRadius = 10.0
        viewdetail.layer.cornerRadius = 10.0
        txtdescription.isEditable = false
        lbmedname.text = nommed!
        let urlimage = URL(string: imgmed!)
        medpic.af_setImage(withURL: urlimage!)
        medprice.text = "Price: " + String(prximed!) + " Tablet"
        lbqtemed.text = "Product of " + String(quantitemed!) + " DT"
        txtdescription.text =  meddesc!
        
    }
    

    @IBAction func CloseDetai(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
