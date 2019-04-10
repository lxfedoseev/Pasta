//
//  UIDevice+Extensions.swift
//  Pasta
//
//  Created by Alex Fedoseev on 25.03.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        var bottom : CGFloat = 0.0
        if #available(iOS 11.0, tvOS 11.0, *) {
            bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return bottom > 0
    }
}
