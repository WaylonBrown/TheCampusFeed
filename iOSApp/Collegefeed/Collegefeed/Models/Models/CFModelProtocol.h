//
//  CFModelProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

// Constant lengths for validations
#define MIN_TAG_LENGTH 4
#define MAX_TAG_LENGTH 140

typedef NS_ENUM(NSInteger, ModelType)
{
    COLLEGE,
    COMMENT,
    POST,
    TAG,
    VOTE
};

@protocol CFModelProtocol <NSObject>

- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (long)getID;
- (void)validate;
- (ModelType)getType;

@end

