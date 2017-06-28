//
//  ValidateCardInformationHelper.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateCardInformationHelper : NSObject

+ (BOOL)validateCvvValue:(UITextField *)textField string:(NSString *)string;
+ (BOOL)validateCardNumberValue:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
                         string:(NSString *)string;
+ (NSString *)setCardNumberFormat:(NSMutableString *)cardNumber;
+ (BOOL)validateExpirationDate:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range
                        string:(NSString *)string;
+ (void)creditCardExpiryFormatter:(UITextField *)textField;
+ (NSString *)formatCreditCardExpiry:(NSString *)input;
+ (BOOL)validateCardNumber:(NSString *)cardNumber
                       cvv:(NSString *)cvv
            expirationDate:(NSString *)expirationDate
            viewController:(UIViewController *)viewController;

@end
