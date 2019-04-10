//
//  Utilities.swift
//  Pasta
//
//  Created by Alex Fedoseev on 19.03.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation
import UIKit

func backgroudColor() -> UIColor {
    return AppSettings.shared.isLightMode ? UIColor(patternImage: UIImage(named: "pattern_light")!) : UIColor(patternImage: UIImage(named: "pattern_dark")!)
}

func navigationBarColor() -> UIColor {
    return AppSettings.shared.isLightMode ? UIColor.myBlueColor : UIColor.myGrayColor
}

func configureRightNavButton(button: UIBarButtonItem?) {
    let settings = AppSettings.shared
    
    if let timeStamp = settings.timeStamp as Date? {
        let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
        if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
            button?.isEnabled = true
        }else{
            button?.isEnabled = false
        }
    }else{
        button?.isEnabled = false
    }
}

func isSegueValid(button: UIBarButtonItem?) -> Bool {
    let settings = AppSettings.shared
    
    if let timeStamp = settings.timeStamp as Date? {
        let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
        if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
            return true
        }
    }
    button?.isEnabled = false
    return false
}

func appDelegate () -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}
