//
//  Pharmacy.swift
//  Pharma+
//
//  Created by Thony on 12/3/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit

class Pharmacymodel: NSObject
{
    var pharmacyid:Int = 0
    var pharmacienid:Int = 0
    var pharmacypic:String = ""
    var pharmacyname:String = ""
    var pharmacycity:String = ""
    var pharmacygarde:String = "0"
    var NumeroPharmacy:String = ""
    var phamacyAddress:String = ""
    var pharmacydescription:String = ""
    var pharmacycountry:String = ""
    var pharmacylongitude:Double = 0.0
    var pharmacylatitude:Double = 0.0
    
   
    init(pharmacyid:Int,pharmacienid:Int,pharmacypic:String, pharmacyname:String, pharmacycity:String, pharmacygarde:String,NumeroPharmacy:String,phamacyAddress:String,pharmacydescription:String,pharmacycountry:String,pharmacylongitude:Double,pharmacylatitude:Double)
    {
        self.pharmacyid = pharmacyid
        self.pharmacienid = pharmacienid
        self.pharmacypic = pharmacypic
        self.pharmacyname = pharmacyname
        self.pharmacycity = pharmacycity
        self.pharmacygarde = pharmacygarde
        self.NumeroPharmacy = NumeroPharmacy
        self.phamacyAddress = phamacyAddress
        self.pharmacydescription = pharmacydescription
        self.pharmacycountry = pharmacycountry
        self.pharmacylongitude = pharmacylongitude
        self.pharmacylatitude = pharmacylatitude
    }
  
    init(pharmacypic:String, pharmacyname:String, pharmacycity:String, pharmacygarde:String,NumeroPharmacy:String,phamacyAddress:String)
    {
        self.pharmacypic = pharmacypic
      self.pharmacyname = pharmacyname
        self.pharmacycity = pharmacycity
        self.pharmacygarde = pharmacygarde
        self.NumeroPharmacy = NumeroPharmacy
        self.phamacyAddress = phamacyAddress
    }
    
    class func generatedModelArray() -> [Pharmacymodel]
    {
  var pharmarray = [Pharmacymodel]()
        return pharmarray
    }
    
    
}
