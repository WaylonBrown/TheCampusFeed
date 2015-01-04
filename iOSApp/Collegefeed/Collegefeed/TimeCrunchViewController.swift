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
    
    var dataController : DataController!
    
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
        self.dataController = controller
        
        super.init()
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
        schoolLabel.font = Shared.getFontItalic(20)
        onOffLabel.font = Shared.getFontLight(20)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func activateTimeCrunch() {
        self.dataController.activateTimeCrunch()
    }
    
    @IBAction func showCrunchDialog() {
        let controller = CF_DialogViewController()
        controller.setAsTimeCrunchInfo()
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func updateLabels() {
        var model = dataController.getTimeCrunchModel()
        

    }
}