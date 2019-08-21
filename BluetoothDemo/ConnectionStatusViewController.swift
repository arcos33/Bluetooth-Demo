//
//  ConnectedSuccessfullyViewController.swift
//  BluetoothDemo
//
//  Created by user on 8/13/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectionStatusViewController: UIViewController {
    var sensorLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotification), name: .didReceiveBodyLocation, object: nil)
    }
    
    @objc private func receivedNotification(_ notification: Notification) {
        if let sensorLoc = notification.userInfo?["data"] as? String {
            sensorLocation = sensorLoc
            performSegue(withIdentifier: SegueNames.monitorFoundToHeartBeat.rawValue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let heartbeatVC = segue.destination as? HeartBeatViewController {
            heartbeatVC.sensorLocation = sensorLocation
            heartbeatVC.delegate = self
        }
    }
}

extension ConnectionStatusViewController: HRBeatProtocol {
    func didStopReceivingHeartbeat() {
        self.navigationController?.popViewController(animated: true)
    }
}


