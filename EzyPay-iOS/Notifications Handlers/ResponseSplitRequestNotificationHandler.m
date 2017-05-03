//
//  ResponseSplitRequestNotificationHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 5/1/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ResponseSplitRequestNotificationHandler.h"
#import "NavigationController.h"
#import "FriendManager.h"
#import "PaymentViewController.h"
#import "PaymentManager.h"

@implementation ResponseSplitRequestNotificationHandler

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
                                                         [self splitResponseAction:notification viewController:viewController];
                                                     }];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)splitResponseAction:(NSDictionary *)notification viewController:(UIViewController *)viewCotroller {
    int64_t friendId = [[notification objectForKey:@"friendId"] integerValue];
    int16_t response = [[notification objectForKey:@"response"] integerValue];
    [PaymentManager updateFriendStateWithId:friendId withState:response];
    PaymentViewController *paymentController;
    if([viewCotroller isKindOfClass:PaymentViewController.class]) {
        paymentController = (PaymentViewController *)viewCotroller;
        Payment *payment = [PaymentManager getPayment];
        NSLog(@"%@", payment.friends);
        [paymentController reloadData];
    } else {
         paymentController = (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        paymentController.payment = [PaymentManager getPayment];
        [viewCotroller.navigationController pushViewController:paymentController animated:YES];
    }
}

@end
