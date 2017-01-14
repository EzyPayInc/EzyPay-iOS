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

//constans
static NSString *const BASE_URL = @"http:192.168.1.103:3000/";
static NSString *const USER_URL = @"user/";
static NSString *const CLIENT_ID  = @"ceWZ_4G8CjQZy7,8";
static NSString *const SECRET_KEY = @"9F=_wPs^;W]=Hqf!3e^)ZpdR;MUym+";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)registerUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, USER_URL]];
    NSString *basicAuth = [NSString stringWithFormat:@"%@:%@",CLIENT_ID,SECRET_KEY];
    NSString *encodedString = [self stringByBase64EncodingWithString:basicAuth];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"name=%@&lastName=%@&phoneNumber=%@&email=%@&password=%@", user.name, user.lastName, user.phoneNumber, user.email, user.password];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Basic %@",encodedString] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    NSString *parameters = [NSString stringWithFormat:@"%@%lld",USER_URL, userId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"GET";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lld", BASE_URL, USER_URL, user.id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"name=%@&lastName=%@&phoneNumber=%@&email=%@", user.name, user.lastName, user.phoneNumber, user.email];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/validatePhoneNumbers", BASE_URL, USER_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDictionary *postArray = @{@"phoneNumbers": phoneNumbers};
    NSData *body = [NSJSONSerialization dataWithJSONObject:postArray options:0 error:nil];
    request.HTTPBody = body;
    NSString *str = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"Body: %@ ",str);
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}


- (NSString *)stringByBase64EncodingWithString:(NSString *)inString
{
    NSData *data = [NSData dataWithBytes:[inString UTF8String]
                                  length:[inString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3)
    {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++)
        {
            value <<= 8;
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = base64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = base64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? base64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? base64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (NSData *) getBodyFromDictionary:(User *)user {
    NSArray *keys = [[[user entity] attributesByName] allKeys];
    NSMutableString *body = [[NSMutableString alloc] init];
    NSInteger *count = 0;
    for (NSString *key in keys) {
        if([user valueForKey:key]){
            if(count == 0){
                [body appendFormat:@"%@=%@",key, [user valueForKey:key]];
            } else{
                [body appendFormat:@"&%@=%@",key, [user valueForKey:key]];
            }
            count++;
        }
    }
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

@end
