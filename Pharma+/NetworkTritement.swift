//
//  NetworkTritement.swift
//  Pharma+
//
//  Created by Thony on 12/3/18.
//  Copyright © 2018 Thony. All rights reserved.
//


import Foundation
import Alamofire
import AlamofireImage

class NetworkTraitement
{
    
    
    lazy var data:NSArray =
        {
            var networkdata:NSArray = []
            
            return networkdata
    }()
    
    lazy var MedArray:NSArray =
        {
       
            var medarray:NSArray = []
            
            return medarray
    }()
    
    lazy var userparams:Dictionary<String,Any> =
        {
            let userp:Dictionary<String,Any> = [:]
            return userp
    }()
    
    lazy var commandparams:Dictionary<String,Any> =
        {
            var cparams:Dictionary<String,Any> = [:]
            return cparams
    }()
    
    lazy var ligncommadparams:Dictionary<String,Any> =
        {
            var lcparams:Dictionary<String,Any> = [:]
            
            return lcparams
    }()
    
    func executeNetworkRequest(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
        Alamofire.request(url).validate().responseJSON
            {
                response in
                
                if let error = response.error
                {
                    completionHandler(nil,error)
                }
                else
                {
                    let data =  response.result.value as? NSArray
                    
                   // print(data)
                    completionHandler(data,nil)
                }
        }
    }
    
   func getAllMedicament(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
{
executeNetworkRequest(url: url, completionHandler: completionHandler)
}
    
func getPharmacyWithMedCheeking(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
{
    executeNetworkRequest(url: url, completionHandler: completionHandler)
}

    func getCommandeIdentifiant(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
        executeNetworkRequest(url: url, completionHandler: completionHandler)
    }
    
func seConnecter(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
{
    executeNetworkRequest(url: url, completionHandler: completionHandler)
}
    func getAllCommande(url: String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
        executeNetworkRequest(url: url, completionHandler: completionHandler)
    }
    
 
    func recordCommande(url:String, idpharmacie:Int, prixtotal:Double, datecommande:String, code:String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
     

        commandparams = [
            "idpharmacie": idpharmacie,
            "prixtotal": prixtotal,
            "datecommande": datecommande,
            "idclient": 1,
            "codecommande": code
            ]
        
        Alamofire.request(url, method:.post, parameters:commandparams,encoding: JSONEncoding.default).validate()
        .responseJSON
            {
                response in
                
                if let error = response.error
                {
                    completionHandler(nil,error)
                }
                else
                {
                    let data =  response.result.value as? NSArray
                    completionHandler(data,nil)
                }
        }
        
    }
    
    func recordLigneCommande(url:String, idcommande:Int, idmedicament:Int, prixunitaire:Double, quantite:Int, nommedicament:String,imagemedicament:String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
        let qte = Double(quantite)
        let prixtotalligne = prixunitaire * qte
        
        ligncommadparams =
            [
                "idcommande": idcommande,
                "idmedicament":idmedicament,
                "prixunitaire": prixunitaire,
                "quantite": quantite,
                "prixtotalligne": prixtotalligne,
                "nommedicament": nommedicament,
                "imagemedicament": imagemedicament
              ]
        Alamofire.request(url, method:.post, parameters:ligncommadparams,encoding: JSONEncoding.default).validate()
            .responseJSON
            {
                response in
                
                if let error = response.error
                {
                    completionHandler(nil,error)
                }
                else
                {
                    let data =  response.result.value as? NSArray
                    completionHandler(data,nil)
                }
        }
        
    }
    
    func goForLigneCommandRecord(url:String, idcommande:Int, idmedicament:Int, prixunitaire:Double, quantite:Int, nommedicament:String,imagemedicament:String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
    recordLigneCommande(url: url, idcommande: idcommande, idmedicament: idmedicament, prixunitaire: prixunitaire, quantite: quantite, nommedicament: nommedicament, imagemedicament: imagemedicament, completionHandler: completionHandler)
    }
    
    func goForRecordCommand(url:String, idpharmacie:Int, prixtotal:Double, datecommande:String, code:String,completionHandler: @escaping (NSArray?,Error?)->Void)
    {
        recordCommande(url: url, idpharmacie: idpharmacie, prixtotal: prixtotal, datecommande: datecommande, code: code, completionHandler: completionHandler)
    }
    
}
