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

protocol EventListenerNode {
    func didMoveToScene()
}

class GameScene: SKScene {
    
    var jars: [PastaType]!
    var theWinner = 0
    let jarNumber = 4
    var likes = 0
    var dislikes = 0
    static var parentVC: UIViewController? = nil
    var pastaNode: SKSpriteNode!
    var labels:[SKLabelNode]!
    var likeLabel: SKLabelNode!
    var dislikeLabel: SKLabelNode!
    
    enum LocalStrings {
        static let jarString = "jar"
        static let pastaString = "pasta"
        static let labelString = "label"
        static let closeString = "close"
        static let likeString = "like"
        static let dislikeString = "dislike"
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scene?.isUserInteractionEnabled = true
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if node.isPaused {node.isPaused = false}
            
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        for i in 0...jarNumber-1{
            let jarNode = childNode(withName: LocalStrings.jarString+"\(i)") as! JarNode
            let jarLabel = jarNode.childNode(withName: LocalStrings.labelString+"\(i)") as! SKLabelNode
            jarLabel.text = jars[i].name
            jarLabel.alpha = 0.0
            jarLabel.run(SKAction.fadeIn(withDuration: 0.5))
            
            // adapt for phones with notches
            if UIDevice.current.hasNotch &&  UIDevice.current.userInterfaceIdiom == .phone {
                if i == 0 || i == 1{
                    jarNode.position.x -= 80
                }else if i == 2 || i == 3 {
                    jarNode.position.x += 80
                }
            }
        }
        
        pastaNode = (childNode(withName: LocalStrings.pastaString) as! SKSpriteNode)
        let newImage = SKTexture(imageNamed: jars[theWinner].onePasta)
        pastaNode.texture = newImage
        pastaNode.size = newImage.size()
        pastaNode.setScale(0.1)
        let scaleBig = SKAction.scale(to: 2.0, duration: 0.25)
        let scaleNormal = SKAction.scale(to: 1.0, duration: 0.25)
        let scale = SKAction.sequence([scaleBig, scaleNormal])
        let rotate = SKAction.rotate(byAngle: π*2, duration: 0.5)
        pastaNode.run(SKAction.group([scale, rotate]))
        
        let counter = SKAction.rotate(byAngle: π/8, duration: 0.1)
        let wise = SKAction.rotate(byAngle: -π/8, duration: 0.1)
        let wait = SKAction.wait(forDuration: 3.0)
        let wigle = SKAction.sequence([counter, counter.reversed(), wise, wise.reversed(), wait])
        pastaNode.run(SKAction.afterDelay(1.0, performAction: SKAction.repeatForever(wigle)))

        
        let closeNode = childNode(withName: LocalStrings.closeString) as! SKSpriteNode
        
        var deviceWidth: CGFloat = 0.0
        var deviceHeight: CGFloat = 0.0
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height{
            deviceWidth = UIScreen.main.bounds.width
            deviceHeight = UIScreen.main.bounds.height
        }else {
            deviceWidth = UIScreen.main.bounds.height
            deviceHeight = UIScreen.main.bounds.width
        }
        let maxAspectRatio: CGFloat = deviceWidth / deviceHeight
        closeNode.position = CGPoint(x: size.height*maxAspectRatio/2-100, y: size.height/2-130)
        
        likeLabel = (childNode(withName: LocalStrings.likeString) as! SKLabelNode)
        dislikeLabel = (childNode(withName: LocalStrings.dislikeString) as! SKLabelNode)
        likeLabel.text = "👍 \(likes)"
        dislikeLabel.text = "👎 \(dislikes)"
        likeLabel.position = CGPoint(x: -(size.height*maxAspectRatio/2-100), y: size.height/2-130)
        dislikeLabel.position = CGPoint(x: -(size.height*maxAspectRatio/2-100), y: size.height/2-200)
    }
    
    class func level(likes: Int, dislikes: Int) -> GameScene?{
        let scene = GameScene(fileNamed:"GameScene")!
        scene.scaleMode = .aspectFill
        
        scene.jars = generateRandomArray(from: pastas, count: scene.jarNumber)
        scene.likes = likes
        scene.dislikes = dislikes
        
        scene.theWinner = Int.random(in: 0...scene.jars!.count-1)
        
        return scene
        
    }
    
    func generateJarDict(number: Int) -> [String:String] {
        var myDict = [String:String]()
        for i in 0...number-1{
            myDict[LocalStrings.labelString+"\(i)"] = LocalStrings.jarString+"\(i)"
        }
        return myDict
    }

    func newGame() {
        view!.presentScene(GameScene.level(likes: likes, dislikes: dislikes))
    }
    
    func win(name: String){

        scene?.isUserInteractionEnabled = false
        
        let possibleName = getJarName(name: name)
        guard let jarName = possibleName else {
            return
        }
        
        likes+=1
        likeLabel.text = "👍 \(likes)"
        
        pastaNode.removeAllActions()
        let jarNode = childNode(withName: jarName) as! SKSpriteNode
        let movePasta = SKAction.move(to: jarNode.position, duration: 0.5)
        let scalePasta = SKAction.scale(to: 0.5, duration: 0.5)
        let rotatePasta = SKAction.rotate(byAngle: π*2, duration: 0.5)
        pastaNode.run(SKAction.group([movePasta, scalePasta, rotatePasta]))
        SKTAudio.sharedInstance().playSoundEffect("win.wav")
        
        run(SKAction.afterDelay(0.6, runBlock: newGame))
    }
    
    func lose(name: String) {
        
        let possibleName = getJarName(name: name)
        guard let jarName = possibleName else {
            return
        }
        
        dislikes+=1
        dislikeLabel.text = "👎 \(dislikes)"

        let jarNode = childNode(withName: jarName) as! SKSpriteNode

        let colorRed = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.1)
        let restoreColor = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        let colorize = SKAction.repeat(SKAction.sequence([colorRed, restoreColor]), count: 2)

        //let wrongJar = SKAction.group([colorize])
        SKTAudio.sharedInstance().playSoundEffect("lose.wav")

        jarNode.run(colorize)
    }
    
    func getJarName(name: String) -> String? {
        
        var jarName: String
        if name.starts(with:LocalStrings.labelString){
            let dict = generateJarDict(number: jarNumber)
            if let jar = dict[name]{
                jarName = jar
            }else{
                return nil
            }
        }else{
            jarName = name
        }
        return jarName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == LocalStrings.pastaString ||
                name == LocalStrings.likeString ||
                name == LocalStrings.dislikeString{
                return
            }
            if name == LocalStrings.jarString+"\(theWinner)" ||
                name == LocalStrings.labelString+"\(theWinner)" {
                win(name: name)
            }else if name == LocalStrings.closeString {
                GameScene.parentVC?.dismiss(animated: true, completion: nil)
            }else {
                lose(name: name)
            }
        }
    }
}
