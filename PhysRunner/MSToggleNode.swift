//
//  MSToggleNode.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/18/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import SpriteKit

class MSToggleNode: MSButtonNode {

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectedHandler()
    }
}