//
//  PlantVC.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import UIKit

class PlantVC: UIViewController
{
    var plant: Plant!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.layer.bounds.size.width / 2
        self.icon.layer.borderColor = UIColor.blackColor().CGColor
        self.icon.layer.borderWidth = 3
        
        self.title = plant.name
        self.icon.image = plant.image
        
        self.message.text = "Tengo sed!"
    }
    
}
