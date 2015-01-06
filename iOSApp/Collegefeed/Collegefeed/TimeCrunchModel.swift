//
//  TimeCrunchModel.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/4/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

class TimeCrunchModel: NSObject {
    
    var hoursEarned: Int? = 0
    var college: College?
    var collegeId: Int?
    var timeWasActivatedAt: NSDate?
    
    init(collegeId: Int, hours: Int, activationTime: NSDate) {
        super.init()
        
        self.collegeId = collegeId
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
        println("Adding Time Crunch hours to college with ID = \(self.collegeId). Old count = \(hoursEarned!). Adding \(newHours).")
        
        hoursEarned = hoursEarned?.advancedBy(newHours)
        println("New count = \(hoursEarned).")
    }
    
    func reset() {
        hoursEarned = 0
        timeWasActivatedAt = nil
        
        println("Finished resetting Time Crunch with college = \(self.college!.name)")
    }

    func changeCollege(newCollege: College) {
        if let oldCollege = self.college {
            if newCollege.collegeID == oldCollege.collegeID {
                println("TimeCrunchModel.changeCollege to same college, do nothing")
                return
            }
        }
        
        println("TimeCrunchModel changed college to \(newCollege.name)")
        self.college = newCollege
        reset()
    }
    
}
