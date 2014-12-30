//
//  AchievementViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/30/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit

class AchievementViewController: MasterViewController {

    override init!(dataController controller: DataController!) {
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
