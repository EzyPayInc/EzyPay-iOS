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
#import "UIColor+UIColor.h"
#import "DeviceTokenManager.h"
#import "CoreDataManager.h"
#import "NotificationHandlerFactory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    [self setupNavigationBar];
    [self setupTabBar];
    User *user= [UserManager getUser];
    if(user && user.token) {
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = user.userType;
        self.window.rootViewController = [navigationController setupTabBarController:user.userType withUser:user];
        [self.window makeKeyAndVisible];
    }
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:                                     (UIUserNotificationTypeAlert |
                                                                                         UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    if(notificationSettings != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    const char *tokenChars = deviceToken.bytes;
    NSMutableString *tokenString = [NSMutableString string];
    for (int i = 0; i < deviceToken.length; i++) {
        [tokenString appendFormat:@"%02.2hhx", tokenChars[i]];
    }
    [self registerToken:tokenString];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    NSDictionary *notification = [userInfo objectForKey:@"aps"];
    id<NotificationHandler>handler = [NotificationHandlerFactory initNotificationHandler:[notification objectForKey:@"category"]];
    [handler notificationAction:userInfo];
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
    UIColor *backgroundColor = [UIColor colorWithRed:186.0f/255.0f
                                               green:210.0f/255.0f
                                                blue:48.0f/255.0f
                                               alpha:1.0f];
    UIColor *tintColor = [UIColor colorWithRed:255.0f/255.0f
                                         green:255.0f/255.0f
                                          blue:255.0f/255.0f
                                         alpha:1.0f];
    [[UINavigationBar appearance] setBackgroundColor:backgroundColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor}];
}

- (void)setupTabBar {
    NSDictionary *attributesForSelectedState = @{
                                                 NSForegroundColorAttributeName: [UIColor grayBackgroundViewColor]
                                                 };
    [[UITabBarItem appearance] setTitleTextAttributes:attributesForSelectedState forState: UIControlStateSelected];
}

- (void)registerToken:(NSString *)deviceToken {
    User *user = [UserManager getUser];
    NSString* deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"Identifier: %@", deviceIdentifier);
    LocalToken *localToken = [DeviceTokenManager initLocalToken];
    localToken.deviceToken = deviceToken;
    localToken.deviceId = deviceIdentifier;
    localToken.isSaved = 0;
    [CoreDataManager saveContext];
    if(user && user.token) {
        DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
        [manager registerDeviceToken:localToken user:user successHandler:^(id response) {
            localToken.isSaved = 1;
            [CoreDataManager saveContext];
        } failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
}


@end
