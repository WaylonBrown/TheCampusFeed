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
    NSLog(@"URL: %@", url);
    NSLog(@"%@", stringReply);
    return nil;
}
+ (NSData *)POST:(NSData *)data toUrl:(NSURL *)url
{
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
    NSLog(@"URL: %@", url);
    NSLog(@"%@", stringReply);
    return nil;
}
+ (BOOL)DELETE:(NSData *)data toUrl:(NSURL *)url
{
    // Build request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setURL:url];
    [request setHTTPMethod:@"DELETE"];
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
    
    if ([response statusCode] == 204)
    {
        return YES;
    }
    
    NSLog(@"URL: %@", url);
    NSLog(@"%@", stringReply);
    return NO;
}

#pragma mark - Specific API Requests

+ (NSData *)getIOSAppVersionFromServer
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/miniOSVersion",
                   API_URL, API_VERSION]];
    return [self GET:url];
}

#pragma mark - Images

+ (NSNumber *)POSTImage:(UIImage *)image fromFilePath:(NSString *)pathToOurFile
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    
    if (imageData != nil)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/images", API_URL, API_VERSION];
        NSString *boundary = @"*****";
        
        // Build request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        // Header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // Body
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[upload]\";filename=\"iphonefile.jpg\"\r\n"/*, pathToOurFile*/] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        // Send request
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSString *idString = [returnString substringWithRange: NSMakeRange(0, [returnString rangeOfString: @","].location)];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber *photoID = [f numberFromString:idString];
        NSLog(@"Posted photo with ID = %@", photoID);

        return photoID;

    }
    
    
    return nil;
}
+ (NSData *)GETImageData:(long)imageID
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/images/%ld",
                   API_URL, API_VERSION, imageID]];
    
    return [self GET:url];
}

#pragma mark - Colleges

+ (NSData *)GETAllColleges
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges",
                   API_URL, API_VERSION]];
    
    return [self GET:url];
}
+ (NSData *)GETCollegeWithId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld",
                   API_URL, API_VERSION, collegeId]];
    
    return [self GET:url];
}
+ (NSData *)GETTrendingColleges
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/trending?page=%d&per_page=%d",
                   API_URL, API_VERSION, 0, 40]];
    return [self GET:url];
}
+ (NSData *)GETTrendingCollegesAtPageNum:(long)pageNum
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/trending?page=%ld&per_page=%d",
                   API_URL, API_VERSION, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}
+ (NSData *)GETCollegeListVersion
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/listVersion",
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

+ (NSData *)GETCommentsWithIdArray:(NSArray *)Ids
{
    if (Ids.count == 0 || Ids == nil)
    {
        return nil;
    }
    
    NSString *idString = @"";
    for (int i = 0; i < Ids.count; i++)
    {
        NSString *commentId = [NSString stringWithFormat:@"%@", [Ids objectAtIndex:i]];
        if ([commentId isEqualToString:@""]) continue;
        
        if (i == 0)
        {
            idString = [NSString stringWithFormat:@"many_ids[]=%@", commentId];
        }
        else if (i > 0)
        {
            idString = [NSString stringWithFormat:@"%@&many_ids[]=%@", idString, commentId];
        }
    }
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/comments/many?%@",
                   API_URL, API_VERSION, idString]];
    return [self GET:url];
}

#pragma mark - Flags

+ (NSData *)POSTFlagPost:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/flags",
                   API_URL, API_VERSION, postId]];
    NSString *string = @"{}";
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [self POST:data toUrl:url];
}

#pragma mark - Posts

+ (NSData *)GetTopPostsAtPageNum:(long)pageNum
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/trending?page=%ld&per_page=%d",
                   API_URL, API_VERSION, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}
+ (NSData *)GetTopPostsAtPageNum:(long)pageNum
                   WithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/trending?page=%ld&per_page=%d",
                   API_URL, API_VERSION, collegeId, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}

+ (NSData *)GetNewPostsAtPageNum:(long)pageNum
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/recent?page=%ld&per_page=%d",
                   API_URL, API_VERSION, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}
+ (NSData *)GetNewPostsAtPageNum:(long)pageNum
                   WithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/recent",
                   API_URL, API_VERSION, collegeId]];
    return [self GET:url];
}

+ (NSData *)GetPostsWithTag:(NSString *)tagMessage
                  AtPageNum:(long)pageNum
{
    NSString* tagWithoutHash = [tagMessage stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/byTag/%@?page=%ld&per_page=%d",
                   API_URL, API_VERSION, tagWithoutHash, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}
+ (NSData *)GetPostsWithTag:(NSString *)tagMessage
                  AtPageNum:(long)pageNum
              WithCollegeId:(long)collegeId
{
    NSString* tagWithoutHash = [tagMessage stringByReplacingOccurrencesOfString:@"#"
                                                                     withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/byTag/%@?page=%ld&per_page=%d",
                   API_URL, API_VERSION, collegeId, tagWithoutHash, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}


+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts",
                   API_URL, API_VERSION, collegeId]];
    return [self POST:data toUrl:url];
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
+ (NSData *)GETPostsWithIdArray:(NSArray *)Ids
{
    if (Ids == nil || Ids.count == 0)
    {
        return nil;
    }
    
    NSString *idString = @"";
    for (int i = 0; i < Ids.count; i++)
    {
        NSString *postId = [NSString stringWithFormat:@"%@", [Ids objectAtIndex:i]];
        if ([[NSCharacterSet decimalDigitCharacterSet] isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:postId]]
            && ![postId isEqualToString:@""])
        {
        
            if (i == 0)
            {
                idString = [NSString stringWithFormat:@"many_ids[]=%@", postId];
            }
            else if (i > 0)
            {
                idString = [NSString stringWithFormat:@"%@&many_ids[]=%@", idString, postId];
            }
        }
    }
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/many?%@",
                   API_URL, API_VERSION, idString]];
    return [self GET:url];
}
+ (NSData *)GETPostWithId:(long)postId
{
    NSArray *arr = @[[NSNumber numberWithLong:postId]];
    return [self GETPostsWithIdArray:arr];
}

#pragma mark - Tags

+ (NSData *)GetTrendingTagsAtPageNum:(long)pageNum
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/tags/trending?page=%ld&per_page=%d",
                   API_URL, API_VERSION, pageNum, PAGINATION_NUM]];
    return [self GET:url];
}
+ (NSData *)GetTrendingTagsAtPageNum:(long)pageNum
                       WithCollegeId:(long)collegeId;
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/tags/trending?page=%ld&per_page=%d",
                   API_URL, API_VERSION, collegeId, pageNum, PAGINATION_NUM]];
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
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId WithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/comments/%ld/votes",
                   API_URL, API_VERSION, postId, commentId]];
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
+ (BOOL)DELETEVoteId:(long)voteId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/votes/%ld",
                   API_URL, API_VERSION, voteId]];
    return [self DELETE:nil toUrl:url];
}
@end
