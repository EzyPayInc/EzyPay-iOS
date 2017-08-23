//
//  CompletionHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/12/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CompletionHandler.h"
#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "LoginViewController.h"
#import "LogInCommerceViewController.h"
#import "LoadingView.h"

@implementation CompletionHandler

- (void)handleResponse:(Connection *) connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(connection.response.statusCode == 401 || connection.response.statusCode == 403) {
        [LoadingView dismiss];
        [self handleUnauthorizedRequest:connection];
    } else if(connection.error) {
        [LoadingView dismiss];
        [self handleConnectionError:connection];
    } else if(connection.response.statusCode == 200 || connection.response.statusCode == 500) {
        [self handleCompletionRequest:connection];
    }
}

- (void)handleUnauthorizedRequest:(Connection *)connection {
    [self invalidCredentials];
}

- (void)handleConnectionError:(Connection *)connection {
    [self communicationError];
}

- (void)handleCompletionRequest:(Connection *)connection {
    id response = [NSJSONSerialization JSONObjectWithData:connection.data options:0 error:nil];
    if(connection.response.statusCode == 200) {
        connection.successHandler(response);
    } else {
        connection.errorHandler(response);
    }
}

- (void)invalidCredentials {
    NavigationController *navigationController = [[NavigationController alloc] init];
    UIViewController *viewController = [navigationController topViewController];
    NSString *message = ([viewController isKindOfClass:[LoginViewController class]] ||
    [viewController isKindOfClass:[LogInCommerceViewController class]]) ?
    NSLocalizedString(@"invalidCredentials", nil) : NSLocalizedString(@"sessionExpiredMessage", nil);
    NSString *title = NSLocalizedString(@"errorTitle", nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){
                                                         [self invalidCredentialsAction:viewController];
                                                     }];
    
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:nil];

}

- (void)invalidCredentialsAction:(UIViewController *)topViewController {
    if([topViewController isKindOfClass:[LoginViewController class]] ||
        [topViewController isKindOfClass:[LogInCommerceViewController class]]) {
        return;
    }
    [NavigationController logoutFromViewController:topViewController];
}

- (void)communicationError {
    NavigationController *navigationController = [[NavigationController alloc] init];
    UIViewController *viewController = [navigationController topViewController];
    NSString *message = NSLocalizedString(@"communicationErrorMessage", nil);
    NSString *title = NSLocalizedString(@"errorTitle", nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}
@end
