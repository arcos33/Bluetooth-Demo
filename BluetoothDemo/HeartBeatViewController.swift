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
    weak var delegate: HRBeatProtocol?
    var status: HRStatus {
        didSet {
            switch status {
            case .waitingToReceiveHR:
                print("receiving data without heart rate")
                setUIwaitingToReceiveHR()
            case .startedReceivingHR:
                print("receiving data with heart rate")
                setUIstartedReceivingHR()
            case .stoppedReceivingHR:
                setUIStoppedRecevingHR()
                print("stopped receiving heart rate")
            }
        }
    }
    
    @IBOutlet weak var heartbeat_imageView: UIImageView!
    @IBOutlet weak var sensorLocation_Label: UILabel!
    @IBOutlet weak var hr_Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status = .waitingToReceiveHR
        sensorLocation_Label.text = sensorLocation
        NotificationCenter.default.addObserver(self, selector: #selector(receivedHeartBeat), name: .didReceiveHeartBeat, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        status = .waitingToReceiveHR
        super.init(coder: aDecoder)
    }
    
    @objc private func receivedHeartBeat(_ notification: Notification) {
        if let hr = notification.userInfo?["data"] as? Int {
            if hr == 0 {
                print("Heart rate is 0")
                    status = .stoppedReceivingHR
            }
            print("Received HR: \(hr)")
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
        navigationController?.popViewController(animated: true)

        delegate?.didStopReceivingHeartbeat()
    }
}
