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
/*Core Data methods*/
+ (NSArray *)getCardsFromArray:(NSArray *)arrayCards;

/*Web services methods*/
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
