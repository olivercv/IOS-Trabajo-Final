//
//  SucursalDB.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 23/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import RealmSwift

class SucursalDB: Object {
    dynamic var id=""
    dynamic var name=""
    dynamic var photo:NSData? = nil
    dynamic var address = ""
    dynamic var latitud = ""
    dynamic var longitud = ""
    
    override static func primaryKey() ->String?{
        return "id"
        
    }
}
