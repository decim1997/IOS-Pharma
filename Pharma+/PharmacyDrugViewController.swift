//
//  PharmacyDrugViewController.swift
//  Pharma+
//
//  Created by Thony on 12/16/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData



class PharmacyDrugViewController: BaseViewController
{
    var url = ""
    
    let myNetwork = NetworkTraitement()
    
    var compt:Int = 0
    var idpharmacy:Int?
    lazy var MedObject:[MedicamentObject] = MedicamentObject.generateMedicamentArray()
    
    lazy var MedObjectfilter:[MedicamentObject] = MedicamentObject.generateMedicamentArray()
    
    var searching = false
    
    @IBOutlet var medsearchbar: UISearchBar!
    
    @IBOutlet var medCollectionView: UICollectionView!
    
    @IBOutlet var btcart: UIButton!
    
    @IBOutlet var lbnombre: UILabel!
    
    lazy var MedArray:NSArray =
        {
            var  med:NSArray = []
            
            return med
    }()
    
    var PharmacyArray:[NSManagedObject] = []

    
    func fetchMedicament()
    {
        
         let pharmacy = self.PharmacyArray[0]
         guard let pharmacyid = pharmacy.value(forKey: "id_pharmacie") as? Int else {return}
        idpharmacy = pharmacyid
        url = "http://localhost:3000/allmedicamentinthispharmacy/"
        url += String(pharmacyid)
        myNetwork.getAllMedicament(url: url)
        {
            json, error in
            
            DispatchQueue.main.async {
                
                if(error == nil)
                {
                    self.MedArray = json as! NSArray
                    
                    while(self.compt < self.MedArray.count)
                    {
                        let medicament = self.MedArray[self.compt] as! Dictionary<String,Any>
                        
                        let id_medicament = medicament["id_medicament"] as! Int
                        let nom_medicament = medicament["nom_medicament"] as! String
                        let image_medicament = medicament["image_medicament"] as!String
                        let prix = medicament["prix"] as! Double
                        let quantite = medicament["quantite"] as! Int
                        let ordonnance = medicament["ordonnance"] as! Int
                        let id_type = medicament["id_type"] as! Int
                        let id_categorie = medicament["id_categorie"] as! Int
                        let id_forme = medicament["id_forme"] as! Int
                        let nom_categorie = medicament["nom_categorie"] as! String
                        let type = medicament["type"] as! String
                        let descriptiom = medicament["descriptiom"] as! String
                        let nom_forme = medicament["nom_forme"] as! String
                        let id_pharmacie = medicament["id_pharmacie"] as! Int
                        let pharmacy_name = medicament["nom_pharmacie"] as! String
                        
                        self.MedObject.append(MedicamentObject(id_medicament: id_medicament, nom_medicament: nom_medicament, image_medicament: image_medicament, prix_medicament: prix, quantite: quantite, ordonance_medicament: ordonnance, id_type: id_type, id_categorie: id_categorie, id_forme: id_forme, nom_categ_med: nom_categorie, type_med: type, desc_med: descriptiom, forme_medicament: nom_forme,id_pharmacie:id_pharmacie,nom_pharmacy:pharmacy_name))
                        
                        self.compt = self.compt + 1
                        
                    }
                    self.medCollectionView.reloadData()
                }
                else
                {
                    print("Erreur: \(error.debugDescription)")
                }
            }
            
        }
        
    }
    
    
    func getNumberofElementinpanier() -> Int
    {
        
        
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return -1
        }
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let PanierEntity =  NSEntityDescription.entity(forEntityName: "Panier", in: managedContext)
        
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
        
        do
        {
            let result = try managedContext.fetch(fetcherequest)
            
            return result.count
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
        
        return -2
    }
    
    func initBtCart()
    {
        btcart.isHidden = true
        lbnombre.isHidden = true
    }
    
    func initMyseachBar()
    {
        medsearchbar.selectedScopeButtonIndex = 0
        print("ok")
    }
    
