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

- (UITabBarController *)controllersForEmployee:(NSDictionary *)userBoss {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSInteger userType = [[userBoss objectForKey:@"userType"] integerValue];
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableDictionary *controller = [NSMutableDictionary dictionary];
    UINavigationController *navController;
    if(userType == CommerceNavigation) {
        /*Commerce Controller*/
        navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavCommerceController"];
        navController.tabBarItem.title = NSLocalizedString(@"commerceTitle", nil);
        navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CommerceDetailViewController *viewController = [[navController viewControllers] firstObject];
        viewController.userBoss = userBoss;
        
        [controller setObject:navController forKey:@"controller"];
        [controllers addObject:controller];
    } else {
        /*Tables Controller*/
        navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TablesNavigationController"];
        navController.tabBarItem.title = NSLocalizedString(@"tableTitle", nil);
        navController.tabBarItem.image =  [[UIImage imageNamed:@"ic_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        TableCollectionViewController *viewController = [[navController viewControllers] firstObject];
        viewController.userBoss = userBoss;

        [controller setObject:navController forKey:@"controller"];
        [controllers addObject:controller];
    }
    
    [tabBarController setViewControllers:[controllers valueForKey:@"controller"] animated:NO];
    return tabBarController;
}


- (void)presentTabBarController:(UIViewController *) controller
             withNavigationType:(NavigationTypes) navigationType
                        withUser:(User *) user {
    if(navigationType != EmployeeNavigation) {
        UITabBarController *tabBarController = [self setupTabBarController:navigationType];
        [controller presentViewController:tabBarController animated:YES completion:NULL];
    } else {
        [self getUserboss:user controller:controller];
    }
}


- (UITabBarController *)setupTabBarController:(NavigationTypes) navigationType {
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
        default:
            break;
    }
    [tabBarController setViewControllers:controllers animated:NO];
    return tabBarController;
}

- (void)getUserboss:(User *)user controller:(UIViewController *) controller{
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:user.boss token:user.token successHandler:^(id response) {
        NSDictionary *userBoss = response;
        UITabBarController *tabBarController = [self controllersForEmployee:userBoss];
        [controller presentViewController:tabBarController animated:YES completion:NULL];
    } failureHandler:^(id response) {
        NSLog(@"Error getting user");
    }];
}

@end
