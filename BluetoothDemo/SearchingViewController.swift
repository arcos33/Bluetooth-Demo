//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by user on 8/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreBluetooth

extension Notification.Name {
    static let didReceiveHeartBeat = Notification.Name("didReceiveHeartBeat")
    static let didReceiveBodyLocation = Notification.Name("didReceiveModelData")
}

enum SegueNames: String {
    case searchViewToMonitorFound = "SearchView->MonitorFound"
    case monitorFoundToHeartBeat = "monitorFound->HeartBeat"
}

class SearchingViewController: UIViewController {
    let heartRateServiceUUID = CBUUID(string: "180D")
    let measurementCharacteristicUUID = CBUUID(string: "2A37")
    let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
    
    var connectedPeripheral: CBPeripheral!
    var centralManager: CBCentralManager?
    var acceptableHRHasBeenReceived = false
    
    //  ==============================================================================
    //  Lifecycle
    //  ==============================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

//  ==============================================================================
//  CBCentralManagerDelegate Methods
//  ==============================================================================
extension SearchingViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("CoreBluetooth BLE state is unknown")
        case .resetting:
            print("CoreBluetooth BLE hardware is resetting")
        case .unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform")
        case .unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
        case .poweredOff:
            print("CoreBluetooth BLE hardware is powered off")
        case .poweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            scanForAvailableMonitors()
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("peripheral: \(peripheral)")
        guard let centralManager = centralManager else { return }
        connectedPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(connectedPeripheral)
        performSegue(withIdentifier: SegueNames.searchViewToMonitorFound.rawValue, sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.searchViewToMonitorFound.rawValue {
            if let connectionView = segue.destination as? ConnectionStatusViewController {
                connectionView.delegate = self
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        if service.uuid.uuidString == heartRateServiceUUID.uuidString {
            
            for characteristic in service.characteristics! {
                if characteristic.uuid.uuidString == measurementCharacteristicUUID.uuidString {
                    self.centralManager?.stopScan()
                    peripheral.setNotifyValue(true, for: characteristic)
                } else if characteristic.uuid.uuidString == bodySensorLocationCharacteristicCBUUID.uuidString {
                    peripheral.readValue(for: characteristic)
                    self.centralManager?.stopScan()
                }
            }
        } else {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        peripheral.delegate = self
        connectedPeripheral.discoverServices([heartRateServiceUUID])
    }
}

//  ==============================================================================
//  CBPeripheralDelegate Methods
//  ==============================================================================
extension SearchingViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if characteristic.uuid.uuidString == measurementCharacteristicUUID.uuidString {
            let hr = HRMonitorAssistant.heartRate(from: characteristic)
            // The sensor will give a 0 heart rate for around 10 seconds.
            print("HR: \(hr)")
            NotificationCenter.default.post(name: .didReceiveHeartBeat, object: nil, userInfo: ["data": hr])
        } else if characteristic.uuid.uuidString == bodySensorLocationCharacteristicCBUUID.uuidString {
            let bodyLoc = HRMonitorAssistant.bodyLocation(from: characteristic)
            NotificationCenter.default.post(name: .didReceiveBodyLocation, object: nil, userInfo: ["data": bodyLoc])
        }
    }
}

//  ==============================================================================
//  Private Methods
//  ==============================================================================
extension SearchingViewController {
    func scanForAvailableMonitors() {
        guard let centralManager = centralManager else { return }
        centralManager.scanForPeripherals(withServices: [heartRateServiceUUID])
    }
}

//  ==============================================================================
//  HRBeatDelegate Methods
//  ==============================================================================
extension SearchingViewController: HRBeatProtocol {
    func didStopReceivingHeartbeat() {
        centralManager?.cancelPeripheralConnection(connectedPeripheral)
        scanForAvailableMonitors()
    }
    
    
}


