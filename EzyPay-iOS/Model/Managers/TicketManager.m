//
//  TicketManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "TicketManager.h"
#import "CoreDataManager.h"
#import "TicketServiceClient.h"

@implementation TicketManager

#pragma mark - Coredata methods
+ (Ticket *)ticketFromDictionary:(NSDictionary *)ticketDictionary {
    Ticket *ticket = [CoreDataManager createEntityWithName:@"Ticket"];
    ticket.restaurantId = [[ticketDictionary objectForKey:@"restaurantId"] integerValue];
    ticket.tableId = [[ticketDictionary objectForKey:@"tableId"] integerValue];
    return ticket;
}

+ (Ticket *)getTicket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    NSError *error;
    NSArray *array = [[[CoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if(!error && [array count] > 0){
        return [array firstObject];
    }
    return nil;
}

+ (void)deleteTicket {
    [CoreDataManager deleteDataFromEntity:@"Ticket"];
}

#pragma mark - Web service methods
- (void)registerTicket:(Ticket *)ticket token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    TicketServiceClient *service = [[TicketServiceClient alloc] init];
    [service registerTicket:ticket token:token successHandler:successHandler failureHandler:failureHandler];
}




@end
