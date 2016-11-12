//
//  Connection.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/11/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection;

typedef void (^ConnectionSuccessHandler)(id response);
typedef void (^ConnectionErrorHandler)(id response);
@interface Connection : NSObject

@property(nonatomic, strong)NSURLConnection *connection;
@property(nonatomic, strong)NSError *error;
@property(nonatomic, strong)NSURLSessionDataTask *dataTask;
@property(nonatomic, strong)NSHTTPURLResponse *response;
@property(nonatomic, strong)NSMutableData *data;

@property(nonatomic, copy)ConnectionSuccessHandler successHandler;
@property(nonatomic, copy)ConnectionErrorHandler errorHandler;



@end
