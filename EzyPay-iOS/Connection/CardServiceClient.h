//
//  CardServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardServiceClient : NSObject

- (void) registerCard:(NSDictionary *) card withSuccessHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) successHandler;

@end
