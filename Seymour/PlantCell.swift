//
//  PlantCell.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import UIKit

class PlantCell: UITableViewCell
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib()
    {
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.layer.bounds.size.width / 2
        self.icon.layer.borderColor = UIColor.blackColor().CGColor
        self.icon.layer.borderWidth = 2
    }
    
}