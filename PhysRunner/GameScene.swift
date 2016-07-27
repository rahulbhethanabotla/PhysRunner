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



enum GameState {
    case Active, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let pi = M_PI
    
    var gameState: GameState = .Active
    
    var levelNode: SKNode!
    
    var gameLevel = 0
    
    var goal: SKEmitterNode!
    
    
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
    
    var backButton: MSButtonNode!
    
    var youWonScreen: SKSpriteNode!
    
    
    override func didMoveToView(view: SKView) {
        
        levelNode = self.childNodeWithName("levelNode")
        
        physicsWorld.contactDelegate = self
        
        /* Load the level */
        var resourcePath = NSBundle.mainBundle().pathForResource("Level" + "\(gameLevel)", ofType: ".sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
        //enemy.append(newLevel.childNodeWithName("//enemy") as! Enemy)
        
        goal = self.childNodeWithName("//goal") as! SKEmitterNode
        
        
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        /* Setup the background image */
        background = self.childNodeWithName("background") as! SKSpriteNode
        background.size = self.size
        background.zPosition = -5
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        
        /* Setup the blackSun image and starting position */
        
        blackSun = self.childNodeWithName("blackSun") as! SKSpriteNode
        blackSun.position = CGPointMake(0, 0)
        blackSun.zPosition = -2
        
        
        /* Setup the background lighting/ambience */
        
        light = self.childNodeWithName("//light") as! SKLightNode
        light?.categoryBitMask = 1
        light?.falloff = 1
        
        
        /* Setup the physics button and children buttons */
        
        physicsTab = camera!.childNodeWithName("physicsTab") as! MSButtonNode
        physicsBar = physicsTab.childNodeWithName("physicsBar") as! SKSpriteNode
        physicsBar.hidden = false
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
        radialGravityButton.selectedHandler = {
            
            if (!self.wasRadialPressed) {
                self.radialGravityButton.alpha = 0.4
            }
            else {
                self.radialGravityButton.state = .Active
            }
            self.wasRadialPressed = !self.wasRadialPressed
        }
        
        velocityVectorButton = physicsBar.childNodeWithName("velocityVectorButton") as! MSToggleNode
        velocityVectorButton.selectedHandler = {
            
            if (!self.wasVelocityPressed) {
                self.velocityVectorButton.alpha = 0.4
            }
            else {
                self.velocityVectorButton.state = .Active
            }
            print("click")
            self.wasVelocityPressed = !self.wasVelocityPressed
        }
        
        linearGravityButton = physicsBar.childNodeWithName("linearGravityButton") as! MSToggleNode
        linearGravityButton.selectedHandler = {
            
            if (!self.wasLinearPressed) {
                self.linearGravityButton.alpha = 0.4
                print("linear pressed")
            }
            else {
                self.linearGravityButton.state = .Active
                print("linear unpressed")
            }
            self.wasLinearPressed = !self.wasLinearPressed
        }
        
        
        
        moveRightButton = camera!.childNodeWithName("moveRightButton") as! MSButtonNode
        moveRightButton.selectedHandler = {
            if (self.hero.xScale < 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(10, 0))
        }
        
        moveLeftButton = camera!.childNodeWithName("moveLeftButton") as! MSButtonNode
        moveLeftButton.selectedHandler = {
            if (self.hero.xScale > 0) {
                self.hero.xScale = -self.hero.xScale
                self.hero.physicsBody?.velocity = CGVectorMake(0, 0)
            }
            self.hero.physicsBody?.applyImpulse(CGVectorMake(-10, 0))
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
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        
       
        
        pauseButton = optionsBar.childNodeWithName("pauseButton") as! MSButtonNode
        pauseButton.selectedHandler = {
            //(self.scene?.view?.paused = !(self.scene?.view?.paused)!)!
            //self.scene!.paused = !self.scene!.paused
            if (self.gamePaused) {
                self.hero.paused = !self.hero.paused
                self.hero.physicsBody?.velocity = self.storedVelocity
                print(self.enemy[0].children[0])
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
        infoButton.selectedHandler = {
            let moveDown = SKAction.moveToY(250, duration: 0.6)
            let moveToX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
            let seq = SKAction.sequence([moveToX,moveDown])
            let goUp = SKAction.moveToY(500, duration: 0.6)
            if (self.isInfoDown) { self.infoBar.runAction(goUp) }
            else { self.infoBar.runAction(seq) }
            self.isInfoDown = !self.isInfoDown
            
                
            
        }
        
        
        levelDisplay = infoBar.childNodeWithName("levelDisplay") as! SKLabelNode
        linearCharges = infoBar.childNodeWithName("linearCharges") as! SKLabelNode
        radialCharges = infoBar.childNodeWithName("radialCharges") as! SKLabelNode
        velocityCharges = infoBar.childNodeWithName("velocityCharges") as! SKLabelNode
        
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        
        restartButtonGO = gameOverScreen.childNodeWithName("restartButtonGO") as! MSButtonNode
        restartButtonGO.selectedHandler = {
            self.gameState = .Active
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        
        
        /* Back button functionality*/
        backButton = gameOverScreen.childNodeWithName("backButton") as! MSButtonNode
        backButton.selectedHandler = {
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
            if (wasRadialPressed) { createRadialGravityNode(location) }
            if (wasLinearPressed) { createLinearGravityNode(location) }
            
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
                        if (wasVelocityPressed) { createVelocityFieldNode(start!) }
                        
                    }
                }
            }
            
        }
    }
    
    
    var lastTime: CFTimeInterval = 0
    
    
    override func update(currentTime: CFTimeInterval) {
        if (gamePaused || gameState == .GameOver) { return }
        
        
        if (hero.position.x < 0 || hero.position.y < 0 || hero.position.x > 1568) {
            heroDies(hero)
        }
        
        
        let goalPos = levelNode.convertPoint(goal.position, toNode: self)
        let heroPos = hero.parent!.convertPoint(hero.position, toNode: self)
        if ( heroPos.x >= goalPos.x ) {
            print(heroPos.x >= goalPos.x)
            let moveY = SKAction.moveToY(200, duration: 0.6)
            let moveX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
            let seq = SKAction.sequence([moveX, moveY])
            youWonScreen.runAction(seq)
            gameState = .GameOver
        }
        
        
        
        /* Called before each frame is rendered */
        if (abs(blackSun.position.y - 320) <= 0.1) {
            sunAtApex = true
        }
        
        if (sunAtApex == false){
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y + (320/284))
            //print("x = \(blackSun.position.x)")
            //print("y = \(blackSun.position.y)")
        }
        else {
            blackSun.position = CGPointMake(blackSun.position.x + 1, blackSun.position.y - (320/284))
        }
        
        
        
        let ticker = currentTime - lastTime
        if (ticker > 10) {
            for en in enemy {
                
                    let fireball = SKSpriteNode(imageNamed: "blackFire")
                    fireball.size = CGSizeMake(50, 20)
                    fireball.physicsBody = SKPhysicsBody(texture: fireball.texture!, size: fireball.size)
                    fireball.name = "Fireball\(fireballCount)"
                    fireball.physicsBody?.affectedByGravity = false
                    fireball.physicsBody?.allowsRotation = false
                    //                var rotate = SKAction.rotateToAngle(CGFloat(M_PI/2.00), duration: 0)
                    //                fireball.runAction(rotate)
                    fireball.physicsBody?.categoryBitMask = 2
                    fireball.physicsBody?.contactTestBitMask = 1
                    fireball.physicsBody?.collisionBitMask = 0
                    fireball.position.x = en.position.x - 50
                    fireball.position.y = en.position.y - 10
                    fireball.zPosition = 4
                    en.addChild(fireball)
                    fireball.physicsBody?.applyImpulse(CGVectorMake(-2, 0))

                
                print(enemy[0].children[fireballCount])
//                en.shootProjectile()
            }
            fireballCount++
            lastTime = currentTime
        }
        
        cameraTarget = hero

        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x, y:camera!.position.y)
        }
        /* Clamp camera scrolling to our visible scene area only */
        camera?.position.x.clamp(283, 1285)
    }
    
    
    
    
    
    
    
    
    
    
    
    func createRadialGravityNode(point: CGPoint) {
        let rGrav = SKFieldNode.radialGravityField()
        rGrav.enabled = true
        rGrav.position = point
        rGrav.strength = 0.8
        rGrav.falloff = 0.01
        rGrav.region = SKRegion(size: CGSizeMake(100,100))
        addChild(rGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = point
        fieldRadius.size = CGSizeMake(300, 300)
        fieldRadius.color = UIColor(white: 1.0, alpha: 1.0)
        fieldRadius.alpha = 0.2
    }
    
    func createLinearGravityNode(point: CGPoint) {
        let gravityVector: vector_float3 = [0, -1, 0]
        let lGrav = SKFieldNode.linearGravityFieldWithVector(gravityVector)
        lGrav.enabled = true
        lGrav.position = point
        lGrav.strength = 1
        lGrav.falloff = 0.01
        addChild(lGrav)
        let fieldRadius = SKSpriteNode(imageNamed: "Blue_Circle")
        addChild(fieldRadius)
        fieldRadius.zPosition = -2
        fieldRadius.position = point
        fieldRadius.size = CGSizeMake(100, 100)
        fieldRadius.alpha = 0.2
        lGrav.region = SKRegion(radius: Float(fieldRadius.size.height))
    }
    
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
        addChild(vField)
        
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
        
        addChild(velocityArrow)
        velocityArrow.zPosition = -1
        velocityArrow.position = point
        velocityArrow.size = CGSizeMake(50, 50)
        velocityArrow.alpha = 0.2
        velocityArrow.runAction(rotate)
        vField.region = SKRegion(radius: Float(velocityArrow.size.height))
    }
    
    
    
    
    func heroDies(node: SKNode) {
        let heroDeath = SKAction.runBlock({
            node.removeFromParent()
        })
        
        
        self.runAction(heroDeath)
        
        let moveUp = SKAction.moveToY(200, duration: 0.6)
        
        let moveToX = SKAction.moveToX((self.camera?.position.x)!, duration: 0.6)
        
        let seq = SKAction.sequence([moveToX, moveUp])
        
        gameOverScreen.runAction(seq)
        
        gameState = .GameOver
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* physics contact info setup */
        
        /* bodies in the collision */
        
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
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
        
    }
}
