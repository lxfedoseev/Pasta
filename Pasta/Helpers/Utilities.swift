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
            
            button?.customView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

            UIView.animate(withDuration: 1.0,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 6.0,
                options: .allowUserInteraction,
                animations: {
                    button?.customView?.transform = .identity
                },
                completion: nil)
            
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

