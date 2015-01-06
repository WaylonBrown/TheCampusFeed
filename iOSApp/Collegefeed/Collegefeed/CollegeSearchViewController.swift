//
//  CollegeSearchViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/24/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class CollegeSearchViewController: CollegeViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    let cellId = "SimpleTableCell"

    let feedDelegate: FeedSelectionProtocol?
    var filteredList: NSMutableArray?
    var searchController: UISearchController?
    var searchResultsController: UITableViewController?

    
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
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let resultsTableView = UITableView(frame: self.tableView.frame)
        
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        self.searchResultsController?.tableView.backgroundColor = Shared.getCustomUIColor(CF_EXTRALIGHTGRAY)
        self.searchResultsController?.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.returnKeyType = UIReturnKeyType.Done;
        self.searchController?.searchBar.sizeToFit() // bar size
        self.tableView.tableHeaderView = self.searchController?.searchBar
        
        self.definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("CollegeSearchViewController number of rows in section = ")
        if (tableView == self.searchResultsController?.tableView) {
            if let filtered = self.filteredList {
                println("\(filtered.count) colleges")
                return filtered.count
            } else {
                println("NO colleges")
                return 0
            }
        } else {
            println("\(list.count) colleges")
            return list.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellId) as? SimpleTableCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed(self.cellId, owner: self, options: nil)[0] as? SimpleTableCell
        }
        
        var college: College?
        if (tableView == self.searchResultsController?.tableView) {
            if let filtered = self.filteredList {
                college = filtered.objectAtIndex(indexPath.row) as? College
            }
        } else {
            college = self.list.objectAtIndex(indexPath.row) as? College
        }
        
        cell?.assignCollege(college, withRankNumberOrNil:nil)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var college: College?
        if (tableView == self.searchResultsController?.tableView) {
            if let filtered = self.filteredList {
                college = filtered.objectAtIndex(indexPath.row) as? College
            }
        } else {
            college = self.list.objectAtIndex(indexPath.row) as? College
        }
        
        self.feedDelegate?.switchToFeedForCollegeOrNil(college)
    }
    
    // MARK: - Search Bar
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if self.searchController?.searchBar.text.lengthOfBytesUsingEncoding(NSUTF32StringEncoding) > 0 {
            if let filtered = self.filteredList {
                filtered.removeAllObjects()
            } else {
                self.filteredList = NSMutableArray(capacity: self.list.count)
            }
            
            let text = self.searchController!.searchBar.text
            
            var subPredicates = NSMutableArray()
            
            var words = split(searchController.searchBar.text) {$0 == " "}
            for word in words {
                NSLog("Searching with word: %@", word)
                var predicate = NSPredicate(format: "SELF.name contains[c] %@", word)
                subPredicates.addObject(predicate!)
            }
            
            let searchPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(subPredicates)
            let array = (self.list as NSArray).filteredArrayUsingPredicate(searchPredicate)
            self.filteredList?.addObjectsFromArray(array)
            
            self.searchResultsController?.tableView.reloadData()
            self.contentLoadingIndicator.stopAnimating()
        }
    }
    
    // MARK:- UISearchControllerDelegate methods
    
    func didDismissSearchController(searchController: UISearchController) {
        UIView.animateKeyframesWithDuration(0.5,
            delay: 0,
            options: UIViewKeyframeAnimationOptions.BeginFromCurrentState,
            animations: { },
            completion: nil)
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
