//
//  CFModelProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

// Constant lengths for validations


#define MAX_TAG_LENGTH       50
#define MIN_TAG_LENGTH       2

@protocol CFModelProtocol <NSObject>

- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (long)getID;
- (void)validate;

@end

