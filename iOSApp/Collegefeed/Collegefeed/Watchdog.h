//
//  Watchdog.h
//  Watchdog
//
//  Created by Patrick Sheehan on 12/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Watchdog : NSObject

- (id)initWithOptions:(NSDictionary*) options;
- (BOOL)shouldSubmitMessage:(NSString*)message
                WithResults:(NSMutableDictionary *)results;

- (BOOL)isValidLength:(NSString*) message;
- (BOOL)hasValidCharacters:(NSString*) message;
- (BOOL)shouldBlockForNumber:(NSString*) message;
- (BOOL)shouldBlockForEmail:(NSString*) message;
- (BOOL)shouldBlockForVulgar:(NSString*) message;
- (BOOL)shouldBlockForSexual:(NSString*) message;

@end
