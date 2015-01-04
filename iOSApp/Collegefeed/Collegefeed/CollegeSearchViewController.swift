//
//  CollegeSearchViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/24/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class CollegeSearchViewController: CollegeViewController, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var searchController = UISearchDisplayController()
    let feedDelegate : FeedSelectionProtocol?
    
    init!(dataController controller: DataController!, feedDelegate fDelegate: FeedSelectionProtocol) {
        feedDelegate = fDelegate
        super.init(dataController: controller)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
    
    
    override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.feedDelegate?.switchToFeedForCollegeOrNil(self.list.objectAtIndex(indexPath.row) as College)
    }
    
    
    // MARK: - Network Actions
    
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
    
    // MARK: - Helper Methods
    
    override func setCorrectList() {
        list = dataController.collegeList
    }
}
