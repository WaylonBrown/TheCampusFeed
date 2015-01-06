//
//  TimeCrunchViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 10/6/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TimeCrunchViewController: UIViewController {
    
    var myDataController: DataController?
    
    @IBOutlet var aboutButtonLabel : UILabel!
    @IBOutlet var aboutButton: UIView!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var activateButton: UIView!
    @IBOutlet var activateButtonLabel: UILabel!
    @IBOutlet var onOffLabel: UILabel!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "TimeCrunchViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "TimeCrunchViewController", bundle: nil)
    }
    
    init(dataController controller: DataController){
        super.init()
        
        myDataController = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutButton.layer.shadowColor = UIColor.blackColor().CGColor
        aboutButton.layer.shadowOpacity = 0.8
        aboutButton.layer.shadowRadius = 2.0
        aboutButton.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        aboutButtonLabel.font = Shared.getFontLight(22)

        activateButton.layer.shadowColor = UIColor.blackColor().CGColor
        activateButton.layer.shadowOpacity = 0.8
        activateButton.layer.shadowRadius = 2.0
        activateButton.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        activateButtonLabel.font = Shared.getFontLight(22)
        
        hoursLabel.font = Shared.getFontItalic(40)
        daysLabel.font = Shared.getFontItalic(18)
        schoolLabel.font = Shared.getFontItalic(18)
        onOffLabel.font = Shared.getFontLight(20)
        
        if (self.myDataController!.isNearCollege())
        {
            self.placeCreatePostButton()
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.updateLabels()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func placeCreatePostButton() {
        var createButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createPost")
        self.navigationItem.setRightBarButtonItem(createButton, animated: false)
    }
    
    func createPost() {
        // TODO
        println("Need to tell someone to show the post dialog")
    }
    
    // MARK: - Actions
    
    @IBAction func activateTimeCrunch() {
        myDataController!.attemptActivateTimeCrunch()
        
        updateLabels()
    }
    
    @IBAction func showCrunchDialog() {
        let controller = CF_DialogViewController()
        controller.setAsTimeCrunchInfo()
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func updateLabels() {
        if let model = myDataController!.timeCrunch {
            
            var hours: Int = model.getHoursRemaining() as Int
            var days: Double = Double(hours) / 24.0 as Double
            
            hoursLabel.text = NSString(format: "%d hrs", hours)
            daysLabel.text = NSString(format: "(%.1f days)", days)
            schoolLabel.text = model.college!.name
            onOffLabel.text = (model.timeWasActivatedAt != nil) ? "Time Crunch is on." : "Time Crunch is off."
        }
        else {

            hoursLabel.text = "0 hrs"
            daysLabel.text = "Start posting to get time!"
            schoolLabel.text = ""
            onOffLabel.text = "Time Crunch is off."
        }
    }
}