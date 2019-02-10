//
//  QRCodeReaderViewController.swift
//  Pharma+
//
//  Created by Thony on 1/14/19.
//  Copyright © 2019 Thony. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{

    var video = AVCaptureVideoPreviewLayer()
    var allcommandes:[Commande] = Commande.generatedModelArray()
    let myNetwork = NetworkTraitement()
    var cmdurl = ""
    lazy var commandeArray:NSArray =
        {
            var  comm:NSArray = []
            
            
            return comm
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fetchCommande(url: "http://localhost:3000/pharmacy/getidcommande/LHKzadFbMjFwq9O")
     
      /*  let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ShowCommandToPharmacienViewController") as? ShowCommandToPharmacienViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        
        mainviewcontroller.idcommande = 91
        print("go to display menu")
        self.navigationController?.present(mainviewcontroller, animated: true, completion: nil)*/
        
        
      ///  self.navigationController?.show(mainviewcontroller, sender: nil)
        
        

/*        let session = AVCaptureSession()
        

        let capturedevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            
        let input = try AVCaptureDeviceInput(device: capturedevice!)
          session.addInput(input)
            
        }
        
        catch{
            
            print("Error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video =  AVCaptureVideoPreviewLayer(session: session)
        view.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
 
 */
       
    }

    func fetchCommande(url: String)
    {
        myNetwork.getCommandeIdentifiant(url: url)
        {
            json, error in
            
            
            DispatchQueue.main.async {
                
                if(error == nil)
                {
                    self.commandeArray = json as! NSArray
                 
                    for i in 0 ..< self.commandeArray.count
                    {
             let order = self.commandeArray[i] as! Dictionary<String,Any>
               
         let idcommande = order["id_commande"] as! Int
         let idpharmacie = order["id_pharmacie"] as! Int
          let prixtotal = order["prix_total"] as! Double
          let datecommande = order["date_commande"] as! String
          let idclient = order["id_client"] as! Int
          let code = order["code"] as! String
         self.allcommandes.append(Commande(id_commande: idcommande, id_pharmacie: idpharmacie, prix_total: prixtotal, date_commande: datecommande, id_client: idclient, code: code))
                        
                        print("Reussite")
                    }
                
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "ShowCommandToPharmacienViewController") as? ShowCommandToPharmacienViewController
                        else{
                            print("Could'nt find the view controller")
                            return
                    }
                    
                    let getidcommande = self.allcommandes[0].id_commande
                    let gettotalamount = self.allcommandes[0].prix_total
                    mainviewcontroller.idcommande = getidcommande
                    mainviewcontroller.totalamount = gettotalamount
                    
                     self.navigationController?.present(mainviewcontroller, animated: true, completion: nil)
                   // self.navigationController?.show(mainviewcontroller, sender: nil)
                    
                }
                else
                {
                    print("Erreur: \(error.debugDescription)")
                }
            }
            
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
    
        if metadataObjects  != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                   
                    let myqrcode = object.stringValue
                    
                    if(myqrcode != nil)
                    {
                        cmdurl = "http://localhost:3000/pharmacy/getidcommande/"
                        cmdurl += myqrcode!
             fetchCommande(url: cmdurl)
                    }
                    else
                    {
                      let myalert = UIAlertController(title: "ERROR", message: "QRCode Unreadable", preferredStyle: .alert)
                        
                        let actionerror = UIAlertAction(title: "This QRCode is not readable", style: .default, handler: nil)
                        
                        myalert.addAction(actionerror)
                        
                        present(myalert,animated: true)
                    }
                   
             
                    /*let alert = UIAlertController(title: "QRCODE", message: object.stringValue, preferredStyle: .alert)
                    
                    
                    let action = UIAlertAction(title: "Retake", style: .default, handler: nil)
                    
                    let action2 = UIAlertAction(title: "copy", style: .default) { (UIAlertAction) in
                        UIPasteboard.general.string = object.stringValue
                    }
                    
                    alert.addAction(action)
                    alert.addAction(action2)
                    
                    present(alert,animated: true)*/
                }
            }
        }
    }
    

}
