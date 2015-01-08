//
//  CommentCreateViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/8/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

import UIKit

class CommentCreateViewController: CreateViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = "New Comment"
        self.subtitleLabel.text = ""
        self.cameraButtonWidth.constant = 0;
        
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
            if Comment.withMessageIsValid(message) {
                println("Comment message is valid")
                
                if let postId = self.post!.postId as Int?{
                    println("Comment's postID is valid")
                    self.dataController.submitCommentToNetworkWithMessage(message, withPostId:postId)
                    self.dismiss(self)
                }
                else
                {
                    println("Post ID needed but not found for Comment submission")
                    Shared.queueToastWithSelector(Selector("toastCommentFailed"))
                }
            }
            else
            {
                println("Comment message is invalid")
                Shared.queueToastWithSelector(Selector("toastCommentInvalid"))
            }
        }
    }

}
