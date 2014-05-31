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
{   // Build a POST request for to cast this vote to the server, and add it to the array
    
    // Build request's body
    NSData      *bodyData = [vote toJSON];
    NSString    *bodyString = [[NSString alloc] initWithBytes:[bodyData bytes]
                                                       length:[bodyData length]
                                                     encoding:NSASCIIStringEncoding];
    NSString    *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    
    // Build request's header
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:vote.POSTurl];
    [request setHTTPMethod:@"POST"];
    [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    // Send request and get the response
    NSHTTPURLResponse *response;
    NSError     *error1;
    NSData      *POSTReply = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response
                                                               error:&error1];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[POSTReply bytes]
                                                        length:[POSTReply length]
                                                      encoding: NSASCIIStringEncoding];
    NSInteger   statusCode = [response statusCode];
    
    if (error1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred attempting to send a vote to the server."
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Error in VoteDataController's POSTtoServer with: \nPost body: %@\nResponse: %@\nError message: %@",
                                                        bodyString, stringReply, [error1 localizedDescription]);
        [alert show];
    }
    
    if (statusCode == 201)
    {
        NSError      *error2;
        NSDictionary *jsonPost = [NSJSONSerialization JSONObjectWithData:POSTReply
                                                                 options:0 error:&error2];
        
        if (error2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"An error occurred attempting to send information to the server."
                                                           delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
            NSLog(@"Error in POSTtoServer during NSJSONSerialization with: \nPost body: %@\nResponse: %@\njsonPost: %@\nError message: %@",
                  bodyString, stringReply, jsonPost, [error1 localizedDescription]);
            [alert show];
        }
        // initialize this object from the JSON in the response
        vote = [vote initFromJSON:jsonPost];
        [array addObject:vote];
    }
    else // if (statusCode != 201)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred attempting to retrieve information from the server."
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Unexpected status code. Expected=201, actual=%d", statusCode);
        [alert show];
    }
}


@end
