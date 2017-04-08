//
//  CurrencyServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface CurrencyServiceClient : NSObject

- (void)getAllCurriencies:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
