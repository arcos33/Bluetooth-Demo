//
//  HeartBeatViewController.swift
//  BluetoothDemo
//
//  Created by user on 8/13/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

enum TextStatus: Int {
    case blank
    case textPresent
}

class HeartBeatViewController: UIViewController {
    
    var sensorLocation: String?
    var date = NSDate()
    private var lastHeartbeat: NSDate?
    let stopBeatingFrequency = 3
    var delegate: HRBeatProtocol?
    var timer = Timer()
    
    @IBOutlet weak var heartbeat_imageView: UIImageView!
    @IBOutlet weak var sensorLocation_Label: UILabel!
    @IBOutlet weak var hr_Label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lastHeartbeat = NSDate()
        
        sensorLocation_Label.text = sensorLocation
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedHeartBeat), name: .didReceiveHeartBeat, object: nil)
        
        scheduledTimerWithInterval()
    }
    
    private func scheduledTimerWithInterval() {
        timer = Timer.scheduledTimer(withTimeInterval: Double(stopBeatingFrequency), repeats: true, block: { (_) in
            self.checkHR()
        })
    }
    
    
    private func checkHR() {
        print("CheckHR called")
        if let hr = lastHeartbeat {
            let elapsedTime = NSDate().timeIntervalSince(hr as Date)
            print(elapsedTime.timeInSeconds)
            if HRMonitorAssistant.shouldContinueMonitoring(heartRate: hr, frequency: stopBeatingFrequency) == false {
                
                navigationController?.popViewController(animated: true)
                
                delegate?.didStopReceivingHeartbeat()
            }
        }
    }
    
    @objc private func receivedHeartBeat(_ notification: Notification) {
        if let hr = notification.userInfo?["data"] as? Int {
            
            lastHeartbeat = NSDate()
            
            hr_Label.text = String(hr)
            
            if hr_Label.text!.isEmpty {
                
                heartbeat_imageView.isHidden = false
                
            } else {
                
                heartbeat_imageView.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                    
                    self?.heartbeat_imageView.isHidden = false
                }
            }
        }
    }
}
