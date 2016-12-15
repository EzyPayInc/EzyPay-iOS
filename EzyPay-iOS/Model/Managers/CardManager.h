//
//  CardManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/30/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card+CoreDataClass.h"
#import "Connection.h"

@interface CardManager : NSObject

- (void)registerCard:(Card *)card token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
