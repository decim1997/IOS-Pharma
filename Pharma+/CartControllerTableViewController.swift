//
//  CartControllerTableViewController.swift
//  Pharma+
//
//  Created by Thony on 12/17/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import CoreData


struct CartCellData
{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class CartControllerTableViewController:UITableViewController
{

    var tableViewData = [CartCellData]()
    
    @IBOutlet var cartTableView: UITableView!
    lazy var CartData:[NSDictionary] =
        {
            var datacart:NSDictionary = [:]
            
            return [datacart]
    }()
    
    lazy var groupCartData = Dictionary<Int,[NSDictionary]>()
    var panierArray:[NSManagedObject] = []
    
    
    func fetchCartData()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        let managedContext = mydelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSDictionary>(entityName: "Panier")
        fetchrequest.propertiesToFetch = ["id_pharmacie","id_produit","image_produit","nom_produit","prix_produit","quantite_produit","nom_pharmacie"]
      //  fetchrequest.propertiesToFetch = ["id_pharmacie"]
        fetchrequest.propertiesToGroupBy = ["id_pharmacie","id_produit","image_produit","nom_produit","prix_produit","quantite_produit","nom_pharmacie"]
        fetchrequest.resultType = .dictionaryResultType
        do
         {
           CartData = try managedContext.fetch(fetchrequest)
           groupCartData = Dictionary(grouping: CartData) { (element) -> Int  in
                element.value(forKey: "id_pharmacie") as! Int
            }
            
            for (key,value) in groupCartData
            {
                
                guard let stock = groupCartData[key]?[0] else{return}
                guard var pharmaname = stock["nom_pharmacie"] as? String else{return}
                
                tableViewData.append(CartCellData(opened: false, title:pharmaname, sectionData: ["Go To Cart"]))
                tableView.reloadData()
               // print("tentative")
                //print("tailledate\(tableViewData.count)")
                //print("contenu\(tableViewData)")
                /*print("key\(key)")
                print("\(groupCartData[key])")*/
            }
          //  let keys = groupCartData.keys
           
              // print("dataconent\(keys)")
            //print("coent\(groupCartData[1]?.count)")
         }
         catch let error as NSError
         {
         print("Error: \(error.userInfo)")
         }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCartData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableViewData[section].opened == true)
        {
            return tableViewData[section].sectionData.count + 1
            
            print("OKCOOOMKM")
        }
        else
        {
            print("When1")
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  dataIndex = indexPath.row - 1
        if(indexPath.row == 0)
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") else{return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            print("indexiszero")
            return cell
        }
        else
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") else{return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            print("indexisother")
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            if(tableViewData[indexPath.section].opened == true)
            {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                
                print("open")
            }
            else
            {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                print("close")
            }
            
        }
        else
        {
            print("othercase")
            print("indexpath:\(indexPath.row)")
            performSegue(withIdentifier: "GoToCart", sender: indexPath)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let index = sender as! IndexPath
        print("sectionis\(index.section)")
        print("ouridexis:\(index.row)")
    let destination = segue.destination as? PanierViewController
       destination?.pharmaname = tableViewData[index.section].title
    }
    
    
    
    
}




