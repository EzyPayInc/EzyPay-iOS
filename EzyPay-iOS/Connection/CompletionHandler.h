//
//  CompletionHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/12/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface CompletionHandler : NSObject

- (void)handleResponse:(Connection *) connection;

@end
