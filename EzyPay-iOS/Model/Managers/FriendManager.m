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


@end
