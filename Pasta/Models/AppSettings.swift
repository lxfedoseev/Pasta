//
//  AppSettings.swift
//  Pasta
//
//  Created by Alex Fedoseev on 16.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation

public class AppSettings {
    
    // MARK: - Keys
    private struct Keys {
        static let isFirstTime = "isFirstTime"
        static let isTimerRunning = "isTimerRunning"
        static let remainedSeconds = "remainedSeconds"
        static let timeStamp = "timeStamp"
    }
    
    // MARK: - Static Properties
    public static let shared = AppSettings()
    
    // MARK: - Instance Properties
    private let userDefaults = UserDefaults.standard
    
    public var isFirstTime: Bool {
        
        get {
            return userDefaults.bool(forKey: Keys.isFirstTime)
        } set {
            userDefaults.set(newValue, forKey: Keys.isFirstTime)
        }
        
    }
    
    public var isTimerRunning: Bool {
        
        get {
            return userDefaults.bool(forKey: Keys.isTimerRunning)
        } set {
            userDefaults.set(newValue, forKey: Keys.isTimerRunning)
        }
        
    }
    
    public var remainedSeconds: TimeInterval {
        
        get {
            return userDefaults.double(forKey: Keys.remainedSeconds)
        } set {
            userDefaults.set(newValue, forKey: Keys.remainedSeconds)
        }
        
    }
    
    public var timeStamp: Date? {
        get {
            if let date = userDefaults.object(forKey: Keys.timeStamp) as? Date {
                return date
            } else {
                return nil
            }
        } set {
            userDefaults.set(newValue, forKey: Keys.timeStamp)
        }
        
    }
    
    // MARK: - Object Lifecycle
    private init() { }
    
}
