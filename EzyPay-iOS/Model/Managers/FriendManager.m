//
//  FriendManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "FriendManager.h"
#import "CoreDataManager.h"
#import "Friend+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "UserPaymentServiceClient.h"
#import "Payment+CoreDataClass.h"

@implementation FriendManager

+ (NSArray *)friendsFromUserArray:(NSArray *)userArray {
    NSMutableArray *friends = [NSMutableArray array];
    for (User *user in userArray) {
        Friend *friend = [CoreDataManager createEntityWithName:@"Friend"];
        friend.id = user.id;
        friend.name = user.name;
        friend.lastname = user.lastName;
        friend.cost = 0;
        [friends addObject:friend];
    }
    return friends;
}

+(void)updateFriendStateWithId:(int64_t)friendId withState:(int16_t)state
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %lld", friendId];
    NSError *error;
    NSArray *array = [[[[CoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error] filteredArrayUsingPredicate:predicate];
    if(!error && [array count] > 0){
        Friend *friend = [array firstObject];
        friend.state = state;
        [CoreDataManager saveContext];
    }
}

#pragma mark Web Services method
- (void)addFriendsToPayment:(Payment *)payment
                       user:(User *)user
                   userCost:(float)userCost
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler {
    UserPaymentServiceClient *service = [[UserPaymentServiceClient alloc] init];
    [service addFriendsToPayment:payment
                            user:user
                        userCost:userCost
                  successHandler:successHandler
                  failureHandler:failureHandler];
}

-(void)updateUserPayment:(User *)user
               paymentId:(int64_t)paymentId
                   state:(int16_t)state
          successHandler:(ConnectionSuccessHandler) successHandler
          failureHandler:(ConnectionErrorHandler) failureHandler {
    UserPaymentServiceClient *service = [[UserPaymentServiceClient alloc] init];
    [service updateUserPayment:user
                     paymentId:paymentId
                         state:state
                successHandler:successHandler
                failureHandler:failureHandler];
}


@end
