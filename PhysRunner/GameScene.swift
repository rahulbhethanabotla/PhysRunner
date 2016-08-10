//
//  GameScene.swift
//  Playing With Effects
//
//  Created by Rahul Bhethanabotla on 7/12/16.
//  Copyright (c) 2016 Rahul Bhethanabotla. All rights reserved.
//

import SpriteKit
import CoreGraphics
import UIKit
import Mixpanel
import AVFoundation



enum GameState  {
    case Active, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var soundPlayer: AVAudioPlayer!
    
    var isSongPlaying: Bool = false
    
    
    let soundPath = NSBundle.mainBundle().pathForResource("London Atoms.mp3", ofType: nil)!
    
    //let soundURL = NSURL(fileURLWithPath: soundPath)
    var soundURL:NSURL {
        return NSURL(fileURLWithPath: soundPath)
    }
    
    let pi = M_PI
    
    var gameState: GameState = .Active
    
    var levelNode: SKNode!
    
    var gameLevel = 0
    
    var savedLevel = NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel")
    
    var sceneHeight: CGFloat!
    
    var sceneWidth: CGFloat!
    
    var goal: SKEmitterNode!
    
    var charges: [(Int, Int, Int)] = [(0,0,0), (0,100,0), (50,30,0), (10,10,10), (10,10,10), (7, 7 , 7), (15, 15, 15), (20,20,20), (1, 1, 1), (5,5,5)]
    
    var cameraTarget: SKNode?
    
    var hero: SKSpriteNode!
    
    var enemy: [Enemy] = []
    
    var background: SKSpriteNode!
    
    var square: SKSpriteNode!
    
    var light: SKLightNode!
    
    var blackSun: SKSpriteNode!
    
    var sunAtApex = false
    
    var start: CGPoint?
    
    var physicsTab: MSButtonNode!
    
    var radialGravityButton: MSToggleNode!
    
    var linearGravityButton: MSToggleNode!
    
    var velocityVectorButton: MSToggleNode!
    
    var physicsBar: SKSpriteNode!
    
    var startTime: NSTimeInterval?
    
    let kMinDistance = 10
    let kMinDuration = 0.1
    let kMinSpeed = 10
    let kMaxSpeed = 1000
    
    var nextVector: CGVector = CGVectorMake(1, 1)
    
    var wasPhysicsPressed: Bool = false
    
    var wasRadialPressed: Bool = false
    
    var wasLinearPressed: Bool = false
    
    var wasVelocityPressed: Bool = false
    
    var wasOptionsPressed: Bool = false
    
    var isOptionsDown: Bool = false
    
    var isDropDownDown: Bool = false
    
    var moveRightButton: MSButtonNode!
    
    var moveLeftButton: MSButtonNode!
    
    var optionsTab: MSButtonNode!
    
    var optionsBar: SKSpriteNode!
    
    var restartButtonOptions: MSButtonNode!
    
    var restartButtonGO: MSButtonNode!
    
    var pauseButton: MSButtonNode!
    
    var gamePaused: Bool = false
    
    var storedVelocity: CGVector = CGVectorMake(0, 0)
    
    var infoButton: MSButtonNode!
    
    var infoBar: SKSpriteNode!
    
    var isInfoDown: Bool = false
    
    var levelDisplay: SKLabelNode!
    
    var linearCharges: SKLabelNode!
    
    var radialCharges: SKLabelNode!
    
    var velocityCharges: SKLabelNode!
    
    var gameOverScreen: SKSpriteNode!
    
    var fireballCount = 0
    
    var backButtonGO: MSButtonNode!
    
    var backButtonYW: MSButtonNode!
    
    var youWonScreen: SKSpriteNode!
    
    var nextLevelButton: MSButtonNode!
    
    var levelMenuButtonGO: MSButtonNode!
    
    var levelMenuButtonYW: MSButtonNode!
    
    var comingSoon: SKSpriteNode!
    
    var backButtonCS: MSButtonNode!
    
    var levelMenuButtonCS: MSButtonNode!
    
