//
//  Shared.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/27/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Shared.h"

@implementation Shared

static NSString *requestURL = @"http://cfeed.herokuapp.com/api";
static NSString *apiVersion = @"v1";

+ (UIColor*)getCustomUIColor:(int)hexValue
{
    UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                     green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                      blue:((float)(hexValue & 0xFF))/255.0
                                     alpha:1.0];
    
    return color;
}

#pragma mark - Colleges

+ (NSURL*)GETAllColleges
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges",
                   requestURL, apiVersion]];
    
    return url;
}

#pragma mark - Comments

+ (NSURL*)POSTCommentWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/comments",
                   requestURL, apiVersion, postId]];
    return url;
}

+ (NSURL*)GETCommentsWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/comments",
                   requestURL, apiVersion, postId]];
    return url;
}

#pragma mark - Posts

+ (NSURL*)POSTPostWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts",
                   requestURL, apiVersion, collegeId]];
    return url;
}

+ (NSURL*)GETPostsWithTagName:(NSString*)tagName
{
    NSString* tagWithoutHash = [tagName stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/byTag/%@",
                   requestURL, apiVersion, tagWithoutHash]];
    return url;
}
+ (NSURL*)GETPostsWithTagName:(NSString*)tagName
                withCollegeId:(long)collegeId
{
    NSString* tagWithoutHash = [tagName stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/byTag/%@",
                   requestURL, apiVersion, collegeId, tagWithoutHash]];
    return url;
}

+ (NSURL*)GETAllPostsWithTag:(NSString*)tagName
              withPageNumber:(long)page
           withNumberPerPage:(long)perPage
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/byTag/%@?page=%ld&per_page=%ld",
                   requestURL, apiVersion, tagName, page, perPage]];
    return url;
}
+ (NSURL*)GETAllPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts",
                   requestURL, apiVersion]];    
    return url;
}
+ (NSURL*)GETPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts",
                   requestURL, apiVersion, collegeId]];
    return url;
}

+ (NSURL*)GETRecentPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/recent",
                   requestURL, apiVersion]];    
    return url;
}
+ (NSURL*)GETRecentPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/recent",
                   requestURL, apiVersion, collegeId]];
    return url;
}

+ (NSURL*)GETTrendingPosts
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/trending",
                   requestURL, apiVersion]];    
    return url;
}
+ (NSURL*)GETTrendingPostsWithCollegeId:(long)collegeId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/colleges/%ld/posts/trending",
                   requestURL, apiVersion, collegeId]];
    return url;
}

#pragma mark - Tags

+ (NSURL*)GETTagsTrending
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/tags/trending",
                   requestURL, apiVersion]];    
    return url;
}

#pragma mark - Votes

+ (NSURL*)POSTVoteWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/votes",
                   requestURL, apiVersion, postId]];
    return url;
}
+ (NSURL*)GETVoteScoreWithPostId:(long)postId
{
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/%@/posts/%ld/votes/score",
                   requestURL, apiVersion, postId]];
    return url;
}


@end
