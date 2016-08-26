//
//  MapViewController.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 19/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import RealmSwift


class MapViewController: UIViewController, MKMapViewDelegate {
    
   
    
    @IBOutlet weak var mapView: MKMapView!
    var sucursales = [Sucursal]()
    
    var realm: Realm!
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        realm = try! Realm()
        // print("The real path is \(realm?.path)")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -17.392618938056547, longitude: -66.15885986914213)
        
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        
        mapView.setRegion(theRegion, animated: true)
        
        loadSucursales()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadSucursales(){
        
        Alamofire.request(.GET, "http://localhost/pizzas/pizerias.php")
            
            .responseJSON { response in
                response.data
                // parser JSON
                
                let json = JSON(data: response.data!)
                
                for (_,subJson):(String, JSON) in json {
                    
                
                    
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (subJson["latitud"].string! as NSString).doubleValue, longitude: (subJson["longitud"].string! as NSString).doubleValue)
                    
                    let anotation = MKPointAnnotation()
                    anotation.coordinate = location
                    anotation.title = subJson["name"].string!
                    anotation.subtitle = subJson["address"].string!
                    self.mapView.addAnnotation(anotation)
                    
                    
                  
                    
                }
                
                
        }
        
        
        let listSucursales = realm?.objects(SucursalDB.self)
        for sucursaldb in listSucursales!{
            //print("The name is \(sucursaldb.name)!")
            
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (sucursaldb.latitud as NSString).doubleValue, longitude: (sucursaldb.longitud as NSString).doubleValue)
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = location
            anotation.title = sucursaldb.name
            anotation.subtitle = sucursaldb.address
            self.mapView.addAnnotation(anotation)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let newAnotation = MKPointAnnotation()
        
        newAnotation.coordinate = newCoord
        newAnotation.title = "New Location"
        newAnotation.subtitle = "New Subtitle"
        mapView.addAnnotation(newAnotation)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    
}
