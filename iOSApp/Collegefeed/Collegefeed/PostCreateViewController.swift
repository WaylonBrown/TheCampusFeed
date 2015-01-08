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

//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
            self.subtitleLabel!.text = "NOTHING!!"
// TODO CRASH HERE
//        if var school = self.college?.name {
//            self.subtitleLabel!.text = "Posting to \(school)"
//
//        }
        
//        if let school = self.college as College? {
//            if let name = school.name {
//                self.subtitleLabel!.text = "Posting to \(name)"
//            }
//        }

//        if let name = self.college!.name as String? {
//            self.subtitleLabel.text = "Posting to \(name)"
//        }
        
        self.titleLabel!.text = "New Post"
        self.cameraButtonWidth!.constant = 40;
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func assign(newCollege: College) {
        if let c = newCollege as College? {
            self.college = c
        }
    }
    
    override func submit(sender: AnyObject!) {
        if let message = self.messageTextView.text {
            if Post.withMessageIsValid(message) {
                println("Post message is valid")
                if let collegeId = self.college!.collegeID as Int?{
                    println("Post's collegeID is valid")
                    self.dataController.submitPostToNetworkWithMessage(message, withCollegeId:collegeId, withImage:self.imageView!.image)
                }
                else
                {
                    println("College ID needed but not found for Post submission")
                    Shared.queueToastWithSelector(Selector("toastPostFailed"))
                }
                
                self.dismiss(self)
            }
            else
            {
                println("Post message is invalid")
                Shared.queueToastWithSelector(Selector("toastPostInvalid"))

            }
        }
    }
}
