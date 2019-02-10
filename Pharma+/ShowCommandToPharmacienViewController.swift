//
//  ShowCommandToPharmacienViewController.swift
//  Pharma+
//
//  Created by Thony on 1/14/19.
//  Copyright © 2019 Thony. All rights reserved.
//

import UIKit
import AlamofireImage

class ShowCommandToPharmacienViewController: UIViewController
{
    var allcommandes:[Commande] = Commande.generatedModelArray()
    let myNetwork = NetworkTraitement()
    var lncmdurl = ""
    
    var idcommande:Int?
    var totalamount:Double?

    
    @IBOutlet var lbtotalamount: UILabel!
    @IBOutlet var ligneTableView: UITableView!
    
    
    func fetchLigneCommande(url:String)
    {
        myNetwork.getCommandeIdentifiant(url: url)
        {
            json, error in
            
            
            DispatchQueue.main.async {
                
                if(error == nil)
                {
                    let mydata = json as! NSArray
                    for i in 0 ..< mydata.count
                    {
                        let ligncommande = mydata[i] as! Dictionary<String,Any>
                        
                        let idlignecommande = ligncommande["id_lignecommande"] as! Int
                        let idcommande = ligncommande["id_commande"] as! Int
                        let idmedicament = ligncommande["id_medicament"] as! Int
                        let prixunitaire = ligncommande["prix_unitaire"] as! Double
                        let quantitemedicament = ligncommande["quantite"] as! Int
                        let prixtotalligne = ligncommande["prix_totalligne"] as! Double
                        let nommedicament = ligncommande["nom_medicament"] as! String
                        let imagemedicament = ligncommande["image_medicament"] as! String
                        let idpharmacie = ligncommande["id_pharmacie"] as! Int
                        let prixtotal = ligncommande["prix_total"] as! Double
                        let datecommande = ligncommande["date_commande"] as! String
                        let idclient = ligncommande["id_client"] as! Int
                        let code = ligncommande["code"] as! String
                        
                        
                        
                       self.allcommandes.append(Commande(id_lignecommande: idlignecommande, id_commande: idcommande, id_medicament: idmedicament, prix_unitaire: prixunitaire, quantite: quantitemedicament, prix_totalligne: prixtotalligne, nom_medicament: nommedicament, image_medicament: imagemedicament, id_pharmacie: idpharmacie, prix_total: prixtotal, date_commande: datecommande, id_client: idclient, code: code))
                        
                    }
                    
                    self.ligneTableView.reloadData()
                }
                    
                else
                {
                    print("Erreur: \(error.debugDescription)")
                }
                    
                }
            
            }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        lncmdurl = "http://localhost:3000/pharmacy/getlignecommande/"
        
        if(idcommande != nil)
        {
            lncmdurl += String(idcommande!)
        }
        
        if(totalamount != nil)
        {
            lbtotalamount.text = "TotalAmount: " + String(totalamount!)
        }
        
        fetchLigneCommande(url: lncmdurl)
    }
    
    @IBAction func GoBackToscanner(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension ShowCommandToPharmacienViewController:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return  allcommandes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LigneCommande")
        let content = cell?.viewWithTag(0)
        
        let medpic = content?.viewWithTag(1) as? UIImageView
        let lbprixligne = content?.viewWithTag(2) as? UILabel
        let lbnommed = content?.viewWithTag(3) as? UILabel
        let lbquantite = content?.viewWithTag(4) as? UILabel
        
        
        let objlignecommande  = self.allcommandes[indexPath.row]
        
        let urlimage = URL(string: objlignecommande.image_medicament)
        medpic?.af_setImage(withURL: urlimage!)
        lbnommed?.text = objlignecommande.nom_medicament
        lbprixligne?.text = "LignePrice: " + String(objlignecommande.prix_totalligne)
        lbquantite?.text = "Quantity: " + String(objlignecommande.quantite)
        
        return cell!
    }
    
    
}
