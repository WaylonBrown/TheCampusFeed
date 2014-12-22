//
//  SearchableCollegesViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "SearchableCollegesViewController.h"


@implementation SearchableCollegesViewController

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setList:self.dataController.collegeList];
    }
    return self;
}

@end
