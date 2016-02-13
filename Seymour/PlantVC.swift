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
    var plant            : Plant!
    var central          : CBCentralManager!

    private let maxValue : Double = 1000
    private let minValue : Double = 200
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var radialProgressView: LvRadialProgressView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.layer.bounds.size.width / 2
        
        self.plant.peripheral!.delegate = self
        self.central.connectPeripheral(plant.peripheral!, options: nil)

        self.title = plant.name
        self.icon.image = plant.image
        
        radialProgressView.maxValue = self.maxValue
        radialProgressView.minValue = self.minValue
        radialProgressView.lineWidth = 8
        radialProgressView.progressValue = radialProgressView.minValue
        radialProgressView.traceColor = UIColor(white: 0.8, alpha: 1)
        radialProgressView.lineColor = UIColor.redColor()
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
            radialProgressView.progressValue = Double(value)
            
            radialProgressView.lineColor = UIColor(
                red: CGFloat(value) / CGFloat(maxValue) ,
                green: 1 - CGFloat(value) / CGFloat(maxValue),
                blue: 0,
                alpha: 1
            )
            
            if value < 400 {
                self.message.text = "¡Me ahogo!"
            } else if value < 600 {
                self.message.text = "¡Todo bien!"
            } else if value < 700 {
                self.message.text = "¡Tengo sed!"
            } else if value < 950 {
                self.message.text = "¡Tengo bastante sed!"
            } else  {
                self.message.text = "¡Muero de sed!"
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
