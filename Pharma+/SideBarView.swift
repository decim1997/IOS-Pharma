//
//  SideBarView.swift
//  Pharma+
//
//  Created by Thony on 11/14/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import Foundation
import UIKit


protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case editProfile
    case messages
    case contact
    case settings
    case history
    case help
    case signOut
    case none
    
    init(row: Int) {
        switch row {
        case 0: self = .editProfile
        case 1: self = .messages
        case 2: self = .contact
        case 3: self = .settings
        case 4: self = .history
        case 5: self = .help
        case 6: self = .signOut
        default: self = .none
        }
    }
}

class SideBarView: UIView, UITableViewDelegate,UITableViewDataSource
{
    var menuItemArray = [String]()
    weak var delegate: SidebarViewDelegate?
    
    let MenuTableView:UITableView =
    {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func setupViews() {
        self.addSubview(MenuTableView)
        MenuTableView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        MenuTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        MenuTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        MenuTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        self.clipsToBounds=true
        
        menuItemArray = ["Akhilendra Singh", "Messages", "Contact", "Settings", "History", "Help", "Sign Out"]
        
        setupViews()
        
        MenuTableView.delegate=self
        MenuTableView.dataSource=self
        MenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        MenuTableView.tableFooterView=UIView()
        MenuTableView.separatorStyle = .none
        MenuTableView.allowsSelection = true
        MenuTableView.bounces=false
        MenuTableView.showsVerticalScrollIndicator=false
        MenuTableView.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.backgroundColor=UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: 15, y: 10, width: 80, height: 80))
            cellImg.layer.cornerRadius = 40
            cellImg.layer.masksToBounds=true
            cellImg.contentMode = .scaleAspectFill
            cellImg.layer.masksToBounds=true
            cellImg.image=UIImage(named: "cat")
            cell.addSubview(cellImg)
            
            let cellLbl = UILabel(frame: CGRect(x: 110, y: cell.frame.height/2-15, width: 250, height: 30))
            cell.addSubview(cellLbl)
            cellLbl.text = menuItemArray[indexPath.row]
            cellLbl.font=UIFont.systemFont(ofSize: 17)
            cellLbl.textColor=UIColor.white
        } else {
            cell.textLabel?.text=menuItemArray[indexPath.row]
            cell.textLabel?.textColor=UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
    }
    
  
    
}
