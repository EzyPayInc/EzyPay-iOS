//
//  TableManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Table+CoreDataClass.h"
#import "Connection.h"

@interface TableManager : NSObject

#pragma mark - CoreData Methods
+ (NSArray *)geTablesFromArray:(NSArray *)tablesArray withUser:(User *)user;

#pragma mark - Web service methods
- (void)registerTable:(Table *)table token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getTablesByRestaurantFromServer:(int64_t) restaurantId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
