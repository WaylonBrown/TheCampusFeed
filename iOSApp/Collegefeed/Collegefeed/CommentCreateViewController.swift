//
//  CommentCreateViewController.swift
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/8/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

import UIKit

class CommentCreateViewController: CreateViewController {

    var post: Post?
    
    override func viewWillAppear(animated: Bool) {
        self.titleLabel!.text = "New Comment"
        self.subtitleLabel!.text = ""
        self.cameraButtonWidth.constant = 0;
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func assign(newPost: Post) {
        if let p = newPost as Post? {
            self.post = p
        }
    }
    
    override func submit(sender: AnyObject!) {
        
        if let message = self.messageTextView.text {
            if Comment.withMessageIsValid(message) {
                println("Comment message is valid")
                
                if let postId = self.post!.post_id as Int?{
                    println("Comment's postID is valid")
                    self.dataController.submitCommentToNetworkWithMessage(message, withPostId:postId)
                    self.dismiss(self)
                }
                else
                {
                    println("Post ID needed but not found for Comment submission")
                    Shared.queueToastWithSelector(Selector("toastCommentFailed"))
                }
                
                self.dismiss(self)
            }
            else
            {
                println("Comment message is invalid")
                Shared.queueToastWithSelector(Selector("toastCommentInvalid"))
            }
        }
    }

}
