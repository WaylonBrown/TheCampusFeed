//
//  CFModelProtocol.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

// Constant lengths for validations
#define MIN_TAG_LENGTH       4

@protocol CFModelProtocol <NSObject>

- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (long)getID;
- (void)validate;

@end

