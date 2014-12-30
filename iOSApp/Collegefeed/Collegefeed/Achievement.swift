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
    
    func toString() -> String {
        if type == VALUE_POST_ACHIEVEMENT {
            var posts = amountRequired == 1 ? "Post" : "Posts"
            return "\(amountRequired) \(posts) (\(hoursForReward) hours)"
        }
        else if type == VALUE_SCORE_ACHIEVEMENT {
            return "\(amountRequired) Points (\(hoursForReward) hours)"
        }
        else if type == VALUE_VIEW_ACHIEVEMENT {
            return "View your Achievements List (\(hoursForReward) hours)"
        }
        else if type == VALUE_SHORT_POST_ACHIEVEMENT {
            return "100 points for a post that's 3 words or less (\(hoursForReward) hours)"
        }
        else if type == VALUE_MANY_HOURS_ACHIEVEMENT {
            return "Have 2,000+ Time Crunch hours (\(hoursForReward) hours)"
        }
        else {
            return "<Achievement String>"
        }
    }
}
