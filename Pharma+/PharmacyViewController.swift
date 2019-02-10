//
//  PharmacyViewController.swift
//  Pharma+
//
//  Created by Thony on 11/25/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

enum selectedScope:Int
{
    case name = 0
    
    case type = 1
    
    case ville = 2
}

class PharmacyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
  //  @IBOutlet var searchbar: UISearchBar!
    
    @IBOutlet var pharmatableview: UITableView!
    
    var tabNomPharmacy = [""]
    var tabImage = ["1","2","3","4","5"]
    var searchPharmacy = [""]
    var searchingName = false
    var url = ""
    var pharmacy: Dictionary<String,Any> = [:]
    
    lazy var pharmacyobject:NSArray =
        {
            let pharmobject:NSArray = []
            
            return pharmobject
    }()
    
    var datafilterd:[Pharmacymodel] = Pharmacymodel.generatedModelArray()
    
    var pharmacydatafiltered:[Pharmacymodel] = Pharmacymodel.generatedModelArray()
    
    var i = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(searchingName)
        {
                   //return searchPharmacy.count
            
            return pharmacydatafiltered.count
        }
        else
        {
         //   print("No")
           // return tabNomPharmacy.count
            
            return pharmacyobject.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pharmacie")
        let content = cell?.viewWithTag(0)
        let pharmapic = content?.viewWithTag(1) as? UIImageView
        let pharmaname = content?.viewWithTag(2) as? UILabel
        let pharmacity = content?.viewWithTag(3) as? UILabel
        
        if(searchingName)
        {
            
            print("Recherche")
            let mypharmacy = pharmacydatafiltered[indexPath.row]
           
            
            let urlimage = URL(string: mypharmacy.pharmacypic)
            pharmapic?.af_setImage(withURL: urlimage!)
            
            pharmaname?.text = mypharmacy.pharmacyname
             pharmacity?.text = mypharmacy.pharmacycity
        }
        else
        {
             pharmacy = pharmacyobject[indexPath.row] as! Dictionary<String,Any>
            
            let pharmacyPicture = pharmacy["pharma_picture"] as! String
            let pharmacyName = pharmacy["nom_pharmacie"] as! String
            let pharmanumero = pharmacy["numeros_pharmacie"] as! String
            let pharmacyville = pharmacy["ville"] as! String
            let pharmaaddresse = pharmacy["adresse"] as! String
            
            let urlimage = URL(string: pharmacyPicture)
            pharmapic?.af_setImage(withURL: urlimage!)
            pharmaname?.text = pharmacyName
            pharmacity?.text = pharmacyville
            print("data: \(pharmacy)")
        }
        
      /*  if(searchingName)
        {
            pharmaname?.text = searchPharmacy[indexPath.row]
            pharmapic?.image = UIImage(named: tabImage[indexPath.row])
        }
        else
        {
            pharmaname?.text = tabNomPharmacy[indexPath.row]
            pharmapic?.image = UIImage(named: tabImage[indexPath.row])
        }*/
        
        return cell!
    }
    
      let pharmasearchbar = UISearchBar(frame:CGRect(x: 0, y: 0, width:100, height: 70))
    
    func initMyseachBar()
    {
        pharmasearchbar.showsScopeBar = true
        pharmasearchbar.scopeButtonTitles = ["name","type","ville"]
        pharmasearchbar.delegate = self
        pharmasearchbar.selectedScopeButtonIndex = 0
        self.pharmatableview.tableHeaderView = pharmasearchbar
    }
    func fetchPharmacy()
    {
       url = "http://localhost:3000/pharmacy/pharmacylist"
        
       
     Alamofire.request(url).responseJSON
        {
          response in
         
            self.pharmacyobject = response.result.value as! NSArray
            
            //print("taille: \(self.pharmacyobject.count)")
            while(self.i < self.pharmacyobject.count)
            {
                let pharmacy2 = self.pharmacyobject[self.i] as! Dictionary<String,Any>
                let pharmacyPicture = pharmacy2["pharma_picture"] as! String
                let pharmacyName = pharmacy2["nom_pharmacie"] as! String
                let pharmanumero = pharmacy2["numeros_pharmacie"] as! String
                let pharmacyville = pharmacy2["ville"] as! String
                let pharmaaddresse = pharmacy2["adresse"] as! String
                let pharmacymode =  pharmacy2["garde"] as! Int
                self.datafilterd.append(Pharmacymodel(pharmacypic: pharmacyPicture, pharmacyname: pharmacyName,pharmacycity: pharmacyville, pharmacygarde: String(pharmacymode),NumeroPharmacy: pharmanumero,phamacyAddress:pharmaaddresse))
                self.i = self.i + 1
              //  print("index: \(self.i)")
            }
            
            self.pharmatableview.reloadData()
        }
        
    }

    func createOrUpdatePharma(indexpath: IndexPath)
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
                if(searchingName)
                {
                    let thispharma = pharmacydatafiltered[indexpath.row]
                    
                    pharmacy.setValue(0, forKey: "id")
                    pharmacy.setValue(thispharma.pharmacyid, forKey: "id_pharmacie")
                    pharmacy.setValue(thispharma.pharmacienid, forKey: "id_pharmacien")
                    
                    pharmacy.setValue(thispharma.pharmacyname, forKey: "adresse")
                    
                    pharmacy.setValue(thispharma.pharmacydescription, forKey: "description_pharmacie")
                    
                    pharmacy.setValue(String(thispharma.pharmacygarde), forKey: "garde")
                    
                    pharmacy.setValue(thispharma.pharmacylongitude, forKey: "longitude")
                    
                    
                    pharmacy.setValue(thispharma.pharmacylatitude, forKey: "latitude")
                    
                    
                    pharmacy.setValue(thispharma.pharmacycountry, forKey: "pay")
                    
                    
                    pharmacy.setValue(thispharma.pharmacypic, forKey: "phamciy_picture")
                    
                    pharmacy.setValue(thispharma.pharmacycity, forKey: "ville")
                    pharmacy.setValue(thispharma.NumeroPharmacy, forKey: "numero_pharmacie")
                    
                    print("when searching")
                }
                else
                {
                    let mypharma = pharmacyobject[indexpath.row] as! Dictionary<String,Any>
                    
                    let idpharmacy = mypharma["id_pharmacie"] as! Int
                    let idpharmacient = mypharma["id_pharmacien"] as! Int
                    let pharmaadresse = mypharma["nom_pharmacie"] as! String
                    let pharmadescription = mypharma["desciprion"] as! String
                    let pharmagarde = mypharma["garde"] as! Int
                    let pharmalongitude = mypharma["longitude"] as! Double
                    let pharmalatitude = mypharma["latitude"] as! Double
                    let pharmapay = mypharma["pay"] as! String
                    let pharmapicture = mypharma["pharma_picture"] as! String
                    let pharmaville = mypharma["ville"] as! String
                    let pharmanumber = mypharma["numeros_pharmacie"] as! String
                    
                    pharmacy.setValue(0, forKey: "id")
                    pharmacy.setValue(idpharmacy, forKey: "id_pharmacie")
                    pharmacy.setValue(idpharmacient, forKey: "id_pharmacien")
                    
                    pharmacy.setValue(pharmaadresse, forKey: "adresse")
                    
                    pharmacy.setValue(pharmadescription, forKey: "description_pharmacie")
                    
                    pharmacy.setValue(String(pharmagarde), forKey: "garde")
                    
                    pharmacy.setValue(pharmalongitude, forKey: "longitude")
                    
                    
                    pharmacy.setValue(pharmalatitude, forKey: "latitude")
                    
                    
                    pharmacy.setValue(pharmapay, forKey: "pay")
                    
                    
                    pharmacy.setValue(pharmapicture, forKey: "phamciy_picture")
                    
                    pharmacy.setValue(pharmaville, forKey: "ville")
                    pharmacy.setValue(pharmanumber, forKey: "numero_pharmacie")
                    
                    print("when not searching")
                }
                
                print("New Inssriont")
               try managedContext.save()
            }
            else
            {
                let pharmacy = result[0] as! NSManagedObject
                
                
                if(searchingName)
                {
                    let thispharma = pharmacydatafiltered[indexpath.row]
                    
                    pharmacy.setValue(thispharma.pharmacyid, forKey: "id_pharmacie")
                    pharmacy.setValue(thispharma.pharmacienid, forKey: "id_pharmacien")
                    
                    pharmacy.setValue(thispharma.phamacyAddress, forKey: "adresse")
                    
                    pharmacy.setValue(thispharma.pharmacydescription, forKey: "description_pharmacie")
                    
                    pharmacy.setValue(String(thispharma.pharmacygarde), forKey: "garde")
                    
                    pharmacy.setValue(thispharma.pharmacylongitude, forKey: "longitude")
                    
                    
                    pharmacy.setValue(thispharma.pharmacylatitude, forKey: "latitude")
                    
                    
                    pharmacy.setValue(thispharma.pharmacycountry, forKey: "pay")
                    
                    
                    pharmacy.setValue(thispharma.pharmacypic, forKey: "phamciy_picture")
                    
                    pharmacy.setValue(thispharma.pharmacycity, forKey: "ville")
                    pharmacy.setValue(thispharma.NumeroPharmacy, forKey: "numero_pharmacie")
                    
                    print("whensarching")
                }
                else
                {
                    let mypharma = pharmacyobject[indexpath.row] as! Dictionary<String,Any>
                    
                    let idpharmacy = mypharma["id_pharmacie"] as! Int
                    let idpharmacient = mypharma["id_pharmacien"] as! Int
                    let pharmaadresse = mypharma["adresse"] as! String
                    let pharmadescription = mypharma["desciprion"] as! String
                    let pharmagarde = mypharma["garde"] as! Int
                    let pharmalongitude = mypharma["longitude"] as! Double
                    let pharmalatitude = mypharma["latitude"] as! Double
                    let pharmapay = mypharma["pay"] as! String
                    let pharmapicture = mypharma["pharma_picture"] as! String
                    let pharmaville = mypharma["ville"] as! String
                    let pharmanumber = mypharma["numeros_pharmacie"] as! String
                    
                    pharmacy.setValue(idpharmacy, forKey: "id_pharmacie")
                    pharmacy.setValue(idpharmacient, forKey: "id_pharmacien")
                    
                    pharmacy.setValue(pharmaadresse, forKey: "adresse")
                    
                    pharmacy.setValue(pharmadescription, forKey: "description_pharmacie")
                    
                    pharmacy.setValue(String(pharmagarde), forKey: "garde")
                    
                    pharmacy.setValue(pharmalongitude, forKey: "longitude")
                    
                    
                    pharmacy.setValue(pharmalatitude, forKey: "latitude")
                    
                    
                    pharmacy.setValue(pharmapay, forKey: "pay")
                    
                    
                    pharmacy.setValue(pharmapicture, forKey: "phamciy_picture")
                    
                    pharmacy.setValue(pharmaville, forKey: "ville")
                    pharmacy.setValue(pharmanumber, forKey: "numero_pharmacie")
                    
                    print("when not searching")
                }
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
       
        createOrUpdatePharma(indexpath: indexPath)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
            else{
                print("Could'nt find the view controller")
                return
        }
       
        navigationController?.pushViewController(mainviewcontroller, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
     /*  let index = sender as? IndexPath
     
        let destination = segue.destination as? DrugTabController
        
        print("valeurindx: \(sender as? IndexPath)")
        
        destination?.pharmadata = pharmacyobject[index!.row] as! Dictionary<String,Any>
 */
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initMyseachBar()
fetchPharmacy()
        // Do any additional setup after loading the view.
    }
}


