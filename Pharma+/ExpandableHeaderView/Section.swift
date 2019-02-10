//
//  Section.swift
//  Pharma+
//
//  Created by Thony on 12/18/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import Foundation

struct Section
{
    var titre: String!
    var paniername: [String]
    var expended: Bool!
    
    init(titre:String,paniername:[String],expended:Bool)
    {
   self.titre = titre
   self.paniername = paniername
   self.expended = expended
    }
}
