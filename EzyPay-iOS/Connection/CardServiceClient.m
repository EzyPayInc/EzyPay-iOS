//
//  CardServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardServiceClient.h"
#import "SessionHandler.h"

@interface CardServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation CardServiceClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void) registerCard:(NSDictionary *) card withSuccessHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) successHandler {
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/card"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    request.HTTPBody = [self getBodyFromDictionary:card];
    request.HTTPMethod = @"POST";
    [self.sessionHandler sendRequestWithRequest:request successHandler:successHandler];
}

- (NSData *) getBodyFromDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    NSMutableString *body = [[NSMutableString alloc] init];
    NSInteger *count = 0;
    for (NSString *key in keys) {
        if(count == 0){
            [body appendFormat:@"%@=%@",key, [dictionary valueForKey:key]];
        } else{
            [body appendFormat:@"&%@=%@",key, [dictionary valueForKey:key]];
        }
        count++;
    }
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

@end
