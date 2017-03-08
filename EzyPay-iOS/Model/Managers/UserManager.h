//
//  UserManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+CoreDataClass.h"
#import "Connection.h"

@interface UserManager : NSObject

#pragma mark - Core Data
+ (User *)userFromDictionary:(NSDictionary *)userDictionary;
+ (User *)getUser;
+ (void)deleteUser;
+ (NSArray *)usersFromArray:(NSArray *)usersArray;

#pragma mark - Web Services
- (void)login:(NSString *) email password:(NSString *)password successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)registerUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
