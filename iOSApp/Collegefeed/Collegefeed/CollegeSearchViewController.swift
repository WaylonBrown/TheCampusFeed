//
//  CollegeSearchViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/24/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class CollegeSearchViewController: CollegeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        self.list = self.dataController.collegeList
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func fetchContent() {
        super.fetchContent()
        
        NSLog("Fetching All colleges for search");
        self.dataController.fetchAllColleges()
    }
    
    override func finishedFetchRequest(notification: NSNotification!) {
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let feedName = info["feedName"] {
                if feedName == "allColleges"{
                    NSLog("Finished fetching all colleges")
                }
            }
        }
        super.finishedFetchRequest(notification)
    }
}
