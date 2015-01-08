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
@property (nonatomic) BOOL blockPhone;
@property (nonatomic) BOOL blockEmail;
@property (nonatomic) BOOL blockVulgar;
@property (nonatomic) BOOL blockSexual;

@end

@implementation Watchdog

- (id)initWithOptions:(NSDictionary *)options
{
    self = [super init];
    if (self)
    {
        NSNumber *minLength = [options objectForKey:@"minLength"];
        NSNumber *maxLength = [options objectForKey:@"maxLength"];
        NSNumber *blockPhone = [options objectForKey:@"blockPhone"];
        NSNumber *blockEmail = [options objectForKey:@"blockEmail"];
        NSNumber *blockVulgar = [options objectForKey:@"blockVulgar"];
        NSNumber *blockSexual = [options objectForKey:@"blockSexual"];
        
        self.minLength = (minLength == nil) ? 10 : [minLength intValue];
        self.maxLength = (maxLength == nil) ? 140 : [maxLength intValue];
        self.blockPhone = (blockPhone == nil) ? NO : [blockPhone boolValue];
        self.blockEmail = (blockEmail == nil) ? NO : [blockEmail boolValue];
        self.blockVulgar = (blockVulgar == nil) ? NO : [blockVulgar boolValue];
        self.blockSexual = (blockSexual == nil) ? NO : [blockSexual boolValue];
    }
    
    return self;
}
- (BOOL)shouldSubmitMessage:(NSString*)message
                WithResults:(NSMutableDictionary *)results
{
    BOOL isValidLength = [self isValidLength:message];
    [results setValue:[NSNumber numberWithBool:isValidLength]
               forKey:@"isValidLength"];
    
    BOOL hasValidCharacters = [self hasValidCharacters:message];
    [results setValue:[NSNumber numberWithBool:hasValidCharacters]
               forKey:@"hasValidCharacters"];
    
    BOOL shouldBlockForNumber = [self shouldBlockForNumber:message];
    [results setValue:[NSNumber numberWithBool:shouldBlockForNumber]
               forKey:@"shouldBlockForNumber"];
    
    BOOL shouldBlockForEmail = [self shouldBlockForEmail:message];
    [results setValue:[NSNumber numberWithBool:shouldBlockForEmail]
               forKey:@"shouldBlockForEmail"];
    
    BOOL shouldBlockForVulgar = [self shouldBlockForVulgar:message];
    [results setValue:[NSNumber numberWithBool:shouldBlockForVulgar]
               forKey:@"shouldBlockForVulgar"];
    
    BOOL shouldBlockForSexual = [self shouldBlockForSexual:message];
    [results setValue:[NSNumber numberWithBool:shouldBlockForSexual]
               forKey:@"shouldBlockForSexual"];
    
    return isValidLength && hasValidCharacters
    && !shouldBlockForNumber && !shouldBlockForEmail
    && !shouldBlockForSexual && !shouldBlockForVulgar;
}

- (BOOL)isValidLength:(NSString*) message
{
    NSUInteger length = message.length;
    
    if (length < self.minLength || length > self.maxLength)
    {
        NSLog(@"LENGTH REJECTION: %@", message);
        return NO;
    }
    
    return YES;
}
- (BOOL)hasValidCharacters:(NSString*) message
{
    
    return YES;
}
- (BOOL)shouldBlockForNumber:(NSString*) message
{
    if (!self.blockPhone)
    {
        return NO;
    }
    
    NSUInteger len = [message length];
    unichar buffer[len+1];
    
    [message getCharacters:buffer range:NSMakeRange(0, len)];
    
    int numCount = 0;
    for(int i = 0; i < len; i++) {
        if (isdigit(buffer[i]))
            numCount++;
    }
    
    if (numCount == 10)
    {
        NSLog(@"PHONE NUMBER REJECTION: %@", message);
        return YES;
        
    }
    
    return NO;
}
- (BOOL)shouldBlockForEmail:(NSString*) message
{
    if (!self.blockEmail)
    {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    for (NSString *word in [message componentsSeparatedByString:@" "])
    {
        if ([emailTest evaluateWithObject:word])
        {
            NSLog(@"EMAIL REJECTION: %@", message);
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)shouldBlockForVulgar:(NSString*) message
{
    if (!self.blockVulgar)
    {
        return NO;
    }
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"bad_words"
                                                     ofType:@"txt"];
    NSArray *badWords = [[NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL]
                         componentsSeparatedByString:@"\n"];
    
    for (NSString *word in [message componentsSeparatedByString:@" "])
    {
        if ([badWords containsObject:[word lowercaseString]])
        {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)shouldBlockForSexual:(NSString*) message
{
    if (!self.blockSexual)
    {
        return NO;
    }
    
    return NO;
}
@end
