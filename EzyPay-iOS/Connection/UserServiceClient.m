//
//  UserServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "UserServiceClient.h"
#import "SessionHandler.h"

@interface UserServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation UserServiceClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void) registerUser:(NSDictionary *) user withSuccessHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) successHandler {
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/user/create"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    request.HTTPBody = [self getBodyFromDictionary:user];
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
