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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Network Actions
    
    override func fetchContent() {
        super.fetchContent()
        
        self.dataController.fetchAchievements()
    }
    
    override func finishedFetchRequest(notification: NSNotification!) {
        
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let feed = info["feedName"] {
                if feed == "achievements" {
                    NSLog("Finished fetching achievements")
                    super.finishedFetchRequest(notification)
                }
            }
        }
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.setCorrectList()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
