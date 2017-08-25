//
//  NavigationController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "NavigationController.h"
#import "CommerceDetailViewController.h"
#import "TableCollectionViewController.h"
#import "Payment+CoreDataClass.h"
#import "Friend+CoreDataClass.h"
#import "RestaurantDetailViewController.h"
#import "PaymentViewController.h"
#import "CoreDataManager.h"
#import "DeviceTokenManager.h"
#import "ChooseViewController.h"
#import "LoadingView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation NavigationController

+ (NavigationController *)sharedInstance{
    static NavigationController *instance;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        instance = [[NavigationController alloc] init];
    });
    return instance;
}

- (NSArray *)controllersForUserNavigation {
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableDictionary *controller = [NSMutableDictionary dictionary];
    UINavigationController *navController;
    
    /*Payment Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavPaymentController"];
    navController.tabBarItem.title = NSLocalizedString(@"scannerTitle", nil);
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*History Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryController"];
    navController.tabBarItem.title = NSLocalizedString(@"historyTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_payment_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*Settings Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSettingsController"];
    navController.tabBarItem.title = NSLocalizedString(@"settingsTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    return controllers;
}

- (NSArray *)controllersForCommerNavigation {
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableDictionary *controller = [NSMutableDictionary dictionary];
    UINavigationController *navController;
    
    /*Commerce Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavCommerceController"];
    navController.tabBarItem.title = NSLocalizedString(@"commerceTitle", nil);
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*History Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryCommerceController"];
    navController.tabBarItem.title = NSLocalizedString(@"historyTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_payment_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*Settings Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSettingsController"];
    navController.tabBarItem.title = NSLocalizedString(@"settingsTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    return controllers;
}

- (NSArray *)controllersForRestaurantNavigation {
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableDictionary *controller = [NSMutableDictionary dictionary];
    UINavigationController *navController;
    
    /*Tables Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TablesNavigationController"];
    navController.tabBarItem.title = NSLocalizedString(@"tableTitle", nil);
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*History Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryCommerceController"];
    navController.tabBarItem.title = NSLocalizedString(@"historyTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_payment_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*Settings Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSettingsController"];
    navController.tabBarItem.title = NSLocalizedString(@"settingsTitle", nil);;
    navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    return controllers;
}

- (NSArray *)controllersForEmployeeNavigation:(User *)user {
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableDictionary *controller = [NSMutableDictionary dictionary];
    UINavigationController *navController;
    //if(user.boss.userType == CommerceNavigation) {
        /*Commerce Controller*/
        navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavCommerceController"];
        navController.tabBarItem.title = NSLocalizedString(@"commerceTitle", nil);
        navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [controller setObject:navController forKey:@"controller"];
        [controllers addObject:controller];
    //} else {
        /*Tables Controller*/
      /*  navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TablesNavigationController"];
        navController.tabBarItem.title = NSLocalizedString(@"tableTitle", nil);
        navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [controller setObject:navController forKey:@"controller"];
        [controllers addObject:controller];
    }*/
    
    return controllers;
}

- (void)presentTabBarController:(UIViewController *) controller
             withNavigationType:(NavigationTypes) navigationType
                        withUser:(User *) user {
    UITabBarController *tabBarController = [self setupTabBarController:navigationType withUser:user];
    [controller presentViewController:tabBarController animated:YES completion:NULL];
}

- (UITabBarController *)setupTabBarController:(NavigationTypes) navigationType withUser:(User *)user {
    NSArray *controllers;
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    switch (navigationType) {
        case UserNavigation:
            controllers = [[self controllersForUserNavigation] valueForKey:@"controller"];
            [tabBarController setViewControllers:controllers animated:NO];
            break;
        case RestaurantNavigation:
            controllers = [[self controllersForRestaurantNavigation] valueForKey:@"controller"];
            break;
        case CommerceNavigation:
            controllers = [[self controllersForCommerNavigation] valueForKey:@"controller"];
            break;
        case EmployeeNavigation:
            controllers = [[self controllersForEmployeeNavigation:user] valueForKey:@"controller"];
            break;
        default:
            break;
    }
    [tabBarController setViewControllers:controllers animated:NO];
    return tabBarController;
}

- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (void)validatePaymentController:(Payment *)payment
            currentViewController:(UIViewController *)currentViewCotroller {
    if(payment.friends == nil || [payment.friends count] == 0) {
        RestaurantDetailViewController *viewController =
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
        viewController.payment = payment;
        [currentViewCotroller.navigationController pushViewController:viewController animated:YES];
    } else {
        PaymentViewController *viewController =
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        viewController.payment = payment;
        [currentViewCotroller.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (void)logoutUser:(User *) user fromViewController:(UIViewController *) viewController {
    [LoadingView show];
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
    [manager deleteDeviceToken:localToken.deviceId user:user successHandler:^(id response) {
        [LoadingView dismiss];
        localToken.isSaved = 0;
        [CoreDataManager saveContext];
        [[self class] logoutFromViewController:viewController];
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    } failureHandler:^(id response) {
        [LoadingView dismiss]; 
        NSLog(@"Response %@", response);
    }];
}

+ (void)logoutFromViewController:(UIViewController *)viewController {
    ChooseViewController *chooseViewController = (ChooseViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseViewController"];
    [UserManager deleteUser];
    [viewController presentViewController:chooseViewController animated:YES completion:nil];
}


@end
