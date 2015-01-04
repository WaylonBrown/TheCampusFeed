//
//  TimeCrunchModel.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/4/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

class TimeCrunchModel: NSObject {
    
    let college: College
    let hoursEarned: Int = 0
    let timeWasActivatedAt: NSDate?
    
    init(college: College) {
        self.college = college
        super.init()
    }
    
    func activateTime(date: NSDate) {
        let timeWasActivatedAt = date
    }
    
    func getHoursRemaining() -> Int {
        if timeWasActivatedAt == nil {
            return hoursEarned
        }
        
        // interval will be difference in seconds
        let now = NSDate()
        var interval:Int = Int(now.timeIntervalSinceDate(timeWasActivatedAt!))
        var hours = Int(max((interval / 60) / 60, 0))
        
        if hours == 0 {
            let timeWasActivatedAt = nil
        }
        
        return hours
    }
    
    func earnedHours(newHours: Int) {
        var oldHours = hoursEarned
        let hoursEarned = oldHours + newHours
    }

}
