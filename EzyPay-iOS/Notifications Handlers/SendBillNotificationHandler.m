//
//  SendBillNotificationHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/25/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SendBillNotificationHandler.h"
#import "NavigationController.h"

@implementation SendBillNotificationHandler

- (void)notificationAction:(NSDictionary *)notification {
    NavigationController *navigationController = [[NavigationController alloc] init];
    UIViewController *viewController = [navigationController topViewController];
    NSDictionary *alertMessage = [notification objectForKey:@"alert"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[alertMessage objectForKey:@"title"]
                                                                   message:[alertMessage objectForKey:@"body"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
