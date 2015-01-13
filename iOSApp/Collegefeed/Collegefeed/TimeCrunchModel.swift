//
//  TimeCrunchModel.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/4/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

class TimeCrunchModel: NSObject {
    
    var hoursEarned: Int = 0
    var collegeId: Int = 0
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
        return hoursEarned
    }
    
    func getSecondsRemaining() -> Int {
        var secondsUsed = 0
        if let oldTime = self.timeWasActivatedAt {
            var now: NSDate = NSDate()
            secondsUsed = Int(now.timeIntervalSinceDate(oldTime))
        }
        return (hoursEarned * 60 * 60) - secondsUsed
    }
    
    func getHoursRemaining() -> Int {
        if let oldTime = self.timeWasActivatedAt {
            
            var now: NSDate = NSDate()
            var interval = Int(now.timeIntervalSinceDate(oldTime))
            var hoursUsed = Int((interval / 60) / 60)
            var hoursRemain = max(0, hoursEarned - hoursUsed)
            
            if hoursRemain == 0 {
                reset()
            }
            
            return hoursRemain
        }

        println("GetHoursRemaining found a nil activation time. Returning hoursEarned = \(hoursEarned)")
        return hoursEarned
    }
    
    func addHours(newHours: Int) {
        println("Adding Time Crunch hours to college with ID = \(self.collegeId). Old count = \(hoursEarned). Adding \(newHours).")
        
        hoursEarned += newHours
        println("New count = \(hoursEarned).")
    }
    
    func reset() {
        hoursEarned = 0
        timeWasActivatedAt = nil
        
        println("Finished resetting Time Crunch with college ID = \(self.collegeId)")
    }

    func changeCollegeId(newCollegeId: Int) {
        
        if newCollegeId == self.collegeId {
            println("TimeCrunchModel.changeCollegeId to same college, do nothing")
            return
        }
        else {
            self.collegeId = newCollegeId
            println("TimeCrunchModel changed college ID to \(newCollegeId)")
            reset()
        }
    }
    
}
