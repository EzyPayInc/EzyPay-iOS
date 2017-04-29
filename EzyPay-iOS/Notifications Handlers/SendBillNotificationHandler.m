//
//  SendBillNotificationHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/25/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SendBillNotificationHandler.h"
#import "NavigationController.h"
#import "RestaurantDetailViewController.h"
#import "PaymentManager.h"

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
                                                     handler:^(UIAlertAction * action) {
                                                         [self navigateToPaymentDetailFromViewController:viewController notification:notification];
                                                     }];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)navigateToPaymentDetailFromViewController:(UIViewController *)currentViewController
                                     notification:(NSDictionary *)notificacion  {
    RestaurantDetailViewController *viewController;
    Payment *payment = [PaymentManager getPayment];
    if([currentViewController isKindOfClass:[RestaurantDetailViewController class]]) {
        viewController = (RestaurantDetailViewController *)currentViewController;
        viewController.payment.cost = [[notificacion objectForKey:@"amount"] floatValue];
        [viewController showPaymentView];
    } else {
        viewController = (RestaurantDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
        viewController.payment = payment;
        payment.cost = [[notificacion objectForKey:@"amount"] floatValue];
        [currentViewController.navigationController pushViewController:viewController animated:YES];
    }
}

@end
