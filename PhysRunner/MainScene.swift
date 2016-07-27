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
    
    
    override func didMoveToView(view: SKView) {
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        settingsButton = self.childNodeWithName("settingsButton") as! MSButtonNode
        
        playButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
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
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
    
}