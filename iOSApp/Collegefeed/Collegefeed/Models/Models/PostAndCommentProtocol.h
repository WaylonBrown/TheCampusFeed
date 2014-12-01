//
//  PostAndCommentProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/17/14.
//
//

#import <Foundation/Foundation.h>
#import "../../Constants.h"

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
