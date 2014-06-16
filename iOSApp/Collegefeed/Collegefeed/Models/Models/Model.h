//
//  Model.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

@class Vote;

@interface Model : NSObject

+ (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (long)getID;

@end


@protocol PostAndCommentProtocol <NSObject>

- (NSString *)getMessage;
- (NSDate *)getCreatedAt;
- (long)getScore;
- (NSString *)getCollegeName;
- (void)setVote:(Vote *)vote;
- (Vote *)getVote;

@end