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
    return AppSettings.shared.isDarkMode ? UIColor(patternImage: UIImage(named: "pattern_dark")!) : UIColor(patternImage: UIImage(named: "pattern_light")!)
}
