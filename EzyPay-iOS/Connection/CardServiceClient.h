//
//  CardServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"
#import "Card+CoreDataClass.h"

@interface CardServiceClient : NSObject

- (void)registerCard:(Card *)card user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getCardsByUserFromServer:(int64_t) userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)updateCard:(Card *)card
              user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)deleteCard:(int64_t)serverId
              user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler:(ConnectionErrorHandler) failureHandler;
@end
