//
//  TimeInterval+CommonUnits.swift
//  BluetoothDemo
//
//  Created by user on 8/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension TimeInterval {
    var timeInSeconds: Int {
        return Int(self)
    }
    
    var timeInMinutes: Int {
        return Int(self) / 60
    }
}
