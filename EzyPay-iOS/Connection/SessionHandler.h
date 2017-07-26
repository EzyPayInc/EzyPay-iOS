//
//  SessionHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SessionHandler : NSObject

FOUNDATION_EXPORT NSString *const BASE_URL;
FOUNDATION_EXPORT NSString *const IMAGE_URL;
FOUNDATION_EXPORT NSString *const CLIENT_ID;
FOUNDATION_EXPORT NSString *const SECRET_KEY;

- (void)sendRequestWithRequest:(NSURLRequest *)request successHandeler:(id)successHandler failureHandler:(id)failureHandler;

@end
