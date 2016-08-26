//
//  SucursalTableViewController.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 23/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import MapKit

class SucursalTableViewController: UITableViewController {
    
    var sucursales = [Sucursal]()
    var realm: Realm!
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        realm = try! Realm()
        // print("The real path is \(realm?.path)")
    }
    override func viewDidLoad() {
       // print("text!!!");
        
        super.viewDidLoad()
        
        loadSucursales()
        /*
        
        Alamofire.request(.GET, "http://localhost/pizzas/pizerias.php")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
 */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSucursales(){
        
        Alamofire.request(.GET, "http://localhost/pizzas/pizerias.php")
            
            .responseJSON { response in
                response.data
                // parser JSON
                
                let json = JSON(data: response.data!)
                
                for (_,subJson):(String, JSON) in json {
                    
                    //create meal object
                    let newSucursal = Sucursal( name: subJson["name"].string!,
                        photo: nil,
                        address: subJson["address"].string!,
                        latitud: (subJson["latitud"].string! as NSString).doubleValue,
                        longitud: (subJson["longitud"].string! as NSString).doubleValue
                    )
                    // load Image
                    Alamofire.request(.GET, subJson["photo"].string!)
                        .responseJSON { imgResponse in
                            let sucursalPhoto = UIImage(data: imgResponse.data!)
                            newSucursal?.photo = sucursalPhoto
                            //add to sucursales array
                            self.sucursales.append(newSucursal!)
                            
                            //reload table
                            self.tableView.reloadData()
                    }
                    
                    
                }
                
                
        }
        
        let listSucursales = realm?.objects(SucursalDB.self)
        for sucursaldb in listSucursales!{
            //print("The name is \(sucursaldb.name)!")
            
            // append to meals array
            
            let photo = UIImage(data: sucursaldb.photo!)
            sucursales.append(Sucursal(name: sucursaldb.name, photo: photo, address: sucursaldb.address, latitud: (sucursaldb.latitud as NSString).doubleValue, longitud: (sucursaldb.longitud as NSString).doubleValue)!)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sucursales.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SucursalTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SucursalTableViewCell
        let sucursal = sucursales[indexPath.row]
        
        cell.sucursalImageView.image = sucursal.photo
        cell.sucursalName.text = sucursal.name
        cell.sucursalAdrress.text = sucursal.address
        
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 105.0;//Choose your custom row height
    }

  
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            sucursales.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let sucursalDetailViewController = segue.destinationViewController as! SucursalViewController
            
            // Get the cell that generated this segue.
            if let selectedSucursalCell = sender as? SucursalTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSucursalCell)!
                let selectedSucursal = sucursales[indexPath.row]
                sucursalDetailViewController.sucursal = selectedSucursal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new sucursal.")
        }

        
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SucursalViewController, sucursal = sourceViewController.sucursal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing sucursal.
                sucursales[selectedIndexPath.row] = sucursal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: sucursales.count, inSection: 0)
                sucursales.append(sucursal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
   

}
