//
//  TicketServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "TicketServiceClient.h"
#import "SessionHandler.h"
#import "Ticket+CoreDataClass.h"

@interface TicketServiceClient()

@property (nonatomic, strong) SessionHandler *sessionHandler;

@end

@implementation TicketServiceClient

//constants
static NSString *const TICKET_URL = @"ticket/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)registerTicket:(Ticket *)ticket token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, TICKET_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"restaurantId=%lld&tableId=%lld", ticket.restaurantId, ticket.tableId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

@end
