//
//  MealDB.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 20/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import RealmSwift

class MealDB: Object {
    dynamic var id=""
    dynamic var name=""
    dynamic var photo:NSData? = nil
    dynamic var rating = 0
    
    override static func primaryKey() ->String?{
        return "id"
        
    }
}