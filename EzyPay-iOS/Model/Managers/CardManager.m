//
//  CardManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/30/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardManager.h"
#import "CardServiceClient.h"
#import "CoreDataManager.h"

@implementation CardManager

#pragma mark - Core Data methods
+ (NSArray *)getCardsFromArray:(NSArray *)arrayCards{
    NSMutableArray *cards = [NSMutableArray array];
    [CoreDataManager deleteDataFromEntity:@"Card"];
    for (NSDictionary *cardDictionary in arrayCards) {
        if(![[cardDictionary valueForKey:@"month"] isKindOfClass:[NSNull class]]) {
        Card *card = [CoreDataManager createEntityWithName:@"Card"];
        card.id = [[cardDictionary objectForKey:@"id"] integerValue];
        card.number = [cardDictionary objectForKey:@"number"];
        card.cvv = [[cardDictionary objectForKey:@"cvv"] integerValue];
        card.month = [[cardDictionary objectForKey:@"month"] integerValue];
        card.year = [[cardDictionary objectForKey:@"year"] integerValue];
        [cards addObject:card];
        }
    }
    if(cards.count > 0){
        [CoreDataManager saveContext];
    }
    return cards;
}

#pragma mark - Web service methods
- (void)registerCard:(Card *)card token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler{
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient registerCard:card token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)getCardsByUserFromServer:(int64_t) userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient getCardsByUserFromServer:userId token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)updateCardInServer:(Card *)card token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient updateCard:card token:token successHandler:successHandler failureHandler:failureHandler];
}

@end
