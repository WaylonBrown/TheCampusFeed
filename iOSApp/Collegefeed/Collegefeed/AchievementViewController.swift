//
//  AchievementViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/30/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class AchievementViewController: MasterViewController, UITableViewDataSource, UITableViewDelegate {

    override init!(dataController controller: DataController!) {
        super.init(dataController: controller)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = nil
        
        feedToolbar.removeFromSuperview()
    }
    override func viewWillAppear(animated: Bool) {
    }
    override func viewDidAppear(animated: Bool) {
        self.dataController.didViewAchievements()
        tableView.reloadData()
    }
    
    // MARK: Network Actions
    
    override func fetchContent() {
        self.refreshControl!.endRefreshing()
        self.hasFinishedFetchRequest = true;
        self.contentLoadingIndicator.stopAnimating()
    }
    
    override func finishedFetchRequest(notification: NSNotification!) {
        self.refreshControl!.endRefreshing()
        self.contentLoadingIndicator.stopAnimating()
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId: NSString = "SimpleTableCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SimpleTableCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed(cellId, owner: self, options: nil)[0] as? SimpleTableCell
        }
        
        cell?.assignAchievement(self.list[indexPath.row] as Achievement)
        
        return cell!
    }
    
    // MARK: Helper Methods
    
    override func setCorrectList() {
        self.list = self.dataController.achievementList
    }

}
