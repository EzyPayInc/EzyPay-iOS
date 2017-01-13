//
//  UserManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "UserManager.h"
#import "CoreDataManager.h"
#import "GeneralServiceClient.h"
#import "UserServiceClient.h"

@implementation UserManager

//core data methods
+ (User *)userFromDictionary:(NSDictionary *)userDictionary {
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = [userDictionary objectForKey:@"name"];
    user.email = [userDictionary objectForKey:@"email"];
    user.lastName = [userDictionary objectForKey:@"lastName"];
    user.phoneNumber = [userDictionary objectForKey:@"phoneNumber"];
    return user;
}

+ (User *)getUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error;
    NSArray *array = [[[CoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if(!error && [array count] > 0){
        return [array firstObject];
    }
    return nil;
}

//web services methods
- (void)login:(NSString *) email password:(NSString *)password successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    GeneralServiceClient *service = [[GeneralServiceClient alloc] init];
    [service login:email password:password successHandler:successHandler failureHandler:failureHandler];
}

- (void)registerUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service registerUser:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service getUserFromServer:userId token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service updateUser:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
     UserServiceClient *service = [[UserServiceClient alloc] init];
    [service validatePhoneNumbers:phoneNumbers token:token successHandler:successHandler failureHandler:failureHandler];
}


@end
