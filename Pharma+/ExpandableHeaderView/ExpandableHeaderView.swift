//
//  ExpandableHeaderView.swift
//  Pharma+
//
//  Created by Thony on 12/18/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate
{
    func toggleSection(header:ExpandableHeaderView,section:Int)
}
class ExpandableHeaderView: UITableViewHeaderFooterView
{
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectoraction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectoraction(gestureRecognizer:UITapGestureRecognizer)
    {
   let cell = gestureRecognizer.view as! ExpandableHeaderView
     delegate?.toggleSection(header: self, section: cell.section)
    }
    func customInit(title:String,section:Int,delegate:ExpandableHeaderViewDelegate)
    {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.darkGray
    }
}
