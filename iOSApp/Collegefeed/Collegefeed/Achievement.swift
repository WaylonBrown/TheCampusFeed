//
//  Achievement.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/29/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class Achievement: NSObject {
    var amountCurrently : Int
    var amountRequired : Int
    var hoursForReward : Int
    var hasAchieved : Bool
    var type : String
    
    override init() {
        amountCurrently = 0
        amountRequired = 0
        hoursForReward = 0
        hasAchieved = false
        type = "Achievement"
        
        super.init()
    }
    
    convenience init(currAmount: Int, reqAmt: Int, rewardHours: Int, achieved: Bool, achievementType: String) {
        self.init()
        
        amountCurrently = currAmount
        amountRequired = reqAmt
        hoursForReward = rewardHours
        hasAchieved = achieved
        type = achievementType
    }
}
