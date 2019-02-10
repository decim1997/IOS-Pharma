//
//  CommandeViewController.swift
//  Pharma+
//
//  Created by Thony on 12/22/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData

class CommandeViewController: ClientOwnInterface
{
    let myNetwork = NetworkTraitement()
    let session = PersonneSession()
    var objetsession :[NSManagedObject] = []
    var url = ""
    
    lazy var commandeArray:NSArray =
        {
            var  comm:NSArray = []
            
            
            return comm
    }()
    var allcommandes:[Commande] = Commande.generatedModelArray()
    
    @IBOutlet var commandeTableView: UITableView!
    
    func fetchCommande()
    {
        url = "http://localhost:3000/pharmacy/getallUserCommande/"
        
        let user = objetsession[0]
      guard  let userid = user.value(forKey: "id") as? Int else{return}
        
        print("userid\(userid)")
        url += String(userid)
        myNetwork.getCommandeIdentifiant(url: url)
        {
            json, error in
            
            DispatchQueue.main.async {
                
                if(error == nil)
                {
                    print("Jsondata\(json!)")
                    
                    self.commandeArray = json as! NSArray
                    
                    for i in 0 ..< self.commandeArray.count
                    {
                        let order = self.commandeArray[i] as! Dictionary<String,Any>
                        
         let idcommande = order["id_commande"] as! Int
         let idpharmacie = order["id_pharmacie"] as! Int
         let idpharmacien = order["id_pharmacien"] as! Int
         let prixtotal = order["prix_total"] as! Double
         let datecommande = order["date_commande"] as! String
         let idclient = order["id_client"] as! Int
         let code = order["code"] as! String
         let ville = order["ville"] as! String
         let pay = order["pay"] as! String
         let nompharmacie = order["nom_pharmacie"] as! String
         let numerospharmacie = order["numeros_pharmacie"] as! String
        let adresse = order["adresse"] as! String
        let  pharmapicture = order["pharma_picture"] as! String
        let longitude = order["longitude"] as! Double
        let latitude = order["latitude"] as! Double
     
        self.allcommandes.append(Commande(id_commande: idcommande, id_pharmacie: idpharmacie, prix_total: prixtotal, date_commande: datecommande, id_client: idclient, code: code, id_pharmacien: idpharmacien, nom_pharmacie: nompharmacie, ville: ville, pay: pay, numeros_pharmacie: numerospharmacie, adresse: adresse, pharmapicture: pharmapicture, longitude: longitude, latitude: latitude))
                    }
             self.commandeTableView.reloadData()
                }
                else
                {
                    print("Erreur: \(error.debugDescription)")
                }
            }
            
        }
    }
    
        
    
    
    @IBAction func ShowQRCode(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview as? UITableViewCell else{ return }
        
        let indexcmd = self.commandeTableView.indexPath(for: cell)
        
        let mycommande = allcommandes[indexcmd!.row]
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainviewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "QRCodeshowerViewController") as?
        QRCodeshowerViewController
            else{
                print("Could'nt find the view controller")
                return
        }
        
        

        
        
        mainviewcontroller.code = mycommande.code
        navigationController?.present(mainviewcontroller, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addSlideMenuButton()
       objetsession = session.getPersonneSession()
      fetchCommande()
        
    }
    
}


extension CommandeViewController:UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allcommandes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commande")
        let content = cell?.viewWithTag(0)
        let lbdatecommande = content?.viewWithTag(1) as? UILabel
        let lbmontant = content?.viewWithTag(2) as? UILabel
        let lbpharmaname = content?.viewWithTag(4) as? UILabel
        
        let objcomamde = allcommandes[indexPath.row]
        
        lbdatecommande?.text = objcomamde.date_commande
        lbmontant?.text = "Total Amount: " + String(objcomamde.prix_total) + " DT"
        lbpharmaname?.text = "Pharmacy: " + objcomamde.nom_pharmacie
        
        return cell!
    }
    
}


