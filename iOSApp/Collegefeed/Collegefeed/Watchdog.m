//
//  Watchdog.m
//  Watchdog
//
//  Created by Patrick Sheehan on 12/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Watchdog.h"

@interface Watchdog()

@property (nonatomic) int minLength;
@property (nonatomic) int maxLength;
@property (nonatomic) BOOL blockPhoneNumbers;
@property (nonatomic) BOOL blockEmailAddresses;

@end

@implementation Watchdog

//- (id)init
//{
//    // Below for trying to initialize the actual python class
//    self = [super init];
//    Class ContentWatchDogClass = NSClassFromString(@"ContentWatchdog");
//    self.myContentWatchdog = [ContentWatchDogClass new];
//    
//    return self;
//}

- (id)initWithOptions:(NSDictionary *)options
{
    self = [super init];
    if (self)
    {
        NSNumber *minLength = [options objectForKey:@"minLength"];
        NSNumber *maxLength = [options objectForKey:@"maxLength"];
        NSNumber *blockPhoneNumbers = [options objectForKey:@"blockPhoneNumbers"];
        NSNumber *blockEmailAddresses = [options objectForKey:@"blockEmailAddresses"];
        
        self.minLength = (minLength == nil) ? 10 : [minLength intValue];
        self.maxLength = (maxLength == nil) ? 140 : [maxLength intValue];
        self.blockPhoneNumbers = (blockPhoneNumbers == nil) ? NO : [blockPhoneNumbers boolValue];
        self.blockEmailAddresses = (blockEmailAddresses == nil) ? NO : [blockEmailAddresses boolValue];
    }
    
    return self;
}

//- (NSArray *) arrayOfNamedStrings;
//{
//    if (!_stuff) {
//        Class PythonStuffClass = NSClassFromString(@"PythonStuff");
//        _stuff = [PythonStuffClass new];
//    }
//    return [_stuff arrayOfNamedStrings];
//}
@end
