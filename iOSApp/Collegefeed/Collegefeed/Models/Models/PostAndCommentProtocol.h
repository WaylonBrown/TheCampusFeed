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

- (NSNumber *)getID;
- (NSNumber *)getPost_id;
- (NSString *)getText;
- (NSDate *)getCreated_at;
- (NSNumber *)getScore;
- (void)decrementScore;
- (void)incrementScore;
- (NSString *)getCollegeName;
- (NSNumber *)getCollege_id;
- (void)setVote:(Vote *)vote;
- (ModelType)getType;
- (Vote *)getVote;
- (void)setCollegeName:(NSString *)name;

@end