    var restartButtonCS: MSButtonNode!
    
    var cameraY: CGFloat!
    
    var cameraX: CGFloat!
    
    var isLevelWon: Bool!
    
    
    override func didMoveToView(view: SKView) {
        
        //        let mixpanel = Mixpanel.sharedInstanceWithToken(token)
        
        levelNode = self.childNodeWithName("levelNode")
        
        physicsWorld.contactDelegate = self
        
        //        view.showsPhysics = false
        
        
        /* Load the level */
        
        let resourcePath = NSBundle.mainBundle().pathForResource("Level " + "\(gameLevel)", ofType: ".sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
        sceneHeight = newLevel.calculateAccumulatedFrame().height
        sceneWidth = newLevel.calculateAccumulatedFrame().width
        //        print("HAVE U SCENE ME h: \(sceneHeight) w: \(sceneWidth)")
        
        for child in newLevel.children.first!.children {
            if (child.name == "enemy") {
                enemy.append(child.children.first!.children.first as! Enemy)
                
            }
        }
        
        goal = self.childNodeWithName("//goal") as! SKEmitterNode
        
        
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        /* Setup the background image */
        //        background = self.childNodeWithName("background") as! SKSpriteNode
        //        background.size = self.size
        //        background.zPosition = -5
        //        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        
        //        /* Setup the blackSun image and starting position */
        //
        //        blackSun = self.childNodeWithName("blackSun") as! SKSpriteNode
        //        blackSun.position = CGPointMake(0, 0)
        //        blackSun.zPosition = -2
        
        if (!isSongPlaying) {
            do {
                let sound = try AVAudioPlayer(contentsOfURL: soundURL)
                sound.numberOfLoops = Int(FP_INFINITE)
                soundPlayer = sound
                sound.play()
            }
            catch {
                // new meme
            }
        }
        /* Setup the background lighting/ambience */
        
        light = self.childNodeWithName("//light") as! SKLightNode
        light?.categoryBitMask = 1
        light?.falloff = 1
        
        
        /* Setup the physics button and children buttons */
        
        physicsTab = camera!.childNodeWithName("physicsTab") as! MSButtonNode
        physicsBar = physicsTab.childNodeWithName("physicsBar") as! SKSpriteNode
        physicsBar.hidden = false
        
        if (gameLevel < 1) {
            physicsTab.hidden = true
        }
        physicsTab.selectedHandler = {
            self.wasPhysicsPressed = !self.wasPhysicsPressed
            if (self.isDropDownDown) {
                let moveUp = SKAction.moveToY(-24.6, duration: 0)
                let hide = SKAction.hide()
                let sequence = SKAction.sequence([hide, moveUp ])
                
                self.physicsBar.runAction(sequence)
                self.isDropDownDown = false
            }
            else {
                let dropDown = SKAction.moveToY(-175, duration: 0)
                let unhide = SKAction.unhide()
                let sequence = SKAction.sequence([unhide, dropDown])
                
                self.physicsBar.runAction(sequence)
                self.isDropDownDown = true
            }
        }
        
        radialGravityButton = physicsBar.childNodeWithName("radialGravityButton") as! MSToggleNode
        if (gameLevel < 3) {
            radialGravityButton.hidden = true
        }
        //        if (!self.wasLinearPressed && !self.wasVelocityPressed) {
        radialGravityButton.selectedHandler = {
            if (!self.wasRadialPressed) {
                self.unspaghetti()
                self.radialGravityButton.alpha = 0.4
            }
            else {
                self.radialGravityButton.state = .Active
            }
            self.wasRadialPressed = !self.wasRadialPressed
        }
        //        }
        
        velocityVectorButton = physicsBar.childNodeWithName("velocityVectorButton") as! MSToggleNode
        if (gameLevel < 2) {
            velocityVectorButton.hidden = true
        }
        
        //        if (!self.wasRadialPressed && !self.wasLinearPressed) {
        velocityVectorButton.selectedHandler = {
            if (!self.wasVelocityPressed) {
                /* Unspaghetti resets all the values of the buttons */
                self.unspaghetti()
                self.velocityVectorButton.alpha = 0.4
            }
            else {
                self.velocityVectorButton.state = .Active
            }
            print("click")
            self.wasVelocityPressed = !self.wasVelocityPressed
        }
        //        }
        
        
        linearGravityButton = physicsBar.childNodeWithName("linearGravityButton") as! MSToggleNode
        if (gameLevel < 1) {
            linearGravityButton.hidden = true
        }
        
        //        if (!self.wasRadialPressed && !self.wasVelocityPressed) {
        linearGravityButton.selectedHandler = {
            if (!self.wasLinearPressed) {
                self.unspaghetti()
                self.linearGravityButton.alpha = 0.4
                
                print("linear pressed")
            }
            else {
                self.linearGravityButton.state = .Active
                print("linear unpressed")
            }
            self.wasLinearPressed = !self.wasLinearPressed
        }
        
        //        }
        
        moveRightButton = camera!.childNodeWithName("moveRightButton") as! MSButtonNode
        moveRightButton.selectedHandler = {
            if (self.hero.xScale < 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(15, 0))
        }
        
        moveLeftButton = camera!.childNodeWithName("moveLeftButton") as! MSButtonNode
        moveLeftButton.selectedHandler = {
            if (self.hero.xScale > 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(-15, 0))
        }
        
        optionsTab = camera!.childNodeWithName("optionsTab") as! MSButtonNode
        optionsBar = optionsTab.childNodeWithName("optionsBar") as! SKSpriteNode
        optionsTab.selectedHandler = {
            self.wasOptionsPressed = !self.wasOptionsPressed
            if (self.isOptionsDown) {
                let moveUp = SKAction.moveToY(-24.6, duration: 0)
                let hide = SKAction.hide()
                let sequence = SKAction.sequence([hide, moveUp ])
                
                self.optionsBar.runAction(sequence)
                self.isOptionsDown = false
            }
            else {
                let dropDown = SKAction.moveToY(-180, duration: 0)
                let unhide = SKAction.unhide()
                let sequence = SKAction.sequence([unhide, dropDown])
                
                self.optionsBar.runAction(sequence)
                self.isOptionsDown = true
            }
            
        }
        
        restartButtonOptions = optionsBar.childNodeWithName("restartButtonOptions") as! MSButtonNode
        restartButtonOptions.selectedHandler = {
            self.gameState = .Active
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.gameLevel = self.gameLevel
            scene.isSongPlaying = true
          //  scene.scaleMode = .AspectFit
            skView.presentScene(scene)
            
        }
        
        pauseButton = optionsBar.childNodeWithName("pauseButton") as! MSButtonNode
        pauseButton.selectedHandler = {
            //(self.scene?.view?.paused = !(self.scene?.view?.paused)!)!
            //self.scene!.paused = !self.scene!.paused
            if (self.gamePaused) {
                self.hero.paused = !self.hero.paused
                self.hero.physicsBody?.velocity = self.storedVelocity
                self.physicsWorld.speed = 1
            }
            else {
                self.hero.paused = !self.hero.paused
                self.storedVelocity = (self.hero.physicsBody?.velocity)!
                print(self.storedVelocity)
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
                print(self.storedVelocity)
                self.moveRightButton.paused = !self.moveRightButton.paused
                self.moveLeftButton.paused = !self.moveRightButton.paused
                self.physicsWorld.speed = 0
            }
            self.gamePaused = !self.gamePaused
            
        }
        
        infoButton = optionsBar.childNodeWithName("infoButton") as! MSButtonNode
        infoBar = self.childNodeWithName("infoBar") as! SKSpriteNode
        
        /* info bar actions to show level info */
        let moveDown = SKAction.moveToY(((self.camera?.position.y)! + 100), duration: 1.0)
        let moveToX = SKAction.moveToX((self.camera?.position.x)!, duration: 1.0)
        let goUp = SKAction.moveToY(1000, duration: 1.0)
        let wait = SKAction.waitForDuration(1.5)
        let sequence = SKAction.sequence([moveToX, moveDown, wait, goUp])
        self.infoBar.runAction(sequence)
        
        infoButton.selectedHandler = {
            let moveDown = SKAction.moveToY((self.camera?.position.y)!, duration: 0.6)
            let moveToX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
            let seq = SKAction.sequence([moveToX,moveDown])
            let goUp = SKAction.moveToY(500, duration: 0.6)
            if (self.isInfoDown) { self.infoBar.runAction(goUp) }
            else { self.infoBar.runAction(seq) }
            self.isInfoDown = !self.isInfoDown
        }
        
        
        levelDisplay = infoBar.childNodeWithName("levelDisplay") as! SKLabelNode
        levelDisplay.text = "Level " + "\(gameLevel)"
        linearCharges = infoBar.childNodeWithName("linearCharges") as! SKLabelNode
        linearCharges.text = "\(charges[gameLevel].1)" + "x"
        radialCharges = infoBar.childNodeWithName("radialCharges") as! SKLabelNode
        radialCharges.text = "\(charges[gameLevel].2)" + "x"
        velocityCharges = infoBar.childNodeWithName("velocityCharges") as! SKLabelNode
        velocityCharges.text = "\(charges[gameLevel].0)" + "x"
        
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        
        restartButtonGO = gameOverScreen.childNodeWithName("restartButtonGO") as! MSButtonNode
        restartButtonGO.selectedHandler = {
            self.gameState = .Active
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.gameLevel = self.gameLevel
            scene.isSongPlaying = true
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        }
        
        
        
        /* Back button functionality*/
        backButtonGO = gameOverScreen.childNodeWithName("backButtonGO") as! MSButtonNode
        backButtonGO.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        
        youWonScreen = self.childNodeWithName("youWonScreen") as! SKSpriteNode
        
        backButtonYW = youWonScreen.childNodeWithName("backButtonYW") as! MSButtonNode
        backButtonYW.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        
        
        
        
        
        nextLevelButton = youWonScreen.childNodeWithName("nextLevelButton") as! MSButtonNode
        nextLevelButton.selectedHandler = {
            self.gameState = .Active
            let skView = self.view as SKView!
            self.gameLevel++
            
            /* update the farthestGameLevel */
            if (self.gameLevel > NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel")) {
                NSUserDefaults.standardUserDefaults().setInteger(self.gameLevel, forKey: "farthestGameLevel")
            }
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.gameLevel = self.gameLevel
            scene.isSongPlaying = true
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
            
            skView.showsFPS = false
            skView.showsPhysics = false
            skView.showsDrawCount = false
            
        }
        
        
        levelMenuButtonGO = gameOverScreen.childNodeWithName("levelMenuButtonGO") as! MSButtonNode
        levelMenuButtonGO.selectedHandler = {
            let skView = self.view as SKView!
            let scene = LevelMenuScene(fileNamed: "LevelMenuScene") as LevelMenuScene!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        }
        
        levelMenuButtonYW = youWonScreen.childNodeWithName("levelMenuButtonYW") as! MSButtonNode
        levelMenuButtonYW.selectedHandler = {
            let skView = self.view as SKView!
            let scene = LevelMenuScene(fileNamed: "LevelMenuScene") as LevelMenuScene!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        }
        
        
        comingSoon = self.childNodeWithName("comingSoon") as! SKSpriteNode
        restartButtonCS = comingSoon.childNodeWithName("restartButtonCS") as! MSButtonNode
        restartButtonCS.selectedHandler = {
            self.gameState = .Active
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.gameLevel = self.gameLevel
            scene.isSongPlaying = true
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        }
        
        backButtonCS = comingSoon.childNodeWithName("backButtonCS") as! MSButtonNode
        backButtonCS.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        levelMenuButtonCS = comingSoon.childNodeWithName("levelMenuButtonCS") as! MSButtonNode
        levelMenuButtonCS.selectedHandler = {
            let skView = self.view as SKView!
            let scene = LevelMenuScene(fileNamed: "LevelMenuScene") as LevelMenuScene!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        }
        
        
        
    }
    
    func unspaghetti() {
        self.wasRadialPressed = false
        self.wasLinearPressed = false
        self.wasVelocityPressed = false
        self.radialGravityButton.alpha = 1
        self.linearGravityButton.alpha = 1
        self.velocityVectorButton.alpha = 1
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        
        if (wasPhysicsPressed) {
            for touch in touches {
                let loc = touch.locationInNode(self)
            }
            
            /* Avoid multi-touch gestures (optional) */
            if touches.count > 1 {
                return
            }
            let touch: UITouch = touches.first!
            let location: CGPoint = touch.locationInNode(self)
            // Save start location and time
            start = location
            startTime = touch.timestamp
            
            if (wasRadialPressed && charges[gameLevel].2 > 0 && !wasVelocityPressed && !wasLinearPressed) {
                for child in self.children {
                    if let _ = child as? SKFieldNode {
                        child.removeFromParent()
                    }
                }
                createRadialGravityNode(location)
                charges[gameLevel].2 -= 1
            }
            
            if (wasLinearPressed && charges[gameLevel].1 > 0 && !wasRadialPressed && !wasVelocityPressed) {
                for child in self.children {
                    if let _ = child as? SKFieldNode {
                        child.removeFromParent()
                    }
                }
                createLinearGravityNode(location)
                charges[gameLevel].1 -= 1
            }
            
        }
        
        //cameraTarget = hero
        
        //
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (wasPhysicsPressed) {
            let touch: UITouch = touches.first!
            let location: CGPoint = touch.locationInNode(self)
            // Determine distance from the starting point
            var dx: CGFloat = location.x - start!.x
            var dy: CGFloat = location.y - start!.y
            let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
            if Int(magnitude) >= kMinDistance {
                // Determine time difference from start of the gesture
                let dt: CGFloat = CGFloat(touch.timestamp - startTime!)
                if Double(dt) > kMinDuration {
                    // Determine gesture speed in points/sec
                    let speed: CGFloat = magnitude / dt
                    if Int(speed) >= kMinSpeed && Int(speed) <= kMaxSpeed {
                        // Calculate normalized direction of the swipe
                        dx = dx / magnitude
                        dy = dy / magnitude
                        print("Swipe detected with speed = \(speed) and direction (\(dx), \(dy))")
                        nextVector = CGVectorMake(dx, dy)
                        if (wasVelocityPressed && charges[gameLevel].0 > 0 && !wasRadialPressed && !wasLinearPressed) {
                            for child in self.children {
                                if let _ = child as? SKFieldNode {
                                    child.removeFromParent()
                                }
                            }
                            createVelocityFieldNode(start!)
                            charges[gameLevel].0 -= 1
                        }
                        
                    }
                }
            }
            
        }
    }
    
    
    var lastTime: CFTimeInterval = 0
    
    
    override func update(currentTime: CFTimeInterval) {
        if (gamePaused || gameState == .GameOver) { return }
        
        
        if (hero.position.x < -50 || hero.position.y < -300 || hero.position.x > 1568) {
            heroDies(hero)
            return
        }
        
        
        velocityCharges.text = "\(charges[gameLevel].0)" + "x"
        linearCharges.text = "\(charges[gameLevel].1)" + "x"
        radialCharges.text = "\(charges[gameLevel].2)" + "x"
        
        cameraX = self.camera?.position.x
        
        cameraY = self.camera?.position.y
        
       
        
        
        let goalPos = levelNode.convertPoint(goal.position, toNode: self)
        let heroPos = hero.parent!.convertPoint(hero.position, toNode: self)
        if ( heroPos.x >= goalPos.x && gameLevel < 8 && isLevelWon != false) {
            print(heroPos.x >= goalPos.x)
            
            //let moveY = SKAction.moveToY((self.camera?.position.y)!, duration: 0.6)
            let moveY = SKAction.moveToY((200), duration: 0.6)
            //let moveX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
            let moveX = SKAction.moveToX((1280), duration: 0.6)
            let seq = SKAction.sequence([moveX, moveY])
            youWonScreen.runAction(seq)
            isLevelWon = true
            gameState = .GameOver
            
            Mixpanel.sharedInstance().track("Level Cleared", properties: ["Level Number": "\(gameLevel)"])
        }
        
        if ( heroPos.x >= goalPos.x && gameLevel == 8 && isLevelWon != false) {
            print(heroPos.x >= goalPos.x)
            //let moveY = SKAction.moveToY((self.camera?.position.y)!, duration: 0.6)
            //let moveX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
            let moveY = SKAction.moveToY((200), duration: 0.6)
            let moveX = SKAction.moveToX((1280), duration: 0.6)
            let seq = SKAction.sequence([moveX, moveY])
            comingSoon.runAction(seq)
            gameState = .GameOver
            
            Mixpanel.sharedInstance().track("Level Cleared", properties: ["Level Number": "\(gameLevel)"])
        }

    
        
        
//        if ((isLevelWon) != nil) {
//            if (isLevelWon == true) {
//                var moveToX = SKAction.moveToX(youWonScreen.position.x, duration: 0.6)
//                var moveToY = SKAction.moveToY(youWonScreen.position.y, duration: 0.6)
//                var seq = SKAction.sequence([moveToX,moveToY])
//                camera?.runAction(seq)
//            }
//            if (isLevelWon == false) {
//                var moveToX = SKAction.moveToX(gameOverScreen.position.x, duration: 0.6)
//                var moveToY = SKAction.moveToY(gameOverScreen.position.y, duration: 0.6)
//                var seq = SKAction.sequence([moveToX,moveToY])
//                camera?.runAction(seq)
//            }
//            
//            
//        }
//
        
        
        
        
        /* setting the tutorial helpers */
        if (gameLevel == 0) {
            var changeColor = SKAction.colorizeWithColor(UIColor.cyanColor(), colorBlendFactor: 0.4, duration: 3.0)
            var changeBack = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.4, duration: 3.0)
            var seq = SKAction.sequence([changeColor, changeBack])
            moveRightButton.runAction(seq)
            moveLeftButton.runAction(seq)
        }
        
        if (gameLevel == 1) {
            var changeColor = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 0.4, duration: 3.0)
            var changeBack = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.4, duration: 3.0)
            var seq = SKAction.sequence([changeColor, changeBack])
            physicsTab.runAction(seq)
            linearGravityButton.runAction(seq)
        }
        
        if (gameLevel == 2) {
            var changeColor = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 0.4, duration: 3.0)
            var changeBack = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.4, duration: 3.0)
            var seq = SKAction.sequence([changeColor, changeBack])
            velocityVectorButton.runAction(seq)
        }
        
        if (gameLevel == 3) {
            var changeColor = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 0.4, duration: 3.0)
            var changeBack = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.4, duration: 3.0)
            var seq = SKAction.sequence([changeColor, changeBack])
            radialGravityButton.runAction(seq)
        }
        
        
        /* Called before each frame is rendered */
        //        if (abs(blackSun.position.y - 320) <= 0.1) {
        //            sunAtApex = true
        //        }
        //
        //
        //
        //
        //
        //
        //
        //
        //        if (sunAtApex == false){
        //            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y + (320/284))
        //            //print("x = \(blackSun.position.x)")
        //            //print("y = \(blackSun.position.y)")
        //        }
        //        else {
        //            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y - (320/284))
        //        }
        //
        
        
        
        /* runs through all the enemies and make them fire */
        let ticker = currentTime - lastTime
        if (ticker > 10) {
            for en in enemy {
                
                let fireball = SKSpriteNode(imageNamed: "blackFire")
                fireball.size = CGSizeMake(50, 20)
                fireball.physicsBody = SKPhysicsBody(texture: fireball.texture!, size: fireball.size)
                fireball.name = "fireball"
                fireball.physicsBody?.affectedByGravity = false
                fireball.physicsBody?.allowsRotation = false
                fireball.physicsBody?.linearDamping = 0
                fireball.physicsBody?.friction = 0
                //                var rotate = SKAction.rotateToAngle(CGFloat(M_PI/2.00), duration: 0)
                //                fireball.runAction(rotate)
                fireball.physicsBody?.categoryBitMask = 2
                fireball.physicsBody?.contactTestBitMask = 5
                fireball.physicsBody?.collisionBitMask = 0
                if (en.parent?.parent!.xScale > 0) {
                    fireball.position.x = en.position.x - 50
                }
                else {
                    fireball.position.x = en.position.x - 50
                    
                }
                fireball.position.y = en.position.y - 10
                fireball.zPosition = 4
                en.addChild(fireball)
                if (en.parent!.parent!.xScale > 0) {
                    fireball.physicsBody?.applyImpulse(CGVectorMake(-2, 0))
                }
                else {
                    fireball.xScale * -1
                    fireball.physicsBody?.applyImpulse(CGVectorMake(2, 0))
                }
                
                
                //                en.shootProjectile()
            }
            fireballCount++
            lastTime = currentTime
        }
        
        
        
        /* Camera and screen boundary settings */
        let heroPosition = hero.parent!.parent!.convertPoint(hero.position, toNode: self)
        
        cameraTarget = hero
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            if (hero.xScale > 0) {
//                camera?.position = CGPoint(x: heroPosition.x + 203, y: heroPosition.y)
                var camPosition = CGPoint(x: heroPosition.x + 203, y: heroPosition.y)
                camPosition.x.clamp(284, 1285)
                camPosition.y.clamp(160 , sceneHeight - 160)
                camera?.runAction(SKAction.moveTo(camPosition, duration: 0.4))
            }
            else {
//                camera?.position = CGPoint(x: heroPosition.x - 182, y: heroPosition.y)
                var camPosition = CGPoint(x: heroPosition.x - 182, y: heroPosition.y)
                camPosition.x.clamp(284, 1285)
                camPosition.y.clamp(160 , sceneHeight - 160)
                camera?.runAction(SKAction.moveTo(camPosition, duration: 0.4))
            }
        }
        
