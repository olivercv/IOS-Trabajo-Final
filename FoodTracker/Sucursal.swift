//
//  Sucursal.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 23/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import MapKit


class Sucursal{

    var name:String
    var photo:UIImage?
    var address:String
    var latitud: CLLocationDegrees
    var longitud: CLLocationDegrees
    
    init?(name:String, photo:UIImage?, address:String, latitud:CLLocationDegrees, longitud:CLLocationDegrees){
    
        self.name = name
        self.photo = photo
        self.address = address
        self.latitud = latitud
        self.longitud = longitud
        
        if name.isEmpty || address.isEmpty {
            
            return nil
        }
    }
    


}
