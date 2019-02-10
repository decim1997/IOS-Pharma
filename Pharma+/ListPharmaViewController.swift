//
//  ListPharmaViewController.swift
//  Pharma+
//
//  Created by Thony on 12/10/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

class ListPharmaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    
    
    var url:String = ""
    var medicamentName:String?

    let myNetwork = NetworkTraitement()
    lazy var pharmacyobject:NSArray =
        {
            let pharmobject:NSArray = []
            
            return pharmobject
    }()
    
  var datafilterd:[Pharmacymodel] = Pharmacymodel.generatedModelArray()

    @IBOutlet var pharmatableview: UITableView!
    var i  = 0
    
    func fetchPharmacySelected()
    {
        url = "http://localhost:3000/pharmacylist/"
        url += medicamentName!
        
        
      myNetwork.getPharmacyWithMedCheeking(url: url)
      {
        json,error in
        
        DispatchQueue.main.async
    {
    
        if(error == nil)
        {
            print("data:\(json)")
            
            self.pharmacyobject = json as! NSArray
            
              while(self.i < self.pharmacyobject.count)
              {
                let pharmacy2 = self.pharmacyobject[self.i] as! Dictionary<String,Any>
                let pharmacyPicture = pharmacy2["pharma_picture"] as! String
                let pharmacyName = pharmacy2["nom_pharmacie"] as! String
                let pharmanumero = pharmacy2["numeros_pharmacie"] as! String
                let pharmacyville = pharmacy2["ville"] as! String
                let pharmaaddresse = pharmacy2["adresse"] as! String
                let pharmacymode =  pharmacy2["garde"] as! Int
                let pharmacyid = pharmacy2["id_pharmacie"] as! Int
                let pharmacienid = pharmacy2["id_pharmacien"] as! Int
                let pharmaciendescription = pharmacy2["desciprion"] as! String
                let pharmacypay = pharmacy2["pay"] as! String
                let pharmacylongitude = pharmacy2["longitude"] as! Double
                let pharmacylatitude = pharmacy2["latitude"] as! Double
    self.datafilterd.append(Pharmacymodel(pharmacyid:pharmacyid,pharmacienid:pharmacienid,pharmacypic: pharmacyPicture, pharmacyname: pharmacyName,pharmacycity: pharmacyville, pharmacygarde: String(pharmacymode),NumeroPharmacy: pharmanumero,phamacyAddress:pharmaaddresse,pharmacydescription:pharmaciendescription,pharmacycountry:pharmacypay,pharmacylongitude:pharmacylongitude,pharmacylatitude:pharmacylatitude))
                
                //pharmacy["adresse"]
                
               /* self.datafilterd.append(Pharmacymodel(pharmacypic: pharmacyPicture, pharmacyname: pharmacyName,pharmacycity: pharmacyville, pharmacygarde: String(pharmacymode),NumeroPharmacy: pharmanumero,phamacyAddress:pharmaaddresse))*/
               self.i = self.i + 1
            }
            
            self.pharmatableview.reloadData()
        }
        else
        {
            
        }
        
    }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return datafilterd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pharmacie")
        let content = cell?.viewWithTag(0)
        let pharmapic = content?.viewWithTag(1) as? UIImageView
        let pharmaname = content?.viewWithTag(2) as? UILabel
        let pharmacity = content?.viewWithTag(3) as? UILabel
        
        let pharmacy =  datafilterd[indexPath.row]
        
        let pharmacyPicture = pharmacy.pharmacypic
        let pharmacyName =  pharmacy.pharmacyname
        let pharmanumero = pharmacy.NumeroPharmacy
        let pharmacyville = pharmacy.pharmacycity
        let pharmaaddresse = pharmacy.phamacyAddress
        
        
        let urlimage = URL(string: pharmacyPicture)
        pharmapic?.af_setImage(withURL: urlimage!)
        pharmaname?.text = pharmacyName
        pharmacity?.text = pharmacyville
        
        return cell!
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchPharmacySelected()

        print("nommed:\(medicamentName!)")
    }
    
    func createOrUpdatePharma(indexPath: IndexPath)
    {
        
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let sessionEntity = NSEntityDescription.entity(forEntityName: "SessionPharmacy", in: managedContext)
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SessionPharmacy")
        
        fetcherequest.predicate = NSPredicate(format: "id == %id",0)
        
        
        do
        {
            let result = try managedContext.fetch(fetcherequest)
            
            if(result.count == 0)
            {
                let pharmacy =  NSManagedObject(entity: sessionEntity!, insertInto: managedContext)
                
                pharmacy.setValue(0, forKey: "id")
                pharmacy.setValue(datafilterd[indexPath.row].pharmacyid, forKey: "id_pharmacie")
                pharmacy.setValue(datafilterd[indexPath.row].pharmacienid, forKey: "id_pharmacien")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacyname, forKey: "adresse")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacydescription, forKey: "description_pharmacie")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacygarde, forKey: "garde")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacylongitude, forKey: "longitude")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacylatitude, forKey: "latitude")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacycountry, forKey: "pay")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacypic, forKey: "phamciy_picture")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacycity, forKey: "ville")
                pharmacy.setValue(datafilterd[indexPath.row].NumeroPharmacy, forKey: "numero_pharmacie")
                try managedContext.save()
                
                print("New Inssriont")
            }
            else
            {
                let pharmacy = result[0] as! NSManagedObject
                pharmacy.setValue(datafilterd[indexPath.row].pharmacyid, forKey: "id_pharmacie")
                pharmacy.setValue(datafilterd[indexPath.row].pharmacienid, forKey: "id_pharmacien")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacyname, forKey: "adresse")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacydescription, forKey: "description_pharmacie")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacygarde, forKey: "garde")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacylongitude, forKey: "longitude")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacylatitude, forKey: "latitude")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacycountry, forKey: "pay")
                
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacypic, forKey: "phamciy_picture")
                
                pharmacy.setValue(datafilterd[indexPath.row].pharmacycity, forKey: "ville")
                pharmacy.setValue(datafilterd[indexPath.row].NumeroPharmacy, forKey: "numero_pharmacie")
                //print("nompharmacie\(datafilterd[indexPath.row].pharmacyid)")
                try managedContext.save()
                print("Update Inssertion")
            }
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        createOrUpdatePharma(indexPath: indexPath)
        
       // performSegue(withIdentifier: "GoToThisPharmacy", sender: indexPath)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        
        navigationController?.show(mainviewcontroller, sender: nil)
    }

    
}
