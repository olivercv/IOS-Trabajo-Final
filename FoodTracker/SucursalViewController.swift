//
//  SucursalViewController.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 23/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

class SucursalViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sucursalNameLabel: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var sucursalAddressText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var sucursalMap: MKMapView!
    
    
        
    var sucursal: Sucursal?
    var realm: Realm?
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //print("the real path is "+String(realm?.path))
        //print("The real path is \(realm?.path)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        if let sucursal = sucursal {
            navigationItem.title = sucursal.name
            nameTextField.text   = sucursal.name
            photoImageView.image = sucursal.photo
            sucursalAddressText.text = sucursal.address
        }
        
        checkValidSucursalName()
        
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -17.392618938056547, longitude: -66.15885986914213)
        
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        
        sucursalMap.setRegion(theRegion, animated: true)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SucursalViewController.action(_:)))
        longPress.minimumPressDuration = 1.0
        sucursalMap.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view.
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        print("action map new!!!")
        
        sucursalMap.removeAnnotations(sucursalMap.annotations)
        
        let touchPoint = gestureRecognizer.locationInView(self.sucursalMap)
        let newCoord:CLLocationCoordinate2D = sucursalMap.convertPoint(touchPoint, toCoordinateFromView: self.sucursalMap)
        
        let newAnotation = MKPointAnnotation()
        
        newAnotation.coordinate = newCoord
        newAnotation.title = nameTextField.text
        newAnotation.subtitle = ""
        sucursalMap.addAnnotation(newAnotation)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Init CoreLocation
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.sucursalMap.showsUserLocation = true
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
       // let myLocationPointRect = MKMapRectMake(currentLocation.latitude, currentLocation.longitude, 0, 0)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = currentLocation
        anotation.title = "The Location"
        anotation.subtitle = "This is the location !!!"
        
        sucursalMap.addAnnotation(anotation)
        //zoomRect = myLocationPointRect
        print("the current location is \(currentLocation.longitude) , \(currentLocation.longitude)")
        //self.locationManager.stopUpdatingLocation()
    }
    
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.enabled = false
    }
    
    func checkValidSucursalName() {
        // Disable the Save button if the text field is empty.
        //var text = nameTextField.text ?? ""
        //saveButton.enabled = !text.isEmpty
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let address = sucursalAddressText.text ?? ""
            let latitud = sucursalMap.annotations.first?.coordinate.latitude
            let longitud = sucursalMap.annotations.first?.coordinate.longitude
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            sucursal = Sucursal(name: name, photo: photo, address: address, latitud: latitud!, longitud: longitud!)
            let newSucursal = SucursalDB()
            newSucursal.name = (sucursal?.name)!
            newSucursal.photo = UIImagePNGRepresentation((sucursal?.photo)!)
            newSucursal.address = (sucursal?.address)!
            newSucursal.latitud = String(format: "%f", (sucursal?.latitud)!)
            newSucursal.longitud = String(format: "%f", (sucursal?.longitud)!)
            newSucursal.id =  NSUUID().UUIDString
            
            //Save new Meal
            
            try! self.realm?.write{
                self.realm?.add(newSucursal)
            }
        }
        
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    

}
