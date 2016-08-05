//
//  LevelMenuScene.swift
//  PhysRunner
//
//  Created by Rahul Bhethanabotla on 7/29/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class LevelMenuScene: SKScene {
    
    var backButton: MSButtonNode!
    var level0: MSButtonNode!
    var level1: MSButtonNode!
    var level2: MSButtonNode!
    var level3: MSButtonNode!
    var level4: MSButtonNode!
    var level5: MSButtonNode!
    var level6: MSButtonNode!
    var level7: MSButtonNode!
    var level8: MSButtonNode!
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        backButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)

        }
        
        
        
        
        
        
        level0 = self.childNodeWithName("level0") as! MSButtonNode
        level0.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 0
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)

        }
        
        level1 = self.childNodeWithName("level1") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 1)
        {
            level1.hidden = true
        }
        level1.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 1
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
       
        level2 = self.childNodeWithName("level2") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 2)
        {
            level2.hidden = true
        }
        level2.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 2
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        level3 = self.childNodeWithName("level3") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 3    )
        {
            level3.hidden = true
        }
        level3.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 3
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        level4 = self.childNodeWithName("level4") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 4 )
        {
            level4.hidden = true
        }
        level4.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 4
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        level5 = self.childNodeWithName("level5") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 5 )
        {
            level5.hidden = true
        }
        level5.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 5
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        
        level6 = self.childNodeWithName("level6") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 6 )
        {
            level6.hidden = true
        }
        level6.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 6
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        level7 = self.childNodeWithName("level7") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 7 )
        {
            level7.hidden = true
        }
        level7.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 7
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        level8 = self.childNodeWithName("level8") as! MSButtonNode
        if (NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") < 8 )
        {
            level8.hidden = true
        }
        level8.selectedHandler = {
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = 8
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
    }
    
}
