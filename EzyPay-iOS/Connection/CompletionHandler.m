//
//  CompletionHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/12/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CompletionHandler.h"
#import <UIKit/UIKit.h>

@implementation CompletionHandler

- (void)handleResponse:(Connection *) connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(connection.response.statusCode == 401) {
        [self handleUnauthorizedRequest:connection];
    } else if(connection.error) {
        [self handleConnectionError:connection];
    } else if(connection.response.statusCode == 200 || connection.response.statusCode == 500) {
        [self handleCompletionRequest:connection];
    }
}

- (void)handleUnauthorizedRequest:(Connection *)connection {
    NSLog(@"Unauthorized request");
    
}

- (void)handleConnectionError:(Connection *)connection {
    NSLog(@"Connection error");
}

- (void)handleCompletionRequest:(Connection *)connection {
    id response = [NSJSONSerialization JSONObjectWithData:connection.data options:0 error:nil];
    if(connection.response.statusCode == 200) {
        connection.successHandler(response);
    } else {
        connection.errorHandler(response);
    }
}

@end
