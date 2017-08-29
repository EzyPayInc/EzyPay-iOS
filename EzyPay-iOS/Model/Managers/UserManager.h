//
//  UserManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataClass.h"
#import "Connection.h"

@interface UserManager : NSObject

#pragma mark - Core Data
+ (User *)userFromDictionary:(NSDictionary *)userDictionary;
+ (User *)userFromFacebookLogin:(NSDictionary *)facebookUser;
+ (User *)getUser;
+ (void)deleteUser;
+ (NSArray *)usersFromArray:(NSArray *)usersArray;
+ (NSArray *)employeesFromArray:(NSArray *)employeesArray;
+ (NSMutableDictionary *)userToJson:(User *)user;

#pragma mark - Web Services
- (void)login:(NSString *) email
     password:(NSString *)password
        scope:(NSString *)scope
platformToken:(NSString *)platformToken
successHandler:(ConnectionSuccessHandler) successHandler
failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)validateCredentialas:(NSDictionary *) user
              successHandler:(ConnectionSuccessHandler) successHandler
              failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getPhoneCodes:(ConnectionSuccessHandler) successHandler
       failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)registerUser:(User *) user
              tables:(NSInteger )tables
      successHandler:(ConnectionSuccessHandler) successHandler
      failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)uploadUserImage:(UIImage *)image User:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)downloadImage:(NSString *)avatarx
          toImageView:(UIImageView *)imageView
         defaultImage:(NSString *)defaultImage;
- (void)getEmployees:(int64_t)boss token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getUserHistory:(User *)user
        successHandler:(ConnectionSuccessHandler) successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getUserHistoryDates:(User *)user
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getCommerceHistory:(User *)user
        successHandler:(ConnectionSuccessHandler) successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getCommerceHistoryDates:(User *)user
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler;

@end
