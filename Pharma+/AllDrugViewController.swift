//
//  AllDrugViewController.swift
//  Pharma+
//
//  Created by Thony on 12/3/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Network
import CoreData


enum searchescope:Int
{
    case Name = 0
    
    case Categorie = 1
}

class AllDrugViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

    var url = ""
    
    let myNetwork = NetworkTraitement()
    
    var compt:Int = 0
    
    @IBOutlet var medCollectionView: UICollectionView!
    
    
    @IBOutlet var medsearchbar: UISearchBar!
    
    lazy var MedArray:NSArray =
        {
            var  med:NSArray = []
            
            return med
    }()
    
    lazy var MedObject:[MedicamentObject] = MedicamentObject.generateMedicamentArray()
    
    lazy var MedObjectfilter:[MedicamentObject] = MedicamentObject.generateMedicamentArray()
    
    
    
    var searching = false
    
    
    var panierbutton:UIBarButtonItem! = nil
    
    var urloffmed = ""
    
    var verififfavor = false;
    
    @IBAction func ShowMedDescription(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview as? UICollectionViewCell else{return}
        let index = medCollectionView.indexPath(for: cell)
        
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
   
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "DetaiDrugViewController") as? DetaiDrugViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        
        if(searching)
        {
            
            mainviewcontroller.nommed =  MedObjectfilter[index!.row].nom_medicament
            mainviewcontroller.imgmed = MedObjectfilter[index!.row].image_medicament
            mainviewcontroller.quantitemed = MedObjectfilter[index!.row].quantite
            mainviewcontroller.meddesc = MedObjectfilter[index!.row].desc_med
            mainviewcontroller.prximed = MedObjectfilter[index!.row].prix_medicament
            
        }
        else
        {
            mainviewcontroller.nommed =  MedObject[index!.row].nom_medicament
            mainviewcontroller.imgmed = MedObject[index!.row].image_medicament
            mainviewcontroller.quantitemed = MedObject[index!.row].quantite
            mainviewcontroller.meddesc = MedObject[index!.row].desc_med
            mainviewcontroller.prximed = MedObject[index!.row].prix_medicament
        }
        navigationController?.present(mainviewcontroller,animated: true)
    }
    
    
    func verifIfmedicamentisfavorite(index:IndexPath, mybutton:UIButton)
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
         let managedContext = mydelegate.persistentContainer.viewContext
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicament")
        if(searching)
        {
            
            fetcherequest.predicate = NSPredicate(format: "nom_medicament == %@", MedObjectfilter[index.row].nom_medicament)
            do
            {
                let result = try managedContext.fetch(fetcherequest)
                
                if(result.count == 0)
                {
                }
                else
                {
                    verififfavor = !verififfavor
                    mybutton.backgroundColor = UIColor.red
                }
            }
            catch let error as NSError
            {
                print("Error: \(error.userInfo)")
            }
        }
        else
        {
            fetcherequest.predicate = NSPredicate(format: "nom_medicament == %@", MedObject[index.row].nom_medicament)
            
            
            do
            {
                let result = try managedContext.fetch(fetcherequest)
                
                
                if(result.count == 0)
                {
                }
                else
                {
                    verififfavor = !verififfavor
                     mybutton.backgroundColor = UIColor.red
                }
            }
            catch let error as NSError
            {
                print("Error: \(error.userInfo)")
            }

        }
        
    }
    
    @IBAction func FavoriteMed(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview as? UICollectionViewCell
            else{return}
        
        let index = medCollectionView.indexPath(for: cell)
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let content = cell.viewWithTag(0)
        let btstart = content?.viewWithTag(5) as? UIButton
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let MedFavEntity = NSEntityDescription.entity(forEntityName: "Medicament", in: managedContext)
        
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicament")
        
        print("index:\(index!.row)")
        if(searching)
        {
          
            fetcherequest.predicate = NSPredicate(format: "nom_medicament == %@", MedObjectfilter[index!.row].nom_medicament)
            
            do
            {
                 let result = try managedContext.fetch(fetcherequest)
                
                if(result.count == 0)
                {
                    print("Inexistant")
                    
                    let medfav = NSManagedObject(entity: MedFavEntity!, insertInto: managedContext)
                    
                    medfav.setValue(MedObjectfilter[index!.row].id_medicament, forKey: "id_medicament")
                    medfav.setValue(MedObjectfilter[index!.row].nom_medicament, forKey: "nom_medicament")
                    
                    medfav.setValue(MedObjectfilter[index!.row].prix_medicament, forKey: "prix_medicament")
                    
                    medfav.setValue(MedObjectfilter[index!.row].image_medicament, forKey: "image_medicament")
                    
                    medfav.setValue(MedObjectfilter[index!.row].forme_medicament, forKey: "nom_forme")
                    
                    medfav.setValue(MedObjectfilter[index!.row].nom_categ_med, forKey: "nom_categorie")
                    
                    medfav.setValue(MedObjectfilter[index!.row].desc_med, forKey: "descriptiom")
                    
                    medfav.setValue(MedObjectfilter[index!.row].id_categorie, forKey: "id_categorie")
                    
                    medfav.setValue(MedObjectfilter[index!.row].id_forme, forKey: "id_forme")
                    
                    medfav.setValue(MedObjectfilter[index!.row].id_type, forKey: "id_type")
                    
                    medfav.setValue(MedObjectfilter[index!.row].type_med, forKey: "type")
                    
                    medfav.setValue(MedObjectfilter[index!.row].ordonance_medicament, forKey: "ordonnance")
                    
                    try managedContext.save()
                    
                    btstart?.backgroundColor = UIColor.red
                    print("ajoute")
                }
                else
                {
                    let deleterequest = NSBatchDeleteRequest(fetchRequest: fetcherequest)
                    try  managedContext.execute(deleterequest)
                     btstart?.backgroundColor = UIColor.white
              print("suppression")
                }
            }
            catch let error as NSError
            {
                print("Error: \(error.userInfo)")
            }
            
        }
        else
        {
            fetcherequest.predicate = NSPredicate(format: "nom_medicament == %@", MedObject[index!.row].nom_medicament)

            do
            {
                 let result = try managedContext.fetch(fetcherequest)
                
                print("nbrelement:\(result.count)")
                
                print(result)
                if(result.count == 0)
                {
              print("Inexistant")
                    
                    let medfav = NSManagedObject(entity: MedFavEntity!, insertInto: managedContext)
                    
                    medfav.setValue(MedObject[index!.row].id_medicament, forKey: "id_medicament")
                    medfav.setValue(MedObject[index!.row].nom_medicament, forKey: "nom_medicament")
                    
                    medfav.setValue(MedObject[index!.row].prix_medicament, forKey: "prix_medicament")

               medfav.setValue(MedObject[index!.row].image_medicament, forKey: "image_medicament")
                    
    medfav.setValue(MedObject[index!.row].forme_medicament, forKey: "nom_forme")
                    
      medfav.setValue(MedObject[index!.row].nom_categ_med, forKey: "nom_categorie")
          
     medfav.setValue(MedObject[index!.row].desc_med, forKey: "descriptiom")
                    
                    medfav.setValue(MedObject[index!.row].id_categorie, forKey: "id_categorie")

                     medfav.setValue(MedObject[index!.row].id_forme, forKey: "id_forme")
                    
                     medfav.setValue(MedObject[index!.row].id_type, forKey: "id_type")
                    
               medfav.setValue(MedObject[index!.row].type_med, forKey: "type")
                    
               medfav.setValue(MedObject[index!.row].ordonance_medicament, forKey: "ordonnance")
                    
                 try managedContext.save()
                    btstart?.backgroundColor = UIColor.red
                 print("ajoute")
                }
                else
                {
                    
                  let deleterequest = NSBatchDeleteRequest(fetchRequest: fetcherequest)
                    try  managedContext.execute(deleterequest)
                    btstart?.backgroundColor = UIColor.white
                    print("suppresion effectue")
                }
            }
            catch let error as NSError
            {
                print("Error: \(error.userInfo)")
            }
            
        }
        
    }
    
    func AddAlert(title:String, message:String, titleaction:String)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: titleaction, style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert,animated: true)
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
    
    
    
   
    

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
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
        let mybutton = cell.viewWithTag(5) as? UIButton
        let starbutton = UIButton(type: .system)
        starbutton.setImage(UIImage(named: "fav_star"), for: .normal)
        starbutton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starbutton.backgroundColor = UIColor.red
      
        

        verifIfmedicamentisfavorite(index: indexPath, mybutton: mybutton!)
        
      /*  if(verififfavor == true)
        {
            print("we get in")
            mybutton?.backgroundColor = UIColor.red
        }*/
        
        
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
    
 
  
    
    func fetchMedicament()
    {
        url = "http://localhost:3000/pharma/listmed"
       
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
            
           self.MedObject.append(MedicamentObject(id_medicament: id_medicament, nom_medicament: nom_medicament, image_medicament: image_medicament, prix_medicament: prix, quantite: quantite, ordonance_medicament: ordonnance, id_type: id_type, id_categorie: id_categorie, id_forme: id_forme, nom_categ_med: nom_categorie, type_med: type, desc_med: descriptiom, forme_medicament: nom_forme))
            
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
    
 
    
    func initMyseachBar()
    {
    medsearchbar.selectedScopeButtonIndex = 0
        print("ok")
    }

    @objc func clickonCartIcon()
    {
 /// print("click on icon")
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //PanierViewController
        //
        guard let panierview = mainstoryboard.instantiateViewController(withIdentifier: "PanierViewController") as? PanierViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        
        navigationController?.pushViewController(panierview, animated: true)
        //ToPanier
    }
    func initPaniericone()
    {
        
         panierbutton = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(clickonCartIcon)) // action:#selector(Class.MethodName) for swift 3
        
        panierbutton.tintColor = UIColor.orange
        
        panierbutton.isEnabled = false
        
        self.navigationItem.rightBarButtonItem  = panierbutton
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         fetchMedicament()
          initMyseachBar()
        //initPaniericone()
        /*if(getNumberofElementinpanier() > 0)
        {
         panierbutton.isEnabled = true
        }*/
    }
    
}


extension AllDrugViewController:UISearchBarDelegate
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
        
        var urloffmed = "http://localhost:3000/pharmacylist/"
        
        
        if(searching)
        {
            urloffmed += MedObjectfilter[indexPath.row].nom_medicament
        }
        else
        {
            urloffmed += MedObject[indexPath.row].nom_medicament
        }
        
        myNetwork.getPharmacyWithMedCheeking(url: urloffmed)
        {
            json,error in
            
            DispatchQueue.main.async
                {
                    
                    if(error == nil)
                    {
                        
                        if(json!.count  > 0)
                        {
                         self.performSegue(withIdentifier: "GoToPharmacy", sender: indexPath)
                        }
                        else
                        {
                            let alert = UIAlertController(title: "NOT FOUND", message: "This medication is not avalable", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert,animated: true)
                            
                        }
                        
                    }
                    else
                    {
                        print("ErroAlamofire:\(error)")
                    }
                    
            }
        }
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
