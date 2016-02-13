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
    
//    private func writeValue(device: CBPeripheral, value: String)
//    {
//        if let data = (value as NSString).dataUsingEncoding(NSUTF8StringEncoding),
//            let peripheralDevice = peripheralDevice,
//            let deviceCharacteristics = deviceCharacteristics
//        {
//            peripheralDevice.writeValue(data,
//                forCharacteristic: deviceCharacteristics,
//                type: CBCharacteristicWriteType.WithoutResponse
//                )
//        }
//    }
    
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
        print("Found \(peripheral.name)")
        if let name = peripheral.name where name == "HMSensor" {
            print("Found HMSensor! \(peripheral) \nRSSI: \(RSSI)");
            if let plant = knownPlants[peripheral.identifier.UUIDString] {
                plant.device = peripheral
                self._plants.append(plant)
                delegate?.didFindPlant(plant)
            } else {
                print("I don't know this plant")
            }
        }
    }
    
    // MARK: CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let characteristicValue = characteristic.value {
            let datastring = NSString(data: characteristicValue, encoding: NSUTF8StringEncoding)
            if let datastring = datastring{
                print(datastring)
            }
        }
    }
    
}