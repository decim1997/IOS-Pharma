//
//  MedicamentObject.swift
//  Pharma+
//
//  Created by Thony on 12/3/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import Foundation
import CoreData


class MedicamentObject: NSObject
{
    var id_medicament:Int = -1
    var  nom_medicament:String = ""
    var image_medicament:String = ""
    var prix_medicament:Double = 0.0
    var quantite:Int = 0
    var ordonance_medicament:Int = 0
    var id_type:Int = 0
    var id_categorie:Int = 0
    var id_forme:Int = 0
    var id_pharmacie:Int = 0
    var nom_categ_med:String = ""
    var type_med:String = ""
    var desc_med:String = ""
    var forme_medicament:String = ""
    var nom_pharmacy:String = ""
    
    
    init(id_medicament:Int, nom_medicament:String, image_medicament:String, prix_medicament:Double, quantite:Int, ordonance_medicament:Int, id_type:Int, id_categorie:Int, id_forme:Int, nom_categ_med:String, type_med:String, desc_med:String, forme_medicament:String,id_pharmacie:Int,nom_pharmacy:String)
    {
        self.id_medicament = id_medicament
        self.nom_medicament = nom_medicament
        self.image_medicament = image_medicament
        self.prix_medicament = prix_medicament
        self.quantite = quantite
        self.ordonance_medicament = ordonance_medicament
        self.id_type = id_type
        self.id_categorie = id_categorie
        self.id_forme = id_forme
        self.nom_categ_med = nom_categ_med
        self.desc_med = desc_med
        self.forme_medicament = forme_medicament
        self.id_pharmacie = id_pharmacie
        self.nom_pharmacy = nom_pharmacy
    }
    
    
    
    init(id_medicament:Int, nom_medicament:String, image_medicament:String, prix_medicament:Double, quantite:Int, ordonance_medicament:Int, id_type:Int, id_categorie:Int, id_forme:Int, nom_categ_med:String, type_med:String, desc_med:String, forme_medicament:String,id_pharmacie:Int)
    {
        self.id_medicament = id_medicament
        self.nom_medicament = nom_medicament
        self.image_medicament = image_medicament
        self.prix_medicament = prix_medicament
        self.quantite = quantite
        self.ordonance_medicament = ordonance_medicament
        self.id_type = id_type
        self.id_categorie = id_categorie
        self.id_forme = id_forme
        self.nom_categ_med = nom_categ_med
        self.desc_med = desc_med
        self.forme_medicament = forme_medicament
        self.id_pharmacie = id_pharmacie
    }
    
    init(id_medicament:Int, nom_medicament:String, image_medicament:String, prix_medicament:Double, quantite:Int, ordonance_medicament:Int, id_type:Int, id_categorie:Int, id_forme:Int, nom_categ_med:String, type_med:String, desc_med:String, forme_medicament:String)
    {
    self.id_medicament = id_medicament
    self.nom_medicament = nom_medicament
    self.image_medicament = image_medicament
    self.prix_medicament = prix_medicament
    self.quantite = quantite
    self.ordonance_medicament = ordonance_medicament
    self.id_type = id_type
    self.id_categorie = id_categorie
    self.id_forme = id_forme
    self.nom_categ_med = nom_categ_med
    self.desc_med = desc_med
    self.forme_medicament = forme_medicament
    }
    
    
    
    class func generateMedicamentArray() -> [MedicamentObject]
    {
        var med = [MedicamentObject]()
        
        return med
    }
    
    
   
    
    
}
