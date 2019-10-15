//
//  JarNode.swift
//  PastaGame
//
//  Created by Alex Fedoseev on 01/10/2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import SpriteKit

class JarNode: SKSpriteNode, EventListenerNode {
    
    func didMoveToScene(){
        isUserInteractionEnabled = false
    }
    
}
