//
//  UserServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "User+CoreDataClass.h"

@interface UserServiceClient : NSObject

- (void)registerUser:(User *) user
              tables:(NSInteger )tables
      successHandler:(ConnectionSuccessHandler) successHandler
      failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)uploadUserImage:(UIImage *)image User:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)downloadImage:(NSString *)avatar
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
- (void)updatePassword:(NSString *)newPassword
                  user:(User *)user
        successHandler:(ConnectionSuccessHandler) successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)forgotPassword:(NSString *) email
        successHandler:(ConnectionSuccessHandler) successHandler
        failureHandler: (ConnectionErrorHandler) failureHandler;
@end
