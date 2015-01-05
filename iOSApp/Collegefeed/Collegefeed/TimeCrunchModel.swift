//
//  TimeCrunchModel.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/4/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

class TimeCrunchModel: NSObject {
    
    var college: College?
    var hoursEarned: Int? = 0
    var timeWasActivatedAt: NSDate?
    
    init(college: College, hours: Int, activationTime: NSDate) {
        super.init()

        self.college = college
        self.hoursEarned = hours
        self.timeWasActivatedAt = activationTime.copy() as? NSDate
    }
    
    func activateAtTime(date: NSDate) {
        
        self.timeWasActivatedAt = date.copy() as? NSDate
    }
    
    func getHoursEarned() -> Int {
        return Int(hoursEarned!)
    }
    
    func getHoursRemaining() -> Int {
        if let oldTime = self.timeWasActivatedAt {
            
            var now: NSDate = NSDate()
            var interval = Int(now.timeIntervalSinceDate(oldTime))
            var hoursUsed = Int((interval / 60) / 60)
            var hoursRemain = hoursEarned! - hoursUsed
            
            if hoursRemain == 0 {
                reset()
            }
            
            return hoursRemain
        }

        return hoursEarned!
    }
    
    func addHours(newHours: Int) {
        hoursEarned = hoursEarned?.advancedBy(newHours)
    }
    
    func reset() {
        hoursEarned = 0
        timeWasActivatedAt = nil
    }

    func reset(forNewCollege newCollege: College) {
        reset()
        college = newCollege
    }
}
