//
//  Model.h
//  Models
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (long)getID;

@end
