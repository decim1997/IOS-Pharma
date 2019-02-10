//
//  Commande.swift
//  Pharma+
//
//  Created by Thony on 12/22/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import Foundation


class Commande:NSObject
{
    var id_commande:Int = 0
    var id_pharmacie:Int = 0
    var prix_total:Double = 0
    var date_commande:String = ""
    var id_client:Int = 0
    var code:String = ""
    var id_pharmacien:Int = 0
    var nom_pharmacie:String = ""
    var ville:String = ""
    var numeros_pharmacie:String = ""
    var adresse:String = ""
    var pharmapicture:String = ""
    var longitude:Double = 0
    var latitude:Double = 0
    var pay:String = ""
    
    var id_lignecommande:Int = 0
    var id_medicament:Int = 0
    var prix_unitaire:Double = 0
    var quantite:Int = 0
    var prix_totalligne:Double = 0
    var nom_medicament:String = ""
    
    var image_medicament:String = ""
    init(id_lignecommande:Int,id_commande:Int,id_medicament:Int,prix_unitaire:Double,quantite:Int,prix_totalligne:Double,nom_medicament:String,image_medicament:String,id_pharmacie:Int,prix_total:Double,date_commande:String,id_client:Int,code:String)
     {
        self.id_lignecommande = id_lignecommande;
        self.id_commande = id_commande
        self.id_medicament = id_medicament
        self.prix_unitaire = prix_unitaire
        self.quantite = quantite
        self.prix_totalligne = prix_totalligne
        self.nom_medicament = nom_medicament
        self.image_medicament = image_medicament
        self.id_pharmacie = id_pharmacie
        self.prix_total = prix_total
        self.date_commande = date_commande
        self.id_client = id_client
        self.code = code
        
    }
    
     init(id_commande:Int,id_pharmacie:Int , prix_total:Double , date_commande:String,id_client:Int , code:String)
     {
        self.id_commande = id_commande
        self.id_pharmacie = id_pharmacie
        self.prix_total = prix_total
        self.date_commande = date_commande
        self.id_client = id_client
        self.code = code
        
    }
    
     init(id_commande:Int,id_pharmacie:Int , prix_total:Double , date_commande:String , id_client:Int , code:String ,
     id_pharmacien:Int ,
     nom_pharmacie:String ,
     ville:String ,
     pay:String,
     numeros_pharmacie:String ,
     adresse:String ,
     pharmapicture:String ,
     longitude:Double ,
     latitude:Double )
    {
    self.id_commande = id_commande
    self.id_pharmacie = id_pharmacie
    self.id_pharmacien = id_pharmacien
    self.prix_total = prix_total
    self.date_commande = date_commande
    self.id_client = id_client
    self.code = code
    self.ville = ville
    self.nom_pharmacie = nom_pharmacie
    self.ville = ville
    self.pay = pay
    self.numeros_pharmacie = numeros_pharmacie
    self.adresse = adresse
    self.pharmapicture = pharmapicture
    self.longitude = longitude
    self.latitude = latitude
        
    }
    
    class func generatedModelArray() -> [Commande]
    {
        var pharmarray = [Commande]()
        return pharmarray
    }

}
