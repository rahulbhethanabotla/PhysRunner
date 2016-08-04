//
//  MainScene.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/19/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene: SKScene {
    
    
    /* UI Connections */
    var playButton: MSButtonNode!
    
    var settingsButton: MSButtonNode!
    
    var titleLabel: SKLabelNode!
    
    var levelMenuButton: MSButtonNode!
    
    
    override func didMoveToView(view: SKView) {
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        settingsButton = self.childNodeWithName("settingsButton") as! MSButtonNode
        levelMenuButton = self.childNodeWithName("levelMenuButton") as! MSButtonNode
        
        
        levelMenuButton.selectedHandler = {
            let skView = self.view as SKView!
            
            let scene = LevelMenuScene(fileNamed: "LevelMenuScene") as LevelMenuScene!
            
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
        
        
        playButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.gameLevel = NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel")
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)

        }
        
        
        settingsButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = SettingsScene(fileNamed:"SettingsScene") as SettingsScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
//        titleLabel.fontName = "Phosphate"
//        titleLabel.fontSize = 96
    }
    
}