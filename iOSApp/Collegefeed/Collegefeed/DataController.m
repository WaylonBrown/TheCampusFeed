//
//  DataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"
#import "Votable.h"

@implementation DataController

- (NSUInteger)countOfList
{   // return the number of objects in this list
    return [self.list count];
}

#pragma mark Data Access

- (void)addObjectToList:(NSObject *)obj
{   // add object to local list
    [self.list addObject:obj];
}

- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex
{   // return the object at theIndex
    return [self.list objectAtIndex:theIndex];
}

#pragma mark - Network Access

- (id)getJsonObjectWithUrl:(NSURL *)url
{ // used to GET a JSON object from a url
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSHTTPURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&error];
    NSLog(@"%@", urlData);
    NSInteger code = [response statusCode];
    if (code != 200 || error != nil)
    {
        NSString *excReason = [NSString stringWithFormat:@"Error accessing %@", url];
        NSException *exc = [NSException exceptionWithName:@"NetworkRequestError"
                                                   reason:excReason
                                                 userInfo:nil];
        @throw exc;
    }
    
    return [NSJSONSerialization JSONObjectWithData:urlData
                                           options:0
                                             error:&error];
}
- (void)addToServer:(Votable *)obj intoList:(NSMutableArray *)array
{   // Build a POST request for this obj, send to url, if successful, add to array
    @try
    {
        // Build body
        NSData *bodyData = [obj toJSON];
        NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
        
        // Build header
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:obj.postUrl];
        [request setHTTPMethod:@"POST"];
        [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:bodyData];
        
        // Send request and get the response
        NSURLResponse *response;
        NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:nil];
        NSError *error;
        NSDictionary *jsonPost = [NSJSONSerialization JSONObjectWithData:POSTReply
                                                                 options:0 error:&error];
        
        // initialize this object from the JSON in the response
        obj = [obj initFromJSON:jsonPost];
        [array addObject:obj];
        //        Post* post = [[Post alloc] initFromJSON:jsonPost];
        //        [array addObject:post];
    }
    @catch(NSException* e)
    {
        NSLog(@"Exception in POST request");
    }
}

@end
