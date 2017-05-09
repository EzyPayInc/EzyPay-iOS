//
//  NavigationController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserManager.h"
typedef enum {
    UserNavigation = 1,
    RestaurantNavigation = 2,
    CommerceNavigation = 3,
    EmployeeNavigation = 4
}NavigationTypes;
@interface NavigationController : NSObject

@property (nonatomic, assign) NavigationTypes navigationType;

+ (NavigationController *)sharedInstance;
+ (void)validatePaymentController:(Payment *)payment
            currentViewController:(UIViewController *)currentViewCotroller;
- (void)presentTabBarController:(UIViewController *) controller
             withNavigationType:(NavigationTypes) navigationType
                       withUser:(User *) user;
- (UITabBarController *)setupTabBarController:(NavigationTypes) navigationType withUser:(User *)user;
- (UIViewController*)topViewController;

@end
