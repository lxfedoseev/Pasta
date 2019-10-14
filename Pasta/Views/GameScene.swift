//
//  GameScene.swift
//  Pasta
//
//  Created by Alex Fedoseev on 14.10.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AVFoundation


class GameScene: SKScene {
    
    static var parentVC: UIViewController? = nil
    
    enum LocalStrings {
        static let jarString = "jar"
        static let pastaString = "pasta"
        static let labelString = "label"
        static let closeString = "close"
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
    }
    
    class func level() -> GameScene?{
        let scene = GameScene(fileNamed:"GameScene")!
        scene.scaleMode = .aspectFill
        
        
        return scene
    }
    
    func win(){
        print("win")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == LocalStrings.closeString {
                GameScene.parentVC?.dismiss(animated: true, completion: nil)
            }else if name == LocalStrings.jarString{
                win()
            }
        }
    }
}
