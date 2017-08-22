//
//  LoadingView.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 8/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "LoadingView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LoadingView

+ (void)show {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

@end
