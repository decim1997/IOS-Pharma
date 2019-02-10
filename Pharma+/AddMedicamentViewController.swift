//
//  AddMedicamentViewController.swift
//  Pharma+
//
//  Created by Thony on 12/19/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import Alamofire

class AddMedicamentViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    

    @IBOutlet var imgmed: UIImageView!
    
    @IBOutlet var btimportimg: UIButton!
    
    @IBOutlet var txtnommed: UITextField!
    
    @IBOutlet var txtprixmed: UITextField!
    
    @IBOutlet var txtquantitemed: UITextField!
    
    var verif = false
    
    var ordonance = 0
    
    var url = ""
    
    //var medpic = UIImagePickerController()
    
    @IBOutlet var checkbox: UIButton!
    
    lazy var medicamentparams:Dictionary<String,Any> =
        {
            let medp:Dictionary<String,Any> = [:]
            return medp
    }()
    
    @IBAction func importImgMedicament(_ sender: UIButton)
    {
        let medpic = UIImagePickerController()

        
        medpic.delegate = self
        medpic.sourceType = UIImagePickerController.SourceType.photoLibrary
        medpic.allowsEditing = false
        self.present(medpic,animated: true)
        {
            /// affter is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgmed.image = image
        }
        else
        {
            print("Error when converting to image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
    
    @IBAction func AddMedicament(_ sender: UIButton)
    {

        
        if(txtnommed.text!.count > 0 && txtprixmed.text!.count > 0 && txtquantitemed.text!.count > 0 && imgmed.image != nil)
        {
            if(verif == true)
            {
                ordonance = 1;
            }
            else
            {
                ordonance = 0;
            }
     
            
             medicamentparams =
            [
                "nom_medicament": txtnommed.text!,
                "image_medicament": "img1",
                "prix": Int(txtprixmed.text! as! String),
                "quantite": Int(txtquantitemed.text! as! String),
                "ordonnance": ordonance,
                "id_type": 1,
               "id_categorie":1 ,
                "id_forme": 1
            ]
            
            
            url = "http://localhost:3000/pharmacy/pharmacient/addmedicament"
            
            Alamofire.request(url, method: .post, parameters: medicamentparams, encoding: JSONEncoding.default)
            .responseJSON
                {
                    response in
                    
                    switch response.result {
                    case .success:
                    let alert = UIAlertController(title: "Success", message: "Medicament add with sucess", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alert.addAction(action)
                    self.present(alert,animated: true)
                    self.txtnommed.text =  nil
                    self.txtquantitemed.text = nil
                    self.txtprixmed.text = nil
                    self.imgmed.image = nil
                    self.checkbox.isSelected = false
                        break
                        
                    case .failure(let error):
                        print(error)
                        break
                    }
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Data are invalde", message: "You must fill all the champs", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default
        
        /*do {

            let filelist = try filemgr.contentsOfDirectory(atPath: "/Applications/AMPPS/www/pim/picture/medicament")
            
            for filename in filelist {
                print(filename)
            }
        } catch let error {
            print("Errorofreadingmyfile: \(error.localizedDescription)")
        }*/
        
        let file: FileHandle? = FileHandle(forReadingAtPath: "/Applications/AMPPS/www/pim/picture/medicament/TEGORSALES.png")
        
        if file == nil {
            print("File open failed")
        } else {
            print("Offset = \(file?.offsetInFile)")
            file?.seekToEndOfFile()
            print("Offset = \(file?.offsetInFile)")
            file?.seek(toFileOffset: 30)
            print("Offset = \(file?.offsetInFile)")
            file?.closeFile()
        }
        
    }
    

    @IBAction func checkBoxTapped(_ sender: UIButton)
    {
     
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){ (success) in
            sender.isSelected = !sender.isSelected
            self.verif = !self.verif
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        /*if(sender.isSelected)
       {
        sender.isSelected = false
        }
        else
       {
       sender.isSelected = true
        }*/
    }
}


extension AddMedicamentViewController
{
    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        var mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let imageData =  UIImage.jpegData(imgmed.image!)
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        
       // body.append(imageData)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
    
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}


