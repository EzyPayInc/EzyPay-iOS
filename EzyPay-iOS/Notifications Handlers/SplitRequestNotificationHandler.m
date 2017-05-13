//
//  SplitRequestNotificationHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitRequestNotificationHandler.h"
#import "NavigationController.h"
#import "FriendManager.h"
#import "UserManager.h"
#import "PushNotificationManager.h"
#import "PaymentManager.h"

@implementation SplitRequestNotificationHandler

-(id)init {
    self = [super init];
    if (self) {
        self.user = [UserManager getUser];
    }
    return self;
}

- (void)notificationAction:(NSDictionary *)notification {
    int64_t paymentId = [[notification objectForKey:@"paymentId"] integerValue];
    int64_t friendId = [[notification objectForKey:@"friendId"] integerValue];
    if(self.user && self.user.id == friendId ) {
        [self getPayment:paymentId notification:notification];
    }
}

-(void)getPayment:(int64_t)paymentId notification:(NSDictionary *)notification {
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager getPaymentById:paymentId token:self.user.token successHandler:^(id response) {
        if([[response objectForKey:@"isCanceled"] integerValue] == 0) {
            [self displayAlert:notification];
        }
    } failureHandler:^(id response) {
    }];
}

- (void)displayAlert:(NSDictionary *)notification {
    NSDictionary *notificationInfo = [notification objectForKey:@"aps"];
    NavigationController *navigationController = [[NavigationController alloc] init];
    UIViewController *viewController = [navigationController topViewController];
    NSDictionary *alertMessage = [notificationInfo objectForKey:@"alert"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[alertMessage objectForKey:@"title"]
                                                                   message:[alertMessage objectForKey:@"body"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self responseRequest:notification response:-1];
                                                         }];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Accept"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self responseRequest:notification response:1];
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:acceptAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}


- (void)responseRequest:(NSDictionary *)notification response:(int16_t)userResponse {
    int64_t paymentId = [[notification objectForKey:@"paymentId"] integerValue];
    FriendManager *manager = [[FriendManager alloc] init];
    [manager updateUserPayment:self.user paymentId:paymentId state:userResponse successHandler:^(id response) {
        [self responseSplitRequestNotification:notification response:userResponse];
    } failureHandler:^(id response) {
        NSLog(@"Error Rsponse %@", response);
    }];
}

- (void)responseSplitRequestNotification:notification response:(int16_t)response {
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    int64_t clientId = [[notification objectForKey:@"userId"] integerValue];
    int64_t paymentId = [[notification objectForKey:@"paymentId"] integerValue];
    [manager responseSplitNotification:self.user
                             paymentId:paymentId
                              response:response
                              clientId:clientId
                        successHandler:^(id response) {
                            NSLog(@"Success Rsponse %@", response);
                        }
                        failureHandler:^(id response) {
                            NSLog(@"Error Rsponse %@", response);
                        }];
}

@end
