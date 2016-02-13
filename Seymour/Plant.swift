//
//  Plant.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

let knownPlants : [String: Plant] = [
    "4045577F-F6A2-9954-3252-973EDB6EB7B0": Plant(name:"Audrey II", image: UIImage(named: "seymour"))
]

class Plant
{
    let name    : String
    let image   : UIImage?
    var peripheral  : CBPeripheral?
    
    init(name: String, image: UIImage? = nil) {
        self.name = name
        self.image = image
    }
    
}