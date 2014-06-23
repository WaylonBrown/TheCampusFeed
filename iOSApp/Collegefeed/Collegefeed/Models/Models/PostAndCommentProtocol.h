//
//  PostAndCommentProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/17/14.
//
//

#import <Foundation/Foundation.h>

// Constant lengths for validations
#define MAX_POST_LENGTH      140
#define MAX_COMMENT_LENGTH   140
#define MIN_POST_LENGTH      10
#define MIN_COMMENT_LENGTH   10

@class Vote;

@protocol PostAndCommentProtocol <NSObject>

- (NSString *)getMessage;
- (NSDate *)getCreatedAt;
- (long)getScore;
- (NSString *)getCollegeName;
- (void)setVote:(Vote *)vote;
- (Vote *)getVote;
- (long)getID;
- (void)setCollegeName:(NSString *)name;

@end
