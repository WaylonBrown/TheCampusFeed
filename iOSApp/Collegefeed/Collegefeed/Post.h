//
//  Post.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

// tutorial properties were: name, location, date
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, strong) NSDate *date;
//TODO: array of comments for this post


-(id)initWithContent:(NSString *)content;

@end
