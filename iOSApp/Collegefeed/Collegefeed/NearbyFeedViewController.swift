//
//  NearbyFeedViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/3/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

import UIKit

class NearbyFeedViewController: FeedSelectViewController, UITableViewDataSource, UITableViewDelegate {

    let postingDelegate: PostingSelectionProtocol
    
    init!(dataController controller: DataController!, postingDelegate pDelegate: PostingSelectionProtocol) {
        self.postingDelegate = pDelegate

        super.init(dataController: controller)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataController.nearbyColleges.count
        // Return the number of colleges nearby
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var college = self.dataController.nearbyColleges.objectAtIndex(indexPath.row) as College
        self.postingDelegate.submitSelectionForPostWithCollege(college)
        // Submit selection for college to post to
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "SimpleTableCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SimpleTableCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed(cellId, owner: self, options: nil)[0] as? SimpleTableCell
        }
        
        var college = self.dataController.nearbyColleges.objectAtIndex(indexPath.row) as College

        cell?.assignSimpleText(college.name)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

}
