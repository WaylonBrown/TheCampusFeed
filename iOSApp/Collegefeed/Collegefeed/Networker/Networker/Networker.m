//
//  Networker.m
//  Networker
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import "Networker.h"

@implementation Networker

#pragma mark - Abstract GET and POST

+ (NSData *)GET:(NSURL *)url
{   // Gets the data from the provided URL
    NSLog(@"URL: %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    
    // Fetch the response from the server in JSON format
    NSHTTPURLResponse   *response;
    NSError     *error;
    NSData      *GETReply = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[GETReply bytes]
                                                        length:[GETReply length]
                                                      encoding:NSASCIIStringEncoding];
    if ([response statusCode] == 200)
    {
        return GETReply;
    }
    
    [NSException raise:@"Error in networker.GET"
                format:@"URL: %@\nResponse: %@\nError message: %@\n",
     url, stringReply, [error localizedDescription]];
    
    return nil;
}
+ (NSData *)POST:(NSData *)data toUrl:(NSURL *)url
{
    NSLog(@"URL: %@", url);
    
    // Build request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    // Send request and get the response
    NSHTTPURLResponse *response;
    NSError     *error;
    NSData      *POSTReply = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response
                                                               error:&error];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[POSTReply bytes]
                                                        length:[POSTReply length]
                                                      encoding: NSASCIIStringEncoding];
    
    if ([response statusCode] == 201)
    {
        return POSTReply;
    }
    
    [NSException raise:@"Error in networker.POST"
                format:@"URL: %@\nResponse: %@\nError message: %@\n",
     url, stringReply, [error localizedDescription]];
    return nil;
}

#pragma mark - Specific API Requests

#pragma mark - Colleges

+ (NSData *)GETAllColleges
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges",
                   API_URL, API_VERSION]];
    
    return [self GET:url];
}

#pragma mark - Comments

+ (NSData *)POSTCommentData:(NSData *)data WithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/comments",
                   API_URL, API_VERSION, postId]];
    
    return [self POST:data toUrl:url];
}

+ (NSData *)GETCommentsWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/comments",
                   API_URL, API_VERSION, postId]];
    return [self GET:url];
}

#pragma mark - Posts

+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts",
                   API_URL, API_VERSION, collegeId]];
    return [self POST:data toUrl:url];
}

+ (NSData *)GETPostsWithTagName:(NSString*)tagName
{
    NSString* tagWithoutHash = [tagName stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/byTag/%@",
                   API_URL, API_VERSION, tagWithoutHash]];
    return [self GET:url];
}
+ (NSData *)GETPostsWithTagName:(NSString*)tagName
                  withCollegeId:(long)collegeId
{
    NSString* tagWithoutHash = [tagName stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/byTag/%@",
                   API_URL, API_VERSION, collegeId, tagWithoutHash]];
    return [self GET:url];
}

+ (NSData *)GETAllPostsWithTag:(NSString*)tagName
                withPageNumber:(long)page
             withNumberPerPage:(long)perPage
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/byTag/%@?page=%ld&per_page=%ld",
                   API_URL, API_VERSION, tagName, page, perPage]];
    return [self GET:url];
}
+ (NSData *)GETAllPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts",
                   API_URL, API_VERSION]];
    return [self GET:url];
}
+ (NSData *)GETPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts",
                   API_URL, API_VERSION, collegeId]];
    return [self GET:url];
}

+ (NSData *)GETRecentPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/recent",
                   API_URL, API_VERSION]];
    return [self GET:url];
}
+ (NSData *)GETRecentPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/recent",
                   API_URL, API_VERSION, collegeId]];
    return [self GET:url];
}

+ (NSData *)GETTrendingPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/trending",
                   API_URL, API_VERSION]];
    return [self GET:url];
}
+ (NSData *)GETTrendingPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/trending",
                   API_URL, API_VERSION, collegeId]];
    return [self GET:url];
}

#pragma mark - Tags

+ (NSData *)GETTagsTrending
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/tags/trending",
                   API_URL, API_VERSION]];
    return [self GET:url];
}

#pragma mark - Votes

+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/votes",
                   API_URL, API_VERSION, postId]];
    return [self POST:data toUrl:url];
}
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/comment/%ld/votes",
                   API_URL, API_VERSION, commentId]];
    return [self POST:data toUrl:url];
}
+ (NSData *)GETVoteScoreWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/votes/score",
                   API_URL, API_VERSION, postId]];
    return [self GET:url];
}
+ (NSData *)GETVoteScoreWithCommentId:(long)commentId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/comments/%ld/votes/score",
                   API_URL, API_VERSION, commentId]];
    return [self GET:url];
}

@end
