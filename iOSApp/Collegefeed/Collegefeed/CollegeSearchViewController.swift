//
//  CollegeSearchViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/24/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class CollegeSearchViewController: CollegeViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    let feedDelegate: FeedSelectionProtocol?
    
    var searchController: UISearchController?
    var searchBar: UISearchBar?
    
    let filteredList = NSMutableArray()
    
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
    
    override func loadView() {
        super.loadView()
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        navigationItem.backBarButtonItem?.title = ""
    }
    override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Seach Bar
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredList.removeAllObjects()
        var text = searchController.searchBar.text

        var subPredicates = NSMutableArray()
        
        var words = split(searchController.searchBar.text) {$0 == " "}
        for word in words {
            NSLog("Searching with word: %@", word)
            var predicate = NSPredicate(format: "SELF.name contains[c] %@", word)
            subPredicates.addObject(predicate!)
        }
        
        let searchPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(subPredicates)

        let array = (self.dataController.collegeList as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredList.addObjectsFromArray(array)

        self.list = filteredList
        self.tableView.reloadData()
        self.contentLoadingIndicator.stopAnimating()
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
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
