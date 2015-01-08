//
//  CFNavigationController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/7/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CFNavigationController : UINavigationController<CLLocationManagerDelegate>

@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (strong, nonatomic) UIActivityIndicatorView *locationActivityIndicator;

- (void)didSelectTag:(NSString *)tagMessage;
- (CLLocationManager *)startMyLocationManager;

@end
