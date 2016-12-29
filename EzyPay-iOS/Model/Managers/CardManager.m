//
//  CardManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/30/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardManager.h"
#import "CardServiceClient.h"

@implementation CardManager


- (void)registerCard:(Card *)card token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler{
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient registerCard:card token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)getCardsByUserFromServer:(int64_t) userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient getCardsByUserFromServer:userId token:token successHandler:successHandler failureHandler:failureHandler];
}

@end
