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

class TimeCrunchViewController: MasterViewController {
    
    @IBOutlet var aboutButtonLabel : UILabel!
    @IBOutlet var aboutButton: UIView!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var activateButton: UIView!
    @IBOutlet var activateButtonLabel: UILabel!
    @IBOutlet var onOffLabel: UILabel!
    
    var masterTimer: NSTimer? = nil
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "TimeCrunchViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "TimeCrunchViewController", bundle: nil)
    }
    
    override init(dataController controller: DataController){
        super.init(dataController: controller, withNibName: "TimeCrunchViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.masterTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateViewOutlets", userInfo: nil, repeats: true) //start timer that calls countDown every second 
        
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
        
        hoursLabel.font = Shared.getFontBold(34)
        daysLabel.font = Shared.getFontItalic(18)
        schoolLabel.font = Shared.getFontItalic(18)
        onOffLabel.font = Shared.getFontLight(20)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateViewOutlets()
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func activateTimeCrunch() {
        dataController!.attemptActivateTimeCrunch()
        updateViewOutlets()
    }
    
    @IBAction func showCrunchDialog() {
        let controller = CF_DialogViewController()
        controller.setAsTimeCrunchInfo()
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    override func shouldAutorotate() -> Bool {
        println("TimeCrunchViewController should not autorotate")
        return false
    }
    func updateViewOutlets() {
        
        // default values
        hoursLabel.text = "0 hrs"
        daysLabel.text = ""
        schoolLabel.text = "Start posting to get time!"
        onOffLabel.text = "Time Crunch is off."
        activateButton.hidden = true
        activateButtonLabel.hidden = true
        
        if let model = dataController!.timeCrunch {
            
            var secondsRemaining: Int = model.getSecondsRemaining() as Int
            var timeRunning = (secondsRemaining > 0 && model.timeWasActivatedAt != nil)
            
            if let mySchool = dataController!.getCollegeById(model.collegeId) {
                schoolLabel.text = mySchool.name!

                var days = (((Double(secondsRemaining) / 60) / 60) / 24) as Double
                daysLabel.text = NSString(format: "(%.1f days)", days)

                if timeRunning {
                    // Time is running right now!
                    activateButton.hidden = true
                    activateButtonLabel.hidden = true
                    onOffLabel.text = "Time is Crunching!"
                    
                    var seconds = secondsRemaining % 60 as Int
                    var minutes = (secondsRemaining / 60) % 60 as Int
                    var hours = ((secondsRemaining / 60) / 60) % 24 as Int
                    var days = (((secondsRemaining / 60) / 60) / 24) as Int
                    
                    hoursLabel.text = NSString(format: "%d:%02d:%02d:%02d", days, hours, minutes, seconds)
                    
                    daysLabel.textColor = UIColor.redColor()
                    hoursLabel.textColor = UIColor.redColor()
                }
                else {
                    activateButton.hidden = false
                    activateButtonLabel.hidden = false
                    
                    var hours = ((secondsRemaining / 60) / 60) as Int
                    hoursLabel.text = NSString(format: "%d hrs", hours)
                }
            }
        }
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
        
    }
}