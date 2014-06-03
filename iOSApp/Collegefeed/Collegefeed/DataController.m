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

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setList:[[NSMutableArray alloc] init]];
    }
    return self;
}

#pragma mark Data Access

- (NSUInteger)countOfList
{   // return the number of objects in this list
    return [self.list count];
}
- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex
{   // return the object at theIndex
    return [self.list objectAtIndex:theIndex];
}
- (void)addObjectToList:(NSObject *)obj
{}
- (void)refresh
{}

#pragma mark - Network Access

- (id)GETfromServer:(NSURL *)url
{ // GETs a JSON-formatted response from the server, given a url
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch the response from the server in JSON format
    NSHTTPURLResponse   *response;
    NSError     *error;
    NSData      *GETReply = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[GETReply bytes]
                                                                length:[GETReply length]
                                                              encoding:NSASCIIStringEncoding];
    NSInteger   statusCode = [response statusCode];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"An error occurred attempting to retrieve information from %@.", url]
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Error in GETfromServer with: \nURL: %@\nResponse: %@\nError message: %@",
              url, stringReply, [error localizedDescription]);
        [alert show];
    }

    if (statusCode == 200)
    {
        return [NSJSONSerialization JSONObjectWithData:GETReply
                                               options:0
                                                 error:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"An error occurred attempting to retrieve information from %@.", url]
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Unexpected status code. Expected=200, actual=%d\nwith: \nURL: %@", statusCode, url);
        [alert show];
    }
    return nil;
}
- (void)POSTtoServer:(Votable *)obj intoList:(NSMutableArray *)array
{   // Build a POST request for obj (an implementation of Votable - Post or Comment)
    // If posted to server successfully, add obj to the provided array

    // Build request's body
    NSData      *bodyData = [obj toJSON];
    NSString    *bodyString = [[NSString alloc] initWithBytes:[bodyData bytes]
                                                       length:[bodyData length]
                                                     encoding:NSASCIIStringEncoding];
    NSString    *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    
    // Build request's header
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:obj.POSTurl];
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
                                                        message:[NSString stringWithFormat:@"An error occurred attempting to retrieve information from %@.", obj.POSTurl]
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Error in POSTtoServer with: \nPost body: %@\nResponse: %@\nError message: %@",
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
        obj = [obj initFromJSON:jsonPost];
        [array addObject:obj];
    }
    else // if (statusCode != 201)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"An error occurred attempting to retrieve information from %@.", obj.POSTurl]
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Unexpected status code. Expected=201, actual=%d", statusCode);
        [alert show];
    }
}
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{

}


@end
