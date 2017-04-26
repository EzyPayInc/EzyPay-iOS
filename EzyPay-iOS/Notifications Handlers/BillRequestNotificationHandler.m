//
//  BillRequestNotificationHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BillRequestNotificationHandler.h"
#import "NavigationController.h"
#import "UserManager.h"
#import "PaymentDetailViewController.h"

@implementation BillRequestNotificationHandler

- (void)notificationAction:(NSDictionary *)notification {
    NSDictionary *notificationInfo = [notification objectForKey:@"aps"];
    NavigationController *navigationController = [[NavigationController alloc] init];
    UIViewController *viewController = [navigationController topViewController];
    NSDictionary *alertMessage = [notificationInfo objectForKey:@"alert"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[alertMessage objectForKey:@"title"]
                                                                   message:[alertMessage objectForKey:@"body"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self navigateToPaymementDetailController:notification currentViewController:viewController];
                                                     }];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)navigateToPaymementDetailController:(NSDictionary *)notification
                             currentViewController:(UIViewController *)currentViewController {
    int64_t tableNumber = [[notification objectForKey:@"tableNumber"] integerValue];
    int64_t clientId = [[notification objectForKey:@"clientId"] integerValue];
    User *user = [UserManager getUser];
    PaymentDetailViewController *viewController = (PaymentDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    viewController.tableNumber = tableNumber;
    viewController.user = user;
    viewController.isNotification = YES;
    viewController.clientId = clientId;
    [currentViewController.navigationController pushViewController:viewController animated:YES];
}

@end
