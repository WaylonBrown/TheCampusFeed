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

static int locationDistanceFilter = 150000; // 15km

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setList:[[NSMutableArray alloc] init]];
        
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDistanceFilter:locationDistanceFilter];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startUpdatingLocation];
        
        [self setLat:self.locationManager.location.coordinate.latitude];
        [self setLon:self.locationManager.location.coordinate.longitude];
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
    NSData      *urlData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[urlData bytes]
                                                                length:[urlData length]
                                                              encoding:NSASCIIStringEncoding];
    NSInteger   statusCode = [response statusCode];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred attempting to retrieve information from the server."
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Error in GETfromServer with: \nURL: %@\nError message: %@\nresponse: %@",
              url, [error localizedDescription], stringReply);
        [alert show];
    }

    if (statusCode == 200)
    {
        return [NSJSONSerialization JSONObjectWithData:urlData
                                               options:0
                                                 error:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred attempting to retrieve information from the server."
                                                       delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
        NSLog(@"Unexpected status code. Expected=200, actual=%d", statusCode);
        [alert show];
    }
    return nil;
}
- (void)POSTtoServer:(Votable *)obj intoList:(NSMutableArray *)array
{   // Build a POST request for this obj, send to url, if successful, add to array
    @try
    {
        // Build body
        NSData *bodyData = [obj toJSON];
        NSString *bodyString = [[NSString alloc] initWithBytes:[bodyData bytes]
                                                        length:[bodyData length]
                                                      encoding:NSASCIIStringEncoding];
        NSLog(@"bodyString: %@", bodyString);
        
        NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
        
        // Build header
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:obj.POSTurl];
        [request setHTTPMethod:@"POST"];
        [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:bodyData];
        
        // Send request and get the response
        NSHTTPURLResponse *response;
        NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:nil];
        
        NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes]
                                                      length:[POSTReply length]
                                                    encoding: NSASCIIStringEncoding];
        NSLog(@"Reply: %@", theReply);
        
        NSError *error;
        NSDictionary *jsonPost = [NSJSONSerialization JSONObjectWithData:POSTReply
                                                                 options:0 error:&error];
        
        // initialize this object from the JSON in the response
        obj = [obj initFromJSON:jsonPost];
        [array addObject:obj];
    }
    @catch(NSException* e)
    {
        NSLog(@"Exception in POST request");
    }
}
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{

}


@end
