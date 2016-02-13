//
//  PlantsVC.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import UIKit
import CoreBluetooth

class PlantsVC: UITableViewController, CBCentralManagerDelegate {
    
    private var central : CBCentralManager!
    private var plants  = [Plant]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        central = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toPlant"
        {
            if let vc = segue.destinationViewController as? PlantVC,
                let indexPath = self.tableView.indexPathForSelectedRow
            {
                vc.central = self.central
                vc.plant = self.plants[indexPath.row]
            }
        }
    }
    
    // UITableViewDatasource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PlantCell!
        let plant = self.plants[indexPath.row]
        cell.name.text = plant.name
        cell.icon.image = plant.image
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.plants.count
    }
    
    // MARK: CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        if central.state == CBCentralManagerState.PoweredOn
        {
            print("Bluetooth ON")
            central.scanForPeripheralsWithServices(nil, options: nil)
        }
        else {
            print("Bluetooth switched off or not initialized")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral
        peripheral: CBPeripheral,
        advertisementData: [String : AnyObject],
        RSSI: NSNumber)
    {
        if let name = peripheral.name where name == "HMSensor" {
            if let plant = knownPlants[peripheral.identifier.UUIDString]
            {
                let index = self.plants.indexOf({ (plant) -> Bool in
                    return plant === plant
                })
                
                if index == nil {
                    plant.peripheral = peripheral
                    self.plants.append(plant)
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func centralManager(central: CBCentralManager,
        didConnectPeripheral peripheral: CBPeripheral)
    {
        peripheral.discoverServices(nil)
    }
    
}

