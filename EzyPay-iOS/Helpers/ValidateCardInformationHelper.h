//
//  ValidateCardInformationHelper.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDetailViewController.h"
#import <CardIO.h>

@interface ValidateCardInformationHelper : NSObject

typedef enum CardTypes
{
    Invalid = 0,
    Visa = 1,
    MasterCard = 2,
    Amex = 3,
    JCB = 4,
    Discover = 5,
    Dinners = 6
} CardType;

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
                  viewType:(CardDetailViewType) viewType
            viewController:(UIViewController *)viewController;
+ (NSString *)getDateFormated:(NSString *)expirationDate;
+ (CardType)getCardType:(CardIOCreditCardType)cardIOType;
+ (UIImage *)getCardImage:(CardType)cardType;

@end
