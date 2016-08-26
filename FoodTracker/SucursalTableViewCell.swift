//
//  SucursalTableViewCell.swift
//  FoodTracker
//
//  Created by Oliver Ronald Camacho Velasco on 23/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class SucursalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sucursalImageView: UIImageView!
    
    @IBOutlet weak var sucursalName: UILabel!
    
    @IBOutlet weak var sucursalAdrress: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
