//
//  GeneralServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/28/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface GeneralServiceClient : NSObject

- (void)login:(NSString *) email
     password:(NSString *)password
        scope:(NSString *)scope
successHandler:(ConnectionSuccessHandler) successHandler
failureHandler: (ConnectionErrorHandler) failureHandler;

@end
