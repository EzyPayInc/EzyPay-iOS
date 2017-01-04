//
//  TicketManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket+CoreDataClass.h"
#import "Connection.h"

@interface TicketManager : NSObject

#pragma mark - core data methods
+ (Ticket *)ticketFromDictionary:(NSDictionary *)ticketDictionary;
+ (Ticket *)getTicket;
+ (void)deleteTicket;


#pragma mark - Web service methods
- (void)registerTicket:(Ticket *)ticket token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
