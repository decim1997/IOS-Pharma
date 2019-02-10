//
//  PersonneSession.swift
//  Pharma+
//
//  Created by Thony on 12/22/18.
//  Copyright © 2018 Thony. All rights reserved.
//


import UIKit
import Foundation
import CoreData

class PersonneSession
{
    var PersonneArray:[NSManagedObject] = []

    func CreateSession(id:Int, email:String, pseudo:String, password:String, photo:String, numeros:String, role:Int, activate:Int)
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = mydelegate.persistentContainer.viewContext

        let PersonneEntity = NSEntityDescription.entity(forEntityName: "Personne", in: managedContext)

        let fetcherequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Personne")
        
        fetcherequest.predicate = NSPredicate(format: "id == %id", id)
        
        do
        {
            let result = try managedContext.fetch(fetcherequest)
            
            if(result.count == 0)
            {
                let personne = NSManagedObject(entity: PersonneEntity!, insertInto: managedContext)
                
                personne.setValue(id, forKey: "id")
                personne.setValue(email, forKey: "email")
                personne.setValue(pseudo, forKey: "pseudo")
                personne.setValue(password, forKey: "password")
                personne.setValue(photo, forKey: "photo")
                personne.setValue(numeros, forKey: "numeros")
                personne.setValue(role, forKey: "role")
                personne.setValue(activate, forKey: "activate")
            }
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    
    func EmptyPersonneSession()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate
            else
        {
            return
        }
        
        let  managedContext = mydelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Personne")
        let deleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest)
        
        do
        {
            try  managedContext.execute(deleterequest)
        }
        catch let error as NSError
        {
            print(error)
        }
    }
    
    func getPersonneSession() -> [NSManagedObject]
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return self.PersonneArray
        }
        
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Personne")
        
        do
        {
            self.PersonneArray = try managedContext.fetch(fetchrequest)
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
        
        return self.PersonneArray
    }
    
}
