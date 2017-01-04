//
//  NavigationController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "NavigationController.h"
#import "ScannerViewController.h"

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
    navController.tabBarItem.image =  [UIImage imageNamed:@"ic_scanner"];;
    
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*History Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryController"];
    navController.tabBarItem.title = NSLocalizedString(@"historyTitle", nil);;
    navController.tabBarItem.image =  [UIImage imageNamed:@"ic_payment_history"];;
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    /*Settings Controller*/
    navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSettingsController"];
    navController.tabBarItem.title = NSLocalizedString(@"settingsTitle", nil);;
    navController.tabBarItem.image =  [UIImage imageNamed:@"ic_settings"];;
    
    controller = [NSMutableDictionary dictionary];
    [controller setObject:navController forKey:@"controller"];
    [controllers addObject:controller];
    
    return controllers;
}

- (void)presentTabBarController:(UIViewController *) controller {
     UITabBarController *tabBarController = [self setupTabBarController];
    [controller presentViewController:tabBarController animated:YES completion:NULL];
}

- (UITabBarController *)setupTabBarController {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *controllers = [[self controllersForUserNavigation] valueForKey:@"controller"];
    [tabBarController setViewControllers:controllers animated:NO];
    return tabBarController;

}

@end
