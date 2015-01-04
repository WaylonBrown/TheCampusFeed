//
//  TimeCrunchModel.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/4/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

class TimeCrunchModel: NSObject {
    
    var college: College
    var hoursEarned: Int = 0
    var timeWasActivatedAt: NSDate? = nil
    
    init(college: College) {
        self.college = college
        super.init()
    }
    
    func activateTime(date: NSDate) {
        timeWasActivatedAt = date
    }
    
    func getHoursRemaining() -> Int {
        if timeWasActivatedAt == nil {
            return hoursEarned
        }
        
        // interval will be difference in seconds
        var interval:Int = Int(NSDate().timeIntervalSinceDate(timeWasActivatedAt!))
        var hours = Int(max((interval / 60) / 60, 0))
        
        if hours == 0 {
            timeWasActivatedAt = nil
        }
        
        return hours
    }
    
    func earnedHours(newHours: Int) {        
        hoursEarned += newHours
    }

}
