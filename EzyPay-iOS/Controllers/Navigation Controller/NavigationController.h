//
//  NavigationController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    RestaurantNavigation,
    UserNavigation
}NavigationTypes;
@interface NavigationController : NSObject

@property (nonatomic, assign) NavigationTypes navigationType;

+ (NavigationController *)sharedInstance;
- (void)presentTabBarController:(UIViewController *) controller;
- (UITabBarController *)setupTabBarController;

@end
