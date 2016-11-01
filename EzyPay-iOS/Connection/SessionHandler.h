//
//  SessionHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionHandler : NSObject

- (void )sendRequestWithRequest:(NSURLRequest *)request successHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) successHandler;

@end
