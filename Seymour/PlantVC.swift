//
//  PlantVC.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import UIKit
import CoreBluetooth

class PlantVC: UIViewController, CBPeripheralDelegate
{
    var plant   : Plant!
    var central : CBCentralManager!

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.layer.bounds.size.width / 2
        self.icon.layer.borderColor = UIColor.blackColor().CGColor
        self.icon.layer.borderWidth = 3
        
        self.plant.peripheral!.delegate = self
        self.central.connectPeripheral(plant.peripheral!, options: nil)

        self.title = plant.name
        self.icon.image = plant.image
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.central.connectPeripheral(plant.peripheral!, options: nil)
        self.message.text = "Espera un momento"
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.central.cancelPeripheralConnection(plant.peripheral!)
        super.viewWillDisappear(animated)
    }
    
    private func updateInfo(deviceData: String)
    {
        if let value = Int(deviceData) {
            
            print("Value: \(value)")
            if value < 400 {
                self.message.text = "Me ahogo!"
            } else if value < 600 {
                self.message.text = "Todo bien!"
            } else if value < 700 {
                self.message.text = "Tengo sed!"
            } else  {
                self.message.text = "Muero de sed!"
            }
            
        }
    }
    
    // MARK: CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
        if let characteristics = service.characteristics
        {
            for characteristic in characteristics {
                peripheral.readValueForCharacteristic(characteristic)
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        if let characteristicValue = characteristic.value
        {
            let datastring = NSString(data: characteristicValue, encoding: NSUTF8StringEncoding)
            if let datastring = datastring {
                self.updateInfo(datastring as String)
            }
        }
    }
}
