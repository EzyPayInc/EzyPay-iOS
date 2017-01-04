//
//  TicketServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@class Ticket;
@interface TicketServiceClient : NSObject

- (void)registerTicket:(Ticket *)ticket token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
