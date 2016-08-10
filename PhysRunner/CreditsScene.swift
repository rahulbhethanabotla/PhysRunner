//
//  CreditsScene.swift
//  PhysRunner
//
//  Created by Rahul Bhethanabotla on 8/5/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    var backButton: MSButtonNode!
    
    
    override func didMoveToView(view: SKView) {
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        backButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = SettingsScene(fileNamed:"SettingsScene") as SettingsScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
}
