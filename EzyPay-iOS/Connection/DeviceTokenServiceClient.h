//
//  DeviceTokenServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/20/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalToken+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "Connection.h"

@interface DeviceTokenServiceClient : NSObject

- (void)registerDeviceToken:(LocalToken *)localToken user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)deleteDeviceToken:(NSString *)deviceId
                     user:(User *)user
           successHandler:(ConnectionSuccessHandler) successHandler
           failureHandler: (ConnectionErrorHandler) failureHandler;

@end
