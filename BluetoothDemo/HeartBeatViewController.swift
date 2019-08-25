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

enum HRStatus {
    case waitingToReceiveHR
    case startedReceivingHR
    case stoppedReceivingHR
}

class HeartBeatViewController: UIViewController {
    
    var sensorLocation: String?
    //private var lastHeartbeatTimeStamp: NSDate?
    //let stopBeatingFrequency = 3
    weak var delegate: HRBeatProtocol?
    //var timer = Timer()
    var status: HRStatus {
        didSet {
            switch status {
            case .waitingToReceiveHR:
                print("receiving data")
                setUIwaitingToReceiveHR()
            case .startedReceivingHR:
                print("receiving data with heartbeat")
                setUIstartedReceivingHR()
            case .stoppedReceivingHR:
                setUIStoppedRecevingHR()
                print("stopped")
                
            }
        }
    }
    
    @IBOutlet weak var heartbeat_imageView: UIImageView!
    @IBOutlet weak var sensorLocation_Label: UILabel!
    @IBOutlet weak var hr_Label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        status = .waitingToReceiveHR
        
        //lastHeartbeatTimeStamp = NSDate()
        
        sensorLocation_Label.text = sensorLocation
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedHeartBeat), name: .didReceiveHeartBeat, object: nil)
        
        //scheduledTimerWithInterval()
    }
    
    required init?(coder aDecoder: NSCoder) {
        status = .waitingToReceiveHR

        super.init(coder: aDecoder)
    }
    
//    private func scheduledTimerWithInterval() {
//        timer = Timer.scheduledTimer(withTimeInterval: Double(stopBeatingFrequency), repeats: true, block: { [weak self] (_) in
//            self?.checkHR()
//        })
//    }
    
//    private func checkHR() {
//        if let hr = lastHeartbeatTimeStamp {
//            if HRMonitorAssistant.shouldContinueMonitoring(heartRate: hr, frequency: stopBeatingFrequency) == false {
//                delegate?.didStopReceivingHeartbeat()
//
//                navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
    @objc private func receivedHeartBeat(_ notification: Notification) {
        
        if let hr = notification.userInfo?["data"] as? Int {
            //lastHeartbeatTimeStamp = NSDate()

            if hr == 0 {
                print("Heart rate is 0")
                if status == .startedReceivingHR {
                    status = .stoppedReceivingHR
                }
                return
            }
            print("Received HR: \(hr)")
            //print("lastHeartRateTimeStamp: \(lastHeartbeatTimeStamp)")
            status = .startedReceivingHR
            hr_Label.text = String(hr)
            
            if hr_Label.text!.isEmpty {

                heartbeat_imageView.isHidden = false

            } else {

                heartbeat_imageView.isHidden = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [weak self] in

                    self?.heartbeat_imageView.isHidden = false
                }
            }
        }
    }
    
    deinit {
        print("deinit called")
    }
}

//  ==============================================================================
//  Private Methods
//  ==============================================================================
extension HeartBeatViewController {
    private func setUIwaitingToReceiveHR() {
        heartbeat_imageView.image = UIImage(imageLiteralResourceName: "waiting_for_heartbeat")
    }
    
    private func setUIstartedReceivingHR() {
        heartbeat_imageView.image = UIImage(imageLiteralResourceName: "heartbeat")
    }
    
    private func setUIStoppedRecevingHR() {
        delegate?.didStopReceivingHeartbeat()
        navigationController?.popViewController(animated: true)
    }
}