//        hero.paused = true
        
        /* Clamp camera scrolling to our visible scene area only */
        camera?.position.x.clamp(283, 1285)
        camera?.position.y.clamp(160 , sceneHeight - 160)
        //        print("x: \(CGFloat((camera?.position.x)!)) heroX: \(hero.position.x)")
        //        print("y: \(CGFloat((camera?.position.y)!)) heroY: \(hero.position.y)")
        
        
        
        
//        
//        if (abs(Float((hero.physicsBody?.velocity.dx)!)) < 1) {
//            
//            
//            var idleText1 = SKTexture(imageNamed: "1")
//            var growSide = SKAction.resizeToWidth(idleText1.size().width*1.3, duration: 0)
//            var growUp = SKAction.resizeToHeight(idleText1.size().height*1.3, duration: 0)
//            var idle = SKAction.animateWithTextures([idleText1], timePerFrame: 0)
//            var seq = SKAction.sequence([growSide, growUp, idle])
//            hero.runAction(seq)
//            hero.speed = 0
//            
//        }
//        else {
//            hero.speed = 1
//        }
//        

       
    
    
    }
    
    
    
    
    
    
    
    
    
    
    /* creates a radial gravity node at the point */
    func createRadialGravityNode(point: CGPoint) {
        let rGrav = SKFieldNode.radialGravityField()
        rGrav.enabled = true
        rGrav.position = point
        rGrav.strength = 0.8
        rGrav.falloff = 0.5
        rGrav.region = SKRegion(size: CGSizeMake(100,100))
        self.addChild(rGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        rGrav.addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = CGPointMake(0, 0)
        fieldRadius.size = CGSizeMake(300, 300)
        fieldRadius.color = UIColor(white: 1.0, alpha: 1.0)
        fieldRadius.alpha = 0.2
    }
    
    
    /* creates a linear gravity node at the point */
    func createLinearGravityNode(point: CGPoint) {
        let gravityVector: vector_float3 = [0, -1, 0]
        let lGrav = SKFieldNode.linearGravityFieldWithVector(gravityVector)
        lGrav.enabled = true
        lGrav.position = point
        lGrav.strength = 1
        lGrav.falloff = 0.01
        self.addChild(lGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        lGrav.addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = CGPointMake(0, 0)
        fieldRadius.size = CGSizeMake(150, 150)
        fieldRadius.alpha = 0.2
        lGrav.region = SKRegion(radius: Float(fieldRadius.size.height/2))
    }
    
    
    /* creates a linear velocity field at the point */
    func createVelocityFieldNode(point: CGPoint) {
        /* Create the actual physics field node */
        let velocityVector: vector_float3 = [Float(nextVector.dx * 0.3), Float(nextVector.dy * 0.3), 0]
        let vField = SKFieldNode.velocityFieldWithVector(velocityVector)
        vField.enabled = true
        vField.position = point
        let magnitude: CGFloat = sqrt(nextVector.dx * nextVector.dx + nextVector.dy  * nextVector.dy)
        vField.strength = 1.0 //* Float(magnitude*3000)
        vField.falloff = 0.01
        //vField.region = SKRegion(size: frame.size)
        self.addChild(vField)
        
        /* Create the arrow that signifies the direction and magnitude of the force */
        let velocityArrow = SKSpriteNode(imageNamed: "VelocityArrow")
        var theta = atan2f(Float(nextVector.dy), Float(nextVector.dx))
        //        if (nextVector.dx < 0 && nextVector.dy > 0) {
        //            theta = theta + Float(pi)
        //        }
        //        if (nextVector.dx < 0 && nextVector.dy < 0) {
        //            theta = theta - Float(pi)
        //        }
        print(theta)
        let rotate = SKAction.rotateToAngle(CGFloat(theta) + CGFloat(pi*0.05), duration: 0.0)
        
        vField.addChild(velocityArrow)
        velocityArrow.zPosition = -1
        velocityArrow.position = CGPointMake(0, 0)
        velocityArrow.size = CGSizeMake(50, 50)
        velocityArrow.alpha = 0.2
        velocityArrow.runAction(rotate)
        vField.region = SKRegion(radius: Float(velocityArrow.size.height))
    }
    
    
    
    
    func heroDies(node: SKNode) {
        let heroDeath = SKAction.runBlock({
            node.removeFromParent()
        })
        
        if (isLevelWon != true) {
            self.runAction(heroDeath)
        
            let moveUp = SKAction.moveToY((self.camera?.position.y)!, duration: 0.6)
        
            let moveToX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
        
            let seq = SKAction.sequence([moveToX, moveUp])
            
            gameOverScreen.runAction(seq)
            
            isLevelWon = false
        
            camera?.removeAllActions()
            
            gameState = .GameOver
            
        
            Mixpanel.sharedInstance().track("Level Failed", properties: ["Level Number": "\(gameLevel)"])
        }
        
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* physics contact info setup */
        
        /* bodies in the collision */
        
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        
        if (contactA.node == nil || contactB.node == nil) {
            return
        }
        
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        
        
        /* Check if any of the nodes was a fireball */
        if (contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2) {
            
            /* kill hero */
            if (contactA.node!.name == "hero") {
                heroDies(nodeA)
                nodeB.removeFromParent()
            }
            if (contactB.node!.name == "hero") {
                heroDies(nodeB)
                nodeA.removeFromParent()
            }
            
            
        }
        
        if (contactA.categoryBitMask == 4 || contactB.categoryBitMask == 4) {
            if (contactA.node!.name == "fireball") {
                nodeA.removeFromParent()
            }
            
            if (contactB.node!.name == "fireball") {
                nodeB.removeFromParent()
            }
        }
        
    }
}
