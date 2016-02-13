//
//  PlantsVC.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import UIKit

class PlantsVC: UITableViewController, SeymourDelegate {
    
    let seymour = Seymour()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        seymour.delegate = self
        seymour.start()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toPlant"
        {
            if let vc = segue.destinationViewController as? PlantVC,
                let indexPath = self.tableView.indexPathForSelectedRow
            {
                    let plant = self.seymour.plants[indexPath.row]
                    vc.plant = plant
            }
        }
    }
    
    // UITableViewDatasource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PlantCell!
        let plant = seymour.plants[indexPath.row]
        cell.name.text = plant.name
        cell.icon.image = plant.image
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return seymour.plants.count
    }
    
    // SeymourDelegate
    
    func didFindPlant(plant: Plant) {
        self.tableView.reloadData()
    }
    
}

