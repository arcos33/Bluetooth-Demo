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
    weak var delegate: HRBeatProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotification), name: .didReceiveHeartBeat, object: nil)
    }
    
    @objc private func receivedNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            if let hr = notification.userInfo?["data"] as? Int {
                if hr > 0 {
                    let topVC = self?.navigationController?.topViewController
                    if ((topVC?.isKind(of: ConnectionStatusViewController.self))!) {
                        self?.performSegue(withIdentifier: SegueNames.monitorFoundToHeartBeat.rawValue, sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let heartbeatVC = segue.destination as? HeartBeatViewController {
            heartbeatVC.sensorLocation = sensorLocation
            heartbeatVC.delegate = self
        }
    }
}

//  ==============================================================================
//  HeartBeat Delegate
//  ==============================================================================
extension ConnectionStatusViewController: HRBeatProtocol {
    func didStopReceivingHeartbeat() {
        delegate?.didStopReceivingHeartbeat()
        self.navigationController?.popViewController(animated: true)
    }
}


