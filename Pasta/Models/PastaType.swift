//
//  PastaType.swift
//  Pasta
//
//  Created by Alex Fedoseev on 06.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation


class PastaType {
    
    let name: String
    let aldenteCookTime: TimeInterval
    let softCookTime: TimeInterval
    
    init(name: String, aldenteCookTime: TimeInterval = 0.0, softCookTime: TimeInterval = 0.0) {
        self.name = name
        self.aldenteCookTime = aldenteCookTime
        self.softCookTime = softCookTime
    }
}
