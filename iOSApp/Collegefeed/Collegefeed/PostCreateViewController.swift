//
//  PostCreateViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/8/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

import UIKit

class PostCreateViewController: CreateViewController {

    var college: College?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "New Post"
        self.cameraButtonWidth.constant = 40;
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func assign(newCollege: College) {
        if let c = newCollege as College? {
            self.subtitleLabel.text = "Posting to \(c.name)"
            self.college = c
        }
    }
    
    override func submit(sender: AnyObject!) {
        
        if let message = self.messageTextView.text {
            if Post.withMessageIsValid(message) {
                println("Post message is valid")
                if let collegeId = self.college!.collegeID as Int?{
                    self.dataController.submitPostToNetworkWithMessage(message, withCollegeId:collegeId, withImage:self.imageView!.image)
                }
                else
                {
                    println("College ID needed but not found for Post submission")
                    Shared.queueToastWithSelector(Selector("toastPostTooShort"))
                }
            }
            else
            {
                println("Post message is invalid")
            }
        }
    }
}
