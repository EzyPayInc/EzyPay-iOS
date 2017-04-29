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

@implementation SplitRequestNotificationHandler

- (void)notificationAction:(NSDictionary *)notification {
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

- (void)responseRequest:(NSDictionary *)notification response:(int16_t)response {
    User *user = [UserManager getUser];
    int64_t paymentId = [[notification objectForKey:@"paymentId"] integerValue];
    FriendManager *manager = [[FriendManager alloc] init];
    [manager updateUserPayment:user paymentId:paymentId state:response successHandler:^(id response) {
        NSLog(@"Success Rsponse %@", response);
    } failureHandler:^(id response) {
        NSLog(@"Success Rsponse %@", response);
    }];
}

@end
