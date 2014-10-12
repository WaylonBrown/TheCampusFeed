//
//  TimeCrunchViewController.swift
// TheCampusFeed
//
//  Created by Patrick Sheehan on 10/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TimeCrunchViewController: UIViewController {
    
    @IBOutlet var onOffLabel: UILabel!
    @IBOutlet var comingSoonLabel: UILabel!
    @IBOutlet var buttonLabel : UILabel!
    @IBOutlet var buttonView: UIView!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "TimeCrunchViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonView.layer.shadowColor = UIColor.blackColor().CGColor
        self.buttonView.layer.shadowOpacity = 0.8
        self.buttonView.layer.shadowRadius = 2.0
        self.buttonView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        self.buttonLabel.font = Shared.getFontLight(22)
        self.comingSoonLabel.font = Shared.getFontLight(20)
        self.onOffLabel.font = Shared.getFontLight(20)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func showCrunchDialog() {
        let controller = CF_DialogViewController()
        controller.setAsTimeCrunchInfo()
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
}