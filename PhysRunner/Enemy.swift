//
//  Enemy.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/21/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit


class Enemy: SKSpriteNode {
    
    
    /* Important Instance Variables */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
    }
    
    
    func shootProjectile() {
        let fireball = SKSpriteNode(imageNamed: "blackFire")
        fireball.addChild(self)
        fireball.position.x = self.position.x + 30
        fireball.position.y = self.position.y
        fireball.physicsBody?.applyImpulse(CGVectorMake(-30, 0))
        
    }
    
}