//
//  ViewController.swift
//  P_Model_Stopwatch1209
//
//  Created by leslie on 12/9/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    
    var timerIsOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var startTime: Date {
        get {
            if let time = UserDefaults.standard.object(forKey: #function) as? Date {return time}
            return Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var totalTime: Double {
        get {
            return UserDefaults.standard.double(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    @IBOutlet weak var timerDisLbl: UILabel!
    // Property Observer
    @IBOutlet weak var timerIsOnLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    
    // Notification
    let TIMER_IS_ON_UPDATED = Notification.Name("timerIsOnUpdated")
    let START_TIME_UPDATED = Notification.Name("startTimeUpdated")
    let TOTAL_TIME_UPDATED = Notification.Name("totalTimeUpdated")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreTimerStatus()
        
        timerIsOnLbl.text = "timerIsOn: \(timerIsOn)"
        startTimeLbl.text = "startTime: \(startTime)"
        totalTimeLbl.text = "totalTime: \(totalTime)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerIsOn), name: TIMER_IS_ON_UPDATED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStartTime), name: START_TIME_UPDATED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalTime), name: TOTAL_TIME_UPDATED, object: nil)
    }
    
    @objc func updateTimerIsOn() {
        timerIsOnLbl.text = "timerIsOn: \(timerIsOn)"
    }
    
    @objc func updateStartTime() {
        startTimeLbl.text = "startTime: \(startTime)"
    }
    
    @objc func updateTotalTime() {
        totalTimeLbl.text = "totalTime: \(totalTime)"
    }
    
    func restoreTimerStatus() {
        if timerIsOn {
            timerIsOn = true
            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tickTock), userInfo: nil, repeats: true)
        } else {
            timerIsOn = false
            
            let displayTime = totalTime
            convertTimeInterval(interval: displayTime)
        }
    }
    
    @objc func tickTock() {
        let displayTime = Date().timeIntervalSince(startTime) + totalTime
        convertTimeInterval(interval: displayTime)
    }
    
    func toStart() {
        if !timerIsOn {
            timerIsOn = true
            
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tickTock), userInfo: nil, repeats: true)
            
            NotificationCenter.default.post(name: TIMER_IS_ON_UPDATED, object: nil)
            NotificationCenter.default.post(name: START_TIME_UPDATED, object: nil)
        } else {
            
        }
    }
    
    func toResume() {
        toStart()
    }
    
    func toPause() {
        if timerIsOn {
            timerIsOn = false
            
            timer.invalidate()
            totalTime += Date().timeIntervalSince(startTime)
            
            NotificationCenter.default.post(name: TIMER_IS_ON_UPDATED, object: nil)
            NotificationCenter.default.post(name: TOTAL_TIME_UPDATED, object: nil)
        }
    }
    
    func toStop() {
        if timerIsOn {
            timerIsOn = false
            
            timer.invalidate()
            totalTime = 0
            
            NotificationCenter.default.post(name: TIMER_IS_ON_UPDATED, object: nil)
            NotificationCenter.default.post(name: TOTAL_TIME_UPDATED, object: nil)
        } else {
            
        }
    }
    
    func toReset() {
        timerIsOn = false
        
        timer.invalidate()
        totalTime = 0
        let displayTime = totalTime
        convertTimeInterval(interval: displayTime)
        
        NotificationCenter.default.post(name: TIMER_IS_ON_UPDATED, object: nil)
        NotificationCenter.default.post(name: TOTAL_TIME_UPDATED, object: nil)
    }
    
    func convertTimeInterval(interval: TimeInterval) {
        let absInterval = abs(Int(interval))
        
        let msec = interval.truncatingRemainder(dividingBy: 1) * 100
        let secs = absInterval % 60
        let mins = (absInterval / 60) % 6
        let hrs = (absInterval / 3600)
        
        if hrs == 0 {
            timerDisLbl.text = String(format: "%.2d", mins) + ":" + String(format: "%.2d", secs) + "." + String(format: "%.2d", Int(msec))
        } else {
            timerDisLbl.text = String(hrs) + ":" + String(format: "%.2d", mins) + ":" + String(format: "%.2d", secs) + "." + String(format: "%.2d", Int(msec))
        }
        
        timerDisLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .regular)
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        toStart()
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        toPause()
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        toStop()
    }
    
    @IBAction func resumeBtnPressed(_ sender: Any) {
        toResume()
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        toReset()
    }
    @IBAction func logBtnPressed(_ sender: Any) {
        
    }
    
}

