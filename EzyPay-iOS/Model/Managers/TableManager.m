//
//  TableManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "TableManager.h"
#import "TableServiceClient.h"
#import "CoreDataManager.h"
#import "User+CoreDataClass.h"

@implementation TableManager

#pragma mark - CoreData Methods
+ (NSArray *)geTablesFromArray:(NSArray *)tablesArray withUser:(User *)user {
    NSMutableArray *tables = [NSMutableArray array];
    [CoreDataManager deleteDataFromEntity:@"Table"];
    for (NSDictionary *tableDictionary in tablesArray) {
        Table *table = [CoreDataManager createEntityWithName:@"Table"];
        table.tableId = [[tableDictionary objectForKey:@"id"] integerValue];
        table.tableNumber = [[tableDictionary objectForKey:@"tableNumber"] integerValue];
        table.isActive = [[tableDictionary objectForKey:@"isActive"] integerValue];
        [tables addObject:table];
    }
    if(tables.count > 0){
        [CoreDataManager saveContext];
    }
    return tables;
}

#pragma mark - Web service methods
- (void)registerTable:(Table *)table token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    TableServiceClient *service = [[TableServiceClient alloc] init];
    [service registerTable:table token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)getTablesByRestaurantFromServer:(int64_t) restaurantId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    TableServiceClient *service = [[TableServiceClient alloc] init];
    [service getTablesByRestaurantFromServer:restaurantId token:token successHandler:successHandler failureHandler:failureHandler];
}

@end
