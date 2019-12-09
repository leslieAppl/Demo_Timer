//
//  TimerModel.swift
//  P_Model_Stopwatch1209
//
//  Created by leslie on 12/9/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import Foundation

class TimerModel {
    
    static let instance = TimerModel( )
    
    var timer = Timer()
    
    var stopWatchIsOn: Bool {
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
}
