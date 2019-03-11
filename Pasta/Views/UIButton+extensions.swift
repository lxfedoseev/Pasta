//
//  UIButton+extensions.swift
//  Pasta
//
//  Created by Alex Fedoseev on 11.03.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
            isUserInteractionEnabled = isEnabled
        }
    }
    
}
