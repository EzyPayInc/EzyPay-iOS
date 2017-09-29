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
        Card *card = [CoreDataManager createEntityWithName:@"Card"];
        card.id = [[cardDictionary objectForKey:@"id"] integerValue];
        card.cardNumber = [cardDictionary objectForKey:@"cardNumber"];
        card.ccv = [[cardDictionary objectForKey:@"ccv"] integerValue];
        card.expirationDate = [cardDictionary objectForKey:@"expirationDate"];
        card.serverId =  [[cardDictionary objectForKey:@"serverId"] integerValue];
        card.token = [cardDictionary objectForKey:@"token"];
        card.isFavorite = [[cardDictionary objectForKey:@"isFavorite"] integerValue];
        card.cardVendor = [[cardDictionary objectForKey:@"cardVendor"] integerValue];
        [cards addObject:card];
    }
    if(cards.count > 0){
        [CoreDataManager saveContext];
    }
    return cards;
}

#pragma mark - Web service methods
- (void)registerCard:(Card *)card user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient registerCard:card user:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)getCardsByUserFromServer:(int64_t) userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient getCardsByUserFromServer:userId token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)updateCard:(Card *)card
              user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler: (ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient updateCard:card user:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)deleteCard:(int64_t)serverId
              user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler:(ConnectionErrorHandler) failureHandler {
    CardServiceClient *serviceClient = [[CardServiceClient alloc] init];
    [serviceClient deleteCard:serverId
                         user:user
               successHandler:successHandler
               failureHandler:failureHandler];
}

@end
