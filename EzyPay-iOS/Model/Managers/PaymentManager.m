//
//  PaymentManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentManager.h"
#import "Payment+CoreDataClass.h"
#import "CoreDataManager.h"
#import "User+CoreDataClass.h"

@implementation PaymentManager

+ (Payment *)ticketFromDictionary:(NSDictionary *)paymentDictionary {
    Payment *payment = [CoreDataManager createEntityWithName:@"Payment"];
    CoreDataManager *manager = [[CoreDataManager alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:manager.managedObjectContext];
    User *commerce = (User *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    commerce.id = [[paymentDictionary objectForKey:@"commerceId"] integerValue];
    payment.commerce = commerce;
    payment.tableNumber = [[paymentDictionary objectForKey:@"tableId"] integerValue];
    payment.cost = [[paymentDictionary objectForKey:@"cost"] floatValue];
    return payment;
}

@end
