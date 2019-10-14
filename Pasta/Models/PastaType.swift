//
//  PastaType.swift
//  Pasta
//
//  Created by Alex Fedoseev on 06.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation

enum PastaKeys: String {
    case name = "Name"
    case image = "Image"
    case alDenteTime = "AlDenteTime"
    case softTime = "SoftTime"
    case onePasta = "OnePasta"
}

class PastaType: NSObject, NSCoding {

    let name: String
    let jarImage: String
    let aldenteCookTime: TimeInterval // in minutes
    let softCookTime: TimeInterval // in minutes
    let onePasta: String
    
    init(name: String, jarImage: String, onePasta: String, aldenteCookTime: TimeInterval = 0.0, softCookTime: TimeInterval = 0.0) {
        self.name = name
        self.jarImage = jarImage
        self.aldenteCookTime = aldenteCookTime * 60
        self.softCookTime = softCookTime * 60
        self.onePasta = onePasta
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PastaKeys.name.rawValue)
        aCoder.encode(jarImage, forKey: PastaKeys.image.rawValue)
        aCoder.encode(aldenteCookTime, forKey: PastaKeys.alDenteTime.rawValue)
        aCoder.encode(softCookTime, forKey: PastaKeys.softTime.rawValue)
        aCoder.encode(onePasta, forKey: PastaKeys.onePasta.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PastaKeys.name.rawValue) as! String
        let jarImage = aDecoder.decodeObject(forKey: PastaKeys.image.rawValue) as! String
        let alDente = aDecoder.decodeDouble(forKey: PastaKeys.alDenteTime.rawValue)
        let soft = aDecoder.decodeDouble(forKey: PastaKeys.softTime.rawValue)
        let onePasta = aDecoder.decodeObject(forKey: PastaKeys.onePasta.rawValue) as! String
        
        self.init(name: name, jarImage: jarImage, onePasta: onePasta, aldenteCookTime: alDente/60, softCookTime: soft/60)
    }
}