extension PharmacyViewController: UISearchBarDelegate
{
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
      if(searchText.isEmpty)
      {
   pharmacydatafiltered = datafilterd
         pharmatableview.reloadData()
       }
        else
      {
     
        filterPharmaTableView(index: pharmasearchbar.selectedScopeButtonIndex, text: searchText);
        
        searchingName = true
        pharmatableview.reloadData()

       // print("taille:\(self.pharmacydatafiltered.count)")
    }
        
    }
    
    func filterPharmaTableView(index:Int, text:String)
    {
        switch index {
        case selectedScope.name.rawValue:
            
            pharmacydatafiltered = datafilterd.filter({ (pmod) -> Bool in
            return pmod.pharmacyname.lowercased().contains(text.lowercased())
            })
            pharmatableview.reloadData()
            //print("data: \(pharmacydatafiltered[0].pharmacyname)")
            break
       
        case selectedScope.type.rawValue:
            
                if(text.lowercased() == "g")
                {
                    pharmacydatafiltered = datafilterd.filter({ (pmod) -> Bool in
                        return pmod.pharmacygarde.lowercased().contains("1")
                    })
                    pharmatableview.reloadData()
                }
                else
                {
                    pharmacydatafiltered = datafilterd.filter({ (pmod) -> Bool in
                        return pmod.pharmacygarde.lowercased().contains("0")
                    })
                    pharmatableview.reloadData()
                }
                
            pharmatableview.reloadData()
            print("type")
            break
            
        case selectedScope.ville.rawValue:
            pharmacydatafiltered = datafilterd.filter({ (pmod) -> Bool in
                return pmod.pharmacycity.lowercased().contains(text.lowercased())
            })
            pharmatableview.reloadData()
            print("ville")
            break
       
        default:
            break
        }
    }
    
    
}
