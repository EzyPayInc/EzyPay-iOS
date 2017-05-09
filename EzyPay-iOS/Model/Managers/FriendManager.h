//
//  FriendManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@class Payment, User;
@interface FriendManager : NSObject

#pragma mark - CoreData methods
+ (NSArray *)friendsFromUserArray:(NSArray *)userArray;
+(void)updateFriendStateWithId:(int64_t)friendId withState:(int16_t)state;
+ (NSArray *)friendsFromArray:(NSArray *)friendsArray;

#pragma mark Web Services method
- (void)addFriendsToPayment:(Payment *)payment
                       user:(User *)user
                   userCost:(float)userCost
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler;

-(void)updateUserPayment:(User *)user
               paymentId:(int64_t)paymentId
                   state:(int16_t)state
          successHandler:(ConnectionSuccessHandler) successHandler
          failureHandler:(ConnectionErrorHandler) failureHandler;

@end
