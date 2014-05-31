//
//  VoteDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"

@class Vote;

@interface VoteDataController : DataController

- (void)POSTtoServer:(Vote *)vote
           intoList:(NSMutableArray *)array;


@end
