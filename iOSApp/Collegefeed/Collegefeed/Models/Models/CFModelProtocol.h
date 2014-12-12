//
//  CFModelProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>
#import "../../Constants.h"

typedef NS_ENUM(NSInteger, ModelType)
{
    COLLEGE,
    COMMENT,
    POST,
    TAG,
    VOTE
};

@protocol CFModelProtocol <NSObject>

+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;

- (id)initFromNetworkData:(NSData *)data;
- (id)initFromJSON:(NSDictionary *)jsonDict;
- (NSData*)toJSON;
- (NSNumber *)getID; 
- (ModelType)getType;
- (NSString *)getCellIdentifier;

@end

