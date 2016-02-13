//
//  Seymour.swift
//  Seymour
//
//  Created by Leandro Tami on 2/13/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SeymourDelegate {
    func didFindPlant(plant: Plant);
}

class Seymour : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
{    
    var delegate        : SeymourDelegate?
    var plants          : [Plant] {
        return _plants
    }
    
    
    private var central : CBCentralManager!
    private var _plants  = [Plant]()
    
    func start()
    {
        central = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    private func writeValue(device: CBPeripheral, value: String)
    {
//        if let data = (value as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        {
//            
//            device.writeValue(data,
//                forCharacteristic: deviceCharacteristics,
//                type: CBCharacteristicWriteType.WithoutResponse
//                )
//        }
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
                let index = self._plants.indexOf({ (plant) -> Bool in
                    return plant === plant
                })
                
                if index == nil {
                    plant.device = peripheral
                    self._plants.append(plant)
                    delegate?.didFindPlant(plant)
                    
                    print("Connecting to \(peripheral)")
                    self.central.connectPeripheral(peripheral, options: nil)
                }
                
            }
        }
    }

    func centralManager(central: CBCentralManager,
        didConnectPeripheral peripheral: CBPeripheral)
    {
        peripheral.delegate = self
        print("Discovering services of \(peripheral)")
        peripheral.discoverServices(nil)
    }
    
    // MARK: CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        if let services = peripheral.services {
            for service in services {
                print("Discovering characteristics of \(peripheral)")
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
        print("Discovered characteristics \(service.characteristics)")
        if let characteristics = service.characteristics
        {
            for characteristic in characteristics {
                peripheral.readValueForCharacteristic(characteristic)
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let characteristicValue = characteristic.value {
            let datastring = NSString(data: characteristicValue, encoding: NSUTF8StringEncoding)
            if let datastring = datastring{
                print(datastring)
            }
        }
    }

}