    func fetchPharmacyData()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "SessionPharmacy")
        
        do
        {
            PharmacyArray = try managedContext.fetch(fetchrequest)
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       addSlideMenuButton()
        fetchPharmacyData()
        initMyseachBar()
        fetchMedicament()
         initBtCart()        
        if(getNumberofElementinpanier() > 0)
        {
            btcart.isHidden = false
            lbnombre.text = String(getNumberofElementinpanier())
            lbnombre.isHidden = false
        }
        
    }
    
    @IBAction func EmptyCart()
    {
        
        let alert = UIAlertController(title: "Empty cart", message: "Do you want to empty cart??", preferredStyle: .alert)
        
        let actionyes = UIAlertAction(title: "Yes", style: .cancel, handler: {(actionyes) in
            
            guard let mydelegate = UIApplication.shared.delegate as? AppDelegate
                else
            {
                return
            }
            
            let  managedContext = mydelegate.persistentContainer.viewContext
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
            let deleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest)
            
            do
            {
                
                try  managedContext.execute(deleterequest)
              //  self.panierArray.removeAll()
               // self.panierTableView.reloadData()
                //self.lbmountpanier.text = "TotalAmount: " + String(self.getTotalPriceCart()) + " DT "
                
            }
            catch let error as NSError
            {
                print(error)
            }
            
        })
        
        let actionno = UIAlertAction(title: "No", style: .default) { (actionno) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        
        present(alert,animated: true)
    }
    
    
    @IBAction func FavoriteMed(_ sender: UIButton)
    {
        print("Favoirete med")
    }
    
    func AddAlert(title:String, message:String, titleaction:String)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: titleaction, style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert,animated: true)
    }
    
    func AddMedtoPanier(id_pharmacie:Int, id_produit:Int,image_produit:String,nom_produit:String,prix_produit:Double,quantite_produit:Int,nompharmacie:String)
    {
        
        //EmptyCart()
        
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let PanierEntity =  NSEntityDescription.entity(forEntityName: "Panier", in: managedContext)
        
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")

        fetcherequest.predicate = NSPredicate(format: "id_pharmacie == %id_pharmacie AND nom_produit == %@",id_pharmacie,nom_produit)
        
        do
        {
            let result = try managedContext.fetch(fetcherequest)
          
            print("resultattrouver:\(result.count)")
            
            if(result.count == 0)
            {
                let panier =  NSManagedObject(entity: PanierEntity!, insertInto: managedContext)
                
                panier.setValue(id_produit, forKey: "id_produit")
                panier.setValue(nom_produit, forKey: "nom_produit")
                panier.setValue(prix_produit, forKey: "prix_produit")
                panier.setValue(quantite_produit, forKey: "quantite_produit")
                panier.setValue(image_produit, forKey: "image_produit")
                panier.setValue(id_pharmacie, forKey: "id_pharmacie")
                panier.setValue(nompharmacie, forKey: "nom_pharmacie");
                try managedContext.save()
                
                AddAlert(title: "Success", message: "Medicament add to cart", titleaction: "Ok")
            }
            else
            {
                AddAlert(title: "Error", message: "This medicament is already in your cart", titleaction: "Ok")
            }
        }
            
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
        
    }
    
    
    @IBAction func AddToCart(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview as? UICollectionViewCell else
        {
            return
        }
        
   
        let medindexpath = medCollectionView.indexPath(for: cell)
        
        if(searching == true)
        {
            let medtoaddcartfilt = MedObjectfilter[medindexpath!.row]
            
            
            AddMedtoPanier(id_pharmacie:medtoaddcartfilt.id_pharmacie,id_produit:medtoaddcartfilt.id_medicament,image_produit:medtoaddcartfilt.image_medicament,nom_produit:medtoaddcartfilt.nom_medicament,prix_produit:medtoaddcartfilt.prix_medicament,quantite_produit:1,nompharmacie:medtoaddcartfilt.nom_pharmacy)
            
            lbnombre.text = String(getNumberofElementinpanier())
            lbnombre.isHidden = false
            btcart.isHidden = false
        }
        else
        {
            
           
            let medtoadcart = MedObject[medindexpath!.row]
            
            AddMedtoPanier(id_pharmacie:medtoadcart.id_pharmacie, id_produit:medtoadcart.id_medicament,image_produit:medtoadcart.image_medicament,nom_produit:medtoadcart.nom_medicament,prix_produit:medtoadcart.prix_medicament,quantite_produit:1,nompharmacie:medtoadcart.nom_pharmacy)
            lbnombre.text = String(getNumberofElementinpanier())
            lbnombre.isHidden = false
            btcart.isHidden = false

            print("pharmaciid:\(medtoadcart.id_pharmacie)")
        }
    }
    

   
    @IBAction func displayCart(_ sender: UIButton)
    {
 
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "CartController") as? CartControllerTableViewController
        else {
                print("Could'nt find the view controller")
                return
        }
        
        navigationController?.show(mainviewcontroller, sender: nil)
    }
    
}


