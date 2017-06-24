//
//  ValidateCardInformationHelper.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateCardInformationHelper : NSObject

+ (BOOL)validateExpirationDate:(UITextField *)textField string:(NSString *)string;
+ (BOOL)validateCvvValue:(UITextField *)textField string:(NSString *)string;
+ (BOOL)validateCardNumberValue:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
                         string:(NSString *)string;

@end
