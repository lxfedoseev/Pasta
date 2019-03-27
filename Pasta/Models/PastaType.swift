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
    let jarImage: String
    let aldenteCookTime: TimeInterval // in minutes
    let softCookTime: TimeInterval // in minutes
    
    init(name: String, jarImage: String, aldenteCookTime: TimeInterval = 0.0, softCookTime: TimeInterval = 0.0) {
        self.name = name
        self.jarImage = jarImage
        self.aldenteCookTime = aldenteCookTime * 60
        self.softCookTime = softCookTime * 60
    }
}
