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
#import "CoreDataManager.h"

@implementation SendBillNotificationHandler

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
    [manager getActivePaymentByUser:self.user
                     successHandler:^(id response) {
        if(paymentId == [[response objectForKey:@"id"] integerValue]) {
            [CoreDataManager deleteDataFromEntity:@"Payment"];
            Payment *payment = [PaymentManager paymentFromDictionary:response];
            [CoreDataManager saveContext];
            [self displayAlert:notification payment:payment];
        }
    } failureHandler:^(id response) {
        NSLog(@"Response: %@", response);
    }];
}

- (void)displayAlert:(NSDictionary *)notification payment:(Payment *)payment {
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
                                                         [self navigateToPaymentDetailFromViewController:viewController payment:payment];
                                                     }];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)navigateToPaymentDetailFromViewController:(UIViewController *)currentViewController
                                     payment:(Payment *)payment  {
    RestaurantDetailViewController *viewController;
    if([currentViewController isKindOfClass:[RestaurantDetailViewController class]]) {
        viewController = (RestaurantDetailViewController *)currentViewController;
        viewController.payment = payment;
        [viewController showPaymentView];
    } else {
        viewController = (RestaurantDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
        viewController.payment = payment;
        [currentViewController.navigationController pushViewController:viewController animated:YES];
    }
}

@end
