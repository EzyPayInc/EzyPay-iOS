//
//  DeviceTokenManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/20/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"
#import "LocalToken+CoreDataClass.h"
#import "User+CoreDataProperties.h"

@interface DeviceTokenManager : NSObject

#pragma mark - CoreData methods
+ (LocalToken *)initLocalToken;
+ (LocalToken *)getDeviceToken;

#pragma mark - Web Services methods
- (void)registerDeviceToken:(LocalToken *)localToken user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
@end
