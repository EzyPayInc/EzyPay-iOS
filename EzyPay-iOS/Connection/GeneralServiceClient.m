//
//  GeneralServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/28/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "GeneralServiceClient.h"
#import "SessionHandler.h"

@interface GeneralServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation GeneralServiceClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

//constants
static NSString *const AUTH_URL = @"auth/token";

- (void)login:(NSString *) email
     password:(NSString *)password
        scope:(NSString *)scope
platformToken:(NSString *)platformToken
successHandler:(ConnectionSuccessHandler) successHandler
failureHandler:(ConnectionErrorHandler) failureHandler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, AUTH_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *basicAuth = [NSString stringWithFormat:@"%@:%@",CLIENT_ID,SECRET_KEY];
    NSString *encodedString = [self stringByBase64EncodingWithString:basicAuth];
    NSString *parameters;
    if (scope != nil) {
        parameters = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@&scope=%@",
                      email,password, scope];
        [request addValue:platformToken forHTTPHeaderField:@"PlatformToken"];
    } else {
        parameters = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",email, password];
    }
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];;
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Basic %@",encodedString] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
    
}

- (void)validateCredentialas:(NSDictionary *) user
              successHandler:(ConnectionSuccessHandler) successHandler
              failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/credential", BASE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *basicAuth = [NSString stringWithFormat:@"%@:%@",CLIENT_ID,SECRET_KEY];
    NSString *encodedString = [self stringByBase64EncodingWithString:basicAuth];
    NSData *body = [NSJSONSerialization dataWithJSONObject:user options:0 error:nil];
    request.HTTPBody = body;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Basic %@",encodedString] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
    
}

- (void)getPhoneCodes:(ConnectionSuccessHandler) successHandler
       failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@country/getAll", BASE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *basicAuth = [NSString stringWithFormat:@"%@:%@",CLIENT_ID,SECRET_KEY];
    NSString *encodedString = [self stringByBase64EncodingWithString:basicAuth];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Basic %@",encodedString] forHTTPHeaderField:@"Authorization"];
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

@end
