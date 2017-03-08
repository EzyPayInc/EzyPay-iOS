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
    UserNavigation = 1,
    CommerceNavigation = 2
}NavigationTypes;
@interface NavigationController : NSObject

@property (nonatomic, assign) NavigationTypes navigationType;

+ (NavigationController *)sharedInstance;
- (void)presentTabBarController:(UIViewController *) controller
             withNavigationType:(NavigationTypes) navigationType;
- (UITabBarController *)setupTabBarController:(NavigationTypes) navigationType;

@end
