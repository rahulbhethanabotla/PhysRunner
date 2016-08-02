//
//  UserState.swift
//  PhysRunner
//
//  Created by Rahul Bhethanabotla on 8/2/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation


class UserState {
    
    
    var gameLevel: Int = NSUserDefaults.standardUserDefaults().integerForKey("farthestGameLevel") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(gameLevel, forKey:"farthestGameLevel")
            // Saves to disk immediately, otherwise it will save when it has time
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}

