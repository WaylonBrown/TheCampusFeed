//
//  NSMutableArrayExtensions.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 11/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import Foundation

extension NSMutableArray
{
    func insertObjectsWithUniqueIds(newObjectsArray: NSArray) -> Int {
        var numAdded = 0;
        for newObj in newObjectsArray {
            if newObj.respondsToSelector("getID"){
                var existingID = newObj.getID() as NSNumber
                var alreadyExists = false
                
                for existingObj in self {
                    if existingObj.respondsToSelector("getID") {
                        var newID = existingObj.getID() as NSNumber
                        
                        if newID.isEqualToNumber(existingID) {
                            alreadyExists = true
                        }
                    }
                }
                
                if (!alreadyExists) {
                    self.addObject(newObj)
                    numAdded++;
                }
            }
        }
        
        return numAdded
    }
}