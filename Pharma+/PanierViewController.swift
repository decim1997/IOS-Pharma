//
//  PanierViewController.swift
//  Pharma+
//
//  Created by Thony on 12/7/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

class PanierViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var panierTableView: UITableView!
    
    
    @IBOutlet var lbmountpanier: UILabel!
    
    var panierArray:[NSManagedObject] = []
    
    var pharmacyid:Int?
    var pharmaname:String?
    
    let myNetwork = NetworkTraitement()
    
    var url:String  = ""
    
    var commandeId:Int?
    
    var nombretentative:Int?
    
    @IBOutlet var btemptycart: UIButton!
    
    @IBOutlet var imgqrcode: UIImageView!
    
    
    @IBOutlet var btordered: UIButton!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return panierArray.count
    }
    
    
    func getTotalPriceCart() ->Double
    {
      var montantotal = 0.0
        
        if(panierArray.count != 0)
        {
            //var nbelementlessone =  panierArray.count - 1
            for i in  0 ..<  panierArray.count
            {
             //   print("valeur:\(i)")

                let medicament = panierArray[i]
                let qte = medicament.value(forKey: "quantite_produit") as! Double
                let prixunitaire = medicament.value(forKey: "prix_produit") as! Double
                
                montantotal += qte * prixunitaire
              
                //print("montanttotal:'\(montantotal)")
            }
        }
        
        return montantotal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Panier")
        let content = cell?.viewWithTag(0)
        let medpic = content?.viewWithTag(1) as? UIImageView
        let lbmedname = content?.viewWithTag(2) as? UILabel
        let lbmedprice = content?.viewWithTag(3) as? UILabel
        let lbmedquantite = content?.viewWithTag(4) as? UILabel
        let lbprixtotalligne = content?.viewWithTag(5) as? UILabel
        let panier = panierArray[indexPath.row]
        
         let urlimage = URL(string: panier.value(forKey: "image_produit") as! String)
        medpic?.af_setImage(withURL: urlimage!)
        lbmedname?.text =  panier.value(forKey: "nom_produit") as! String
        lbmedprice?.text = String(panier.value(forKey: "prix_produit") as! Double)
        lbmedquantite?.text = String(panier.value(forKey: "quantite_produit") as! Int)
        pharmacyid = panier.value(forKey: "id_pharmacie") as! Int
        let  prix = panier.value(forKey: "prix_produit") as! Double
        let qte = panier.value(forKey: "quantite_produit") as! Double
        let  montant =  prix * qte
        
        //let tmontant = NSString(format: "%.2f",montant) as! String
        
        lbprixtotalligne?.text = "TotalPrice: " + String(format: "%.2f",montant) + " DT"
        
        return cell!
    }
    

    
    func fetchPanier()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Panier")
        
        fetchrequest.predicate = NSPredicate(format: "nom_pharmacie == %@",pharmaname!)
        
        do
        {
            panierArray = try managedContext.fetch(fetchrequest)
            panierTableView.reloadData()
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    
    @IBAction func EmptyCart(_ sender: Any)
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
            fetchrequest.predicate = NSPredicate(format: "nom_pharmacie == %@", self.pharmaname!)
            let deleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest)
            
            do
            {
                
                try  managedContext.execute(deleterequest)
                self.panierArray.removeAll()
                self.panierTableView.reloadData()
                self.lbmountpanier.text = "TotalAmount: " + String(self.getTotalPriceCart()) + " DT "

                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
                    else{
                        print("Could'nt find the view controller")
                        return
                }
                
                self.navigationController?.show(mainviewcontroller, sender: nil)
                
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
    
    func initoutlet()
    {
        self.panierTableView.isHidden = false
        self.lbmountpanier.isHidden = false
        self.btemptycart.isHidden = false
        self.btordered.isHidden = false
        self.imgqrcode.isHidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addSlideMenuButton()
        initoutlet()
        fetchPanier()
        lbmountpanier.text = "TotalAmount: " + String(getTotalPriceCart()) + " DT "
        print(pharmaname)
        nombretentative = panierArray.count
    }
    

    func updatequantite(qte:Int,nom_produit:String)
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let PanierEntity =  NSEntityDescription.entity(forEntityName: "Panier", in: managedContext)
        
        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
        
         fetcherequest.predicate = NSPredicate(format: "nom_produit == %@ AND nom_pharmacie == %@", nom_produit,pharmaname!)
        
        do
        {
            let result = try managedContext.fetch(fetcherequest)
            
            
            if(result.count == 1)
            {
      let panobject = result[0] as! NSManagedObject
                panobject.setValue(qte, forKey:"quantite_produit")
                try managedContext.save()
                
                //print("update with success")

            }
            else
            {
           print("Medicament inexistanet dans le panier")
            }
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    @IBAction func increaseQuantitemed(_ sender: UIStepper)
    {
       // print("increase quantite")
        guard let cell = sender.superview?.superview as? UITableViewCell else
        {
            return
        }
        
        let content = cell.viewWithTag(0)
        let lbqte = content?.viewWithTag(4) as? UILabel
        let medindexpath = panierTableView.indexPath(for: cell)
        let panmed = panierArray[medindexpath!.row]
        
        
       // print(medindexpath)
        
       let  medsteper =  sender
       medsteper.minimumValue = 2
        
       // medsteper.value = Double(panmed.value(forKey: "quantite_produit") as! Int)
        
       //  var valeur = Int(medsteper.value) + 1
        
       
        
        
        lbqte?.text = Int(sender.value).description
        panmed.setValue(Int(medsteper.value), forKey: "quantite_produit")
        let nom_produit = panmed.value(forKey: "nom_produit") as! String
        let qte = panmed.value(forKey: "quantite_produit")  as!  Int
        updatequantite(qte: qte, nom_produit: nom_produit)
        panierTableView.reloadData()
        lbmountpanier.text = "TotalAmount: " + String(format: "%.2f",getTotalPriceCart()) + " DT "
     //   print("valeur: \(Int(medsteper.value) )")
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == .delete)
        {
            guard let mydelegate = UIApplication.shared.delegate as? AppDelegate
                else
            {
                return
            }
            
            let  managedContext = mydelegate.persistentContainer.viewContext
            
            managedContext.delete(panierArray[indexPath.row])
            
            do
            {
            try managedContext.save()
            panierArray.remove(at: indexPath.row)
            panierTableView.reloadData()
            self.lbmountpanier.text = "TotalAmount: " + String(format: "%.2f",self.getTotalPriceCart()) + " DT "
            }
            catch let error as NSError
            {
                print("Erreur: \(error)")
            }
        }
    }
    
    
    
    @IBAction func removeMedFromPanier(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete this medicament??", preferredStyle: .alert)
        
        let actionyes = UIAlertAction(title: "yes", style: .default, handler: {(actionyes) in
            
          guard let cell = sender.superview?.superview as? UITableViewCell
            else{ return }
            
            guard let mydelegate = UIApplication.shared.delegate as? AppDelegate
                else
            {
                return
            }
            
            let  managedContext = mydelegate.persistentContainer.viewContext
            
            let indexmed = self.panierTableView.indexPath(for: cell)
            
            managedContext.delete(self.panierArray[indexmed!.row])
            
            do
            {
                try managedContext.save()
                self.panierArray.remove(at: indexmed!.row)
                self.panierTableView.reloadData()
                
                if(self.getTotalPriceCart() == 0)
                {
             
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "PharmacyDrugViewController") as? PharmacyDrugViewController
                        else{
                            print("Could'nt find the view controller")
                            return
                    }
                    
                    self.navigationController?.show(mainviewcontroller, sender: nil)
                }
                
                self.lbmountpanier.text = "TotalAmount: " + String(format: "%.2f",self.getTotalPriceCart()) + " DT "
            }
            catch let error as NSError
            {
                print("Erreur: \(error)")
            }
            
            
        })
        
        let actionno = UIAlertAction(title: "No", style: .default) { (actionno) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        
        present(alert,animated: true)
    }
    
    
    
    @IBAction func OrderedMedicament(_ sender: UIButton)
    {
       let alert = UIAlertController(title: "Command", message: "Do you want to pass your command", preferredStyle: .alert)
        
        let actionyes = UIAlertAction(title: "Yes", style: .default) { (actionyes) in
            
            guard let idpharmacy = self.pharmacyid else {return}
            let totalprice = self.getTotalPriceCart()
            let date = Date()
            let formater = DateFormatter()
            formater.dateFormat = "dd.MM.yyyy"
            let resultdate = formater.string(from: date)
            let idclient = 1
            let length = 32
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
            let code = String(randomCharacters)
            
            self.url = "http://localhost:3000/pharmacy/customer/addcommande"
            self.myNetwork.goForRecordCommand(url: self.url, idpharmacie: idpharmacy, prixtotal: totalprice, datecommande: resultdate, code: code)
            {
                json,error in
                
                DispatchQueue.main.async {
                   
                   if(error == nil)
                   {
                  self.url = "http://localhost:3000/pharmacy/getidcommande/"
                  self.url += code
                    
                    self.myNetwork.getCommandeIdentifiant(url: self.url)
                  {
                  json,error in
                    
                    DispatchQueue.main.async {
                        
                        if(error == nil)
                        {
                            guard let data = json![0] as? Dictionary<String,Any> else{return}
                            
                            if(data != nil)
                            {
                                self.commandeId = data["id_commande"] as! Int
                                
                            //    print("CommadeId:\(self.commandeId)")
                                self.url = "http://localhost:3000/pharmacy/customer/addlignecommande"
                                
                                for i in 0..<self.panierArray.count
                                {
                                var cartobjet = self.panierArray[i]
                                    guard let idmedicament = cartobjet.value(forKey: "id_produit") as? Int else{return}
                                    guard let prixunitaire = cartobjet.value(forKey: "prix_produit") as? Double else{return}
                                    guard let quantite = cartobjet.value(forKey: "quantite_produit") as? Int else {return}
                                    guard let nomedicament = cartobjet.value(forKey: "nom_produit") as? String else{return}
                                    guard let imagemedicament = cartobjet.value(forKey: "image_produit") as? String else{return}
                        
                                    self.myNetwork.goForLigneCommandRecord(url: self.url, idcommande: self.commandeId!, idmedicament: idmedicament, prixunitaire: prixunitaire, quantite: quantite, nommedicament: nomedicament, imagemedicament: imagemedicament)
                            {
                            json,error in
                                
                                DispatchQueue.main.async {
                                    if(error == nil)
                                    {
                                     
                                        self.nombretentative! = self.nombretentative! - 1
                                        
                                        print("nbrtentative:\(self.nombretentative)")
                                        if(self.nombretentative! == 0)
                                        {
                                            let alert = UIAlertController(title: "Success", message: "Your ordered was record with success", preferredStyle: .alert)
                                            let action = UIAlertAction(title: "Ok", style: .default, handler: { (myaction) in
                                                
                                                guard let mydelegate = UIApplication.shared.delegate as? AppDelegate
                                                    else
                                                {
                                                    return
                                                }
                                                
                                                let  managedContext = mydelegate.persistentContainer.viewContext
                                                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
                                                fetchrequest.predicate = NSPredicate(format: "nom_pharmacie == %@", self.pharmaname!)
                                                let deleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest)
                                                
                                               
                                                
                                                do
                                                {
                                                    try  managedContext.execute(deleterequest)
                                                    self.panierArray.removeAll()
                                                    self.panierTableView.reloadData()
                                                    self.lbmountpanier.text = "TotalAmount: " + String(self.getTotalPriceCart()) + " DT "
                                                    
                                                    self.panierTableView.isHidden = true
                                                    self.lbmountpanier.isHidden = true
                                                    self.btemptycart.isHidden = true
                                                    self.btordered.isHidden = true
                                                    
                                                    
                                                    let myString = code
                                                    print("Codegenerate\(code)")
                                                    // {
                                                    let data = myString.data(using: .ascii, allowLossyConversion: false)
                                                    let filter = CIFilter(name: "CIQRCodeGenerator")
                                                    filter?.setValue(data, forKey: "inputMessage")
                                                    let ciImage = filter?.outputImage
                                                    let transform = CGAffineTransform(scaleX: 10, y: 10)
                                                    let transformImage = ciImage?.transformed(by: transform)
                                                    let img = UIImage(ciImage: transformImage!)
                                                    
                                                    self.imgqrcode.image = img
                                                    self.imgqrcode.isHidden = false
                                                    
                                            
                                                }
                                                catch let error as NSError
                                                {
                                                    print(error)
                                                }
                                            })
                                            print("reusitte1")
                                            alert.addAction(action)
                                            self.present(alert,animated: true)
                                          
                                        }
                                        
                                      
                                    }
                                    else
                                    {
                                  print("Our error\(error)")
                                    }
                                }
                            }
                                    
                                    /*print("idmedcament\(idmedicament)")
                                    print("mycommandeident\(self.commandeId)")
                                    print("prixunitaire\(prixunitaire)")
                                    print("quantite\(quantite)")
                                    print("nommedicament\(nomedicament)")
                                    print("imagemedicament\(imagemedicament)")*/
                                }
                            }
                            
                        }
                        else
                        {
                            print("errorgetidcommande:\(error)")
                        }
                    }
                }
                    
                }
                    else
                   {
                 print("error\(error)")
                    }
                }
            }
            
        }
        
        let actionno = UIAlertAction(title: "No", style: .default, handler: nil)
        
        
        alert.addAction(actionyes)
        alert.addAction(actionno)
        self.present(alert,animated: true)
        
    }
    
}
