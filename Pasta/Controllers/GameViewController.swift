//
//  GameViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 14.10.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return [.portrait, .portraitUpsideDown]
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTheGame()
    }

    fileprivate func runTheGame() {
        if let scene = GameScene.level() {
            
            GameScene.parentVC = self
            
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
            
        }
    }
    
}

