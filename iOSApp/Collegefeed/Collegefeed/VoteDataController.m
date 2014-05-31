//
//  VoteDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "VoteDataController.h"
#import "Votable.h"
#import "Vote.h"

@implementation VoteDataController

- (void)POSTtoServer:(Vote *)vote intoList:(NSMutableArray *)array
{   // Build a POST request for this vote, send to url, if successful, add to array

    @try
    {
        // Build body
        NSData *bodyData = [vote toJSON];
        NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
        
        // Build header
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:vote.POSTurl];
        [request setHTTPMethod:@"POST"];
        [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:bodyData];
        
        // Send request and get the response
        NSURLResponse *response;
       [NSURLConnection sendSynchronousRequest:request
                             returningResponse:&response
                                         error:nil];
        
        //NOTE: no response is sent back yet with a successful POST
    }
    @catch(NSException* e)
    {
        NSLog(@"Exception in POST request");
    }
}

@end
