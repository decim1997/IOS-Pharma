//
//  CallViewController.swift
//  Pharma+
//
//  Created by Thony on 11/29/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import MessageUI

class CallViewController: UIViewController,MFMailComposeViewControllerDelegate
{
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func callaNumber(phonenumber: String)
    {
        print("okkkk2222")
         let url = URL(string: "telprompt://\(phonenumber)")
        UIApplication.shared.open(url!)
    }

    @IBAction func CallPharmacy(_ sender: Any)
    {
        
        let pharmacynumber = "50220223"
        
        callaNumber(phonenumber:pharmacynumber)
       // let url = URL(string: "telprompt://\(pharmacynumber)")
       
 //UIApplication.shared.open(url!)
    }
    
    func configureMailController(emails: [String],subjet:String,body: String)->MFMailComposeViewController
    {
        let mailConposerVC = MFMailComposeViewController()
        
        mailConposerVC.mailComposeDelegate = self
        mailConposerVC.setToRecipients(emails)
        
        mailConposerVC.setSubject(subjet)
        mailConposerVC.setMessageBody(body, isHTML: true)
        
        return mailConposerVC
    }
    
    func showMailError()
    {
      let sendMailErrorAlert = UIAlertController(title: "Errror", message: "Can not send an email", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        sendMailErrorAlert.addAction(dismiss)
        present(sendMailErrorAlert,animated: true)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtSendEmail(_ sender: Any)
    {
        let mymail = ["cheunanthonycedric.da@esprit.tn"]
        let mailcomposeviewcontroller = configureMailController(emails: mymail,subjet: "Activation of your compte",body: "Click on this link to activate your acount")
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailcomposeviewcontroller,animated: true)
        }
        else
        {
       showMailError()
        }
    }
    
}
