//
//  Achievement.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/29/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class Achievement: NSObject {
    var achievementId : Int = 0
    var amountCurrently : Int = 0
    var amountRequired : Int = 0
    var hoursForReward : Int = 0
    var hasAchieved : Bool = false
    var type: String = "Achievement"
    
    convenience init(id: Int, currAmount: Int, reqAmt: Int, rewardHours: Int, achievementType: String, didAchieve: Bool) {
        self.init()
        
        achievementId = id
        amountCurrently = currAmount
        amountRequired = reqAmt
        hoursForReward = rewardHours
        type = achievementType
        hasAchieved = didAchieve
    }
    
    func isEqualTo(other: Achievement) -> Bool {
        return self.achievementId != 0
            && self.achievementId == other.achievementId
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
        else if type == TYPE_SHORT_AND_SWEET_ACHIEVEMENT {
            return "100 points for a post that's 3 words or less (\(hoursForReward) hours)"
        }
        else if type == TYPE_MANY_HOURS_ACHIEVEMENT {
            return "Have 2,000+ Time Crunch hours (\(hoursForReward) hours)"
        }
        else {
            return "<Achievement String>"
        }
    }
}