extension PharmacyDrugViewController:UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(searching)
        {
            return MedObjectfilter.count
        }
        else
        {
            // print("Taille:\(MedObject.count)")
            return MedObject.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        let  cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Medicament", for: indexPath)
        let medpic = cell.viewWithTag(1) as? UIImageView
        let lbname = cell.viewWithTag(2) as? UILabel
        let lbprix = cell.viewWithTag(3) as? UILabel
        let starbutton = UIButton(type: .system)
        starbutton.setImage(UIImage(named: "fav_star"), for: .normal)
        starbutton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        
        if(searching)
        {
            let mymedicament = MedObjectfilter[indexPath.row]
            
            let urlimage = URL(string: mymedicament.image_medicament)
            
            
            medpic?.af_setImage(withURL: urlimage!)
            lbname?.text = mymedicament.nom_medicament
            lbprix?.text = String(mymedicament.prix_medicament) + " DT"
        }
        else
        {
            let mymedicament = MedObject[indexPath.row]
            
            let urlimage = URL(string: mymedicament.image_medicament)
            medpic?.af_setImage(withURL: urlimage!)
            lbname?.text = mymedicament.nom_medicament
            lbprix?.text = String(mymedicament.prix_medicament) + " DT"
        }
        
        return cell
    }
    
}



extension PharmacyDrugViewController:UISearchBarDelegate
{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("yesss")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchText.isEmpty)
        {
            MedObjectfilter = MedObject
            medCollectionView.reloadData()
            
            print("okkk4")
        }
        else
        {
            
            
            print("ok333")
            filterMedCollectionView(index: medsearchbar.selectedScopeButtonIndex, text:searchText)
            
            searching = true
            self.medCollectionView.reloadData()
        }
        
    }
    
    
    func filterMedCollectionView(index:Int, text:String)
    {
        
        switch index {
        case searchescope.Name.rawValue :
            MedObjectfilter = MedObject.filter({ (med) -> Bool in
                return med.nom_medicament.lowercased().contains(text.lowercased())
            })
            break;
            
        case searchescope.Categorie.rawValue:
            MedObjectfilter = MedObject.filter({ (med) -> Bool in
                return med.nom_categ_med.lowercased().contains(text.lowercased())
            })
            break;
        default:
            break;
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "GoToPharmacy", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "GoToPharmacy")
        {
            let indexpath = sender as! IndexPath
            let destination = segue.destination as? ListPharmaViewController
            if(searching)
            {
                print("index:\(indexpath.row)")
                
                destination?.medicamentName = MedObjectfilter[indexpath.row].nom_medicament
            }
            else
            {
                print("index:\(indexpath.row)")
                
                destination?.medicamentName = MedObject[indexpath.row].nom_medicament
            }
        }
    }
    
    
    
    
}
