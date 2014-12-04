//
//  Watchdog.h
//  Watchdog
//
//  Created by Patrick Sheehan on 12/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Watchdog : NSObject


// Python functions in content-watchdog.py
- (id)initWithOptions:(NSDictionary*) options;
- (BOOL)shouldSubmitMessage:(NSString*) message;

- (BOOL)isValidLength:(NSString*) message;
- (BOOL)hasValidCharacters:(NSString*) message;
- (BOOL)shouldBlockForNumber:(NSString*) message;
- (BOOL)shouldBlockForEmail:(NSString*) message;
- (BOOL)shouldBlockForVulgar:(NSString*) message;
- (BOOL)shouldBlockForSexual:(NSString*) message;


// Testing examples from sample code
// http://www.redstoyland.com/projects/code/pythonandobjectivec.html
// http://www.friday.com/bbum/2007/11/25/can-ruby-python-an-objective-c-co-exist-in-a-single-application/#comment-186002
//@property (strong, nonatomic) NSObject* myContentWatchdog;
//@property (strong, nonatomic) id stuff;
//- (NSArray *) arrayOfNamedStrings;
//- (void) pyTestMethod;

@end
