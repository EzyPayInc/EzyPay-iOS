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
#import "PaymentManager.h"

@implementation BillRequestNotificationHandler

-(id)init {
    self = [super init];
    if (self) {
        self.user = [UserManager getUser];
    }
    return self;
}

- (void)notificationAction:(NSDictionary *)notification {
    int64_t paymentId = [[notification objectForKey:@"paymentId"] integerValue];
    if(self.user) {
        [self getPayment:paymentId notification:notification];
    }
}

-(void)getPayment:(int64_t)paymentId notification:(NSDictionary *)notification {
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager getPaymentById:paymentId token:self.user.token successHandler:^(id response) {
        if((self.user.id == [[response objectForKey:@"commerceId"] integerValue] ||
            self.user.id == [[response objectForKey:@"employeeId"] integerValue]) &&
           [[response objectForKey:@"isCanceled"] integerValue] == 0) {
            [self displayAlert:notification payment:response];
        }
    } failureHandler:^(id response) {
    }];
}

- (void)displayAlert:(NSDictionary *)notification payment:(NSDictionary *)payment {
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
                                                         [self navigateToPaymementDetailController:payment   currentViewController:viewController];
                                                     }];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}


- (void)navigateToPaymementDetailController:(NSDictionary *)payment
                      currentViewController:(UIViewController *)currentViewController {
    PaymentDetailViewController *viewController = (PaymentDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    viewController.tableNumber = [[payment objectForKey:@"tableNumber"] integerValue];
    viewController.user = self.user;
    viewController.isNotification = YES;
    viewController.clientId =  [[payment objectForKey:@"userId"] integerValue];
    viewController.paymentId = [[payment objectForKey:@"id"] integerValue];
    [currentViewController.navigationController pushViewController:viewController animated:YES];
}

@end
