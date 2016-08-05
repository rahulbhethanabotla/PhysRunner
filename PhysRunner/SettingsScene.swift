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
    var backButton: MSButtonNode!
    
    var resetProgressButton: MSButtonNode!
    
    
    override func didMoveToView(view: SKView) {
        
        
        
        
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
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        
        resetProgressButton = self.childNodeWithName("resetProgressButton") as! MSButtonNode
        resetProgressButton.selectedHandler = {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "farthestGameLevel")
        }
    }
    
    
    
}
