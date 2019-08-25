//
//  HRMonitorAssistant.swift
//  BluetoothDemo
//
//  Created by user on 8/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreBluetooth

struct HRMonitorAssistant {
    static func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
            let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }
    
    static func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
    
    static func shouldContinueMonitoring(heartRate: NSDate, frequency: Int) -> Bool {
        let elapsed = NSDate().timeIntervalSince(heartRate as Date)
        let elapsedInt = Int(elapsed)
        if elapsedInt >= frequency {
            return false
        }
        else {
            return true
        }
    }
}
