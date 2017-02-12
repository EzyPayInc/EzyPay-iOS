//
//  AppDelegate.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/19/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "UserManager.h"
#import "NavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    [self setupNavigationBar];
    //[self setupTabBar];
    User *user= [UserManager getUser];
    if(user && user.token) {
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = UserNavigation;
        self.window.rootViewController = [navigationController setupTabBarController];
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - setup controls appearence
- (void)setupNavigationBar {
    UIColor *color = [UIColor colorWithRed:105.0f/255.0f
                                     green:105.0f/255.0f
                                      blue:105.0f/255.0f
                                     alpha:1.0f];
    [[UINavigationBar appearance] setTintColor:color];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void)setupTabBar {
    [[UITabBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
    NSDictionary *attributesForNormalState = @{
                                               NSForegroundColorAttributeName: [UIColor blackColor],
                                               };
    NSDictionary *attributesForSelectedState = @{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 };
    [[UITabBarItem appearance] setTitleTextAttributes:attributesForNormalState forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributesForSelectedState forState: UIControlStateSelected];
}

@end
