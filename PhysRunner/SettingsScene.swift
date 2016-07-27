//
//  SettingsScene.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/20/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    
    /* UI Connections */
    var onToggle: MSToggleNode!
    var offToggle: MSToggleNode!
    var backButton: MSButtonNode!
    
    
    override func didMoveToView(view: SKView) {
        onToggle = self.childNodeWithName("onToggle") as! MSToggleNode
        offToggle = self.childNodeWithName("offToggle") as! MSToggleNode
        
        
        
        
        /* Back button functionality*/
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
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
    }
}
