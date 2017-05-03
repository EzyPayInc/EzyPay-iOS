//
//  DeviceTokenManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/20/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "DeviceTokenManager.h"
#import "DeviceTokenServiceClient.h"
#import "CoreDataManager.h"

@implementation DeviceTokenManager

#pragma mark - CoreData methods
+ (LocalToken *)initLocalToken {
    [CoreDataManager deleteDataFromEntity:@"LocalToken"];
    LocalToken *localToken = [CoreDataManager createEntityWithName:@"LocalToken"];
    return localToken;
}

+ (LocalToken *)getDeviceToken {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalToken"];
    NSError *error;
    NSArray *array = [[[CoreDataManager sharedInstance]
                       managedObjectContext] executeFetchRequest:request error:&error];
    if(!error && [array count] > 0){
        return [array firstObject];
    }
    return nil;
}

#pragma mark - Web Services methods
- (void)registerDeviceToken:(LocalToken *)localToken user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    DeviceTokenServiceClient *service = [[DeviceTokenServiceClient alloc] init];
    [service registerDeviceToken:localToken
                            user:user
                  successHandler:successHandler
                  failureHandler:failureHandler];
}

- (void)deleteDeviceToken:(NSString *)deviceId
                     user:(User *)user
           successHandler:(ConnectionSuccessHandler) successHandler
           failureHandler: (ConnectionErrorHandler) failureHandler {
    DeviceTokenServiceClient *service = [[DeviceTokenServiceClient alloc] init];
    [service deleteDeviceToken:deviceId
                          user:user
                successHandler:successHandler
                failureHandler:failureHandler];
}

@end
