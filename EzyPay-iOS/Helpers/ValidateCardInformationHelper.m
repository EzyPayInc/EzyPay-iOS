//
//  ValidateCardInformationHelper.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ValidateCardInformationHelper.h"

@implementation ValidateCardInformationHelper

+ (BOOL)validateExpirationDate:(UITextField *)textField string:(NSString *)string {
    NSString *expirationDate = [textField.text stringByAppendingString:string];
    if(expirationDate.length == 2 && string.length > 0) {
        textField.text = [expirationDate stringByAppendingString:@"/"];
        return NO;
    }
    
    if(expirationDate.length > 5) {
        return NO;
    }
    if(expirationDate.length == 1) {
        NSInteger dateToNumber = [expirationDate integerValue];
        if(dateToNumber > 1) {
            textField.text = [NSString stringWithFormat:@"0%@/",expirationDate];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)validateCvvValue:(UITextField *)textField string:(NSString *)string {
    NSString *cvvString = [textField.text stringByAppendingString:string];
    return cvvString.length > 3? NO : YES;
}

+ (BOOL)validateCardNumberValue:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
                         string:(NSString *)string{
    NSMutableString *cardNumber = [NSMutableString stringWithString:textField.text];
    if (string.length == 0) {
        [cardNumber deleteCharactersInRange:range];
    } else {
        [cardNumber insertString:string atIndex:range.location];
    }
    if (cardNumber.length < 20){
        cardNumber = (NSMutableString *)[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        textField.text = [self setCardNumberFormat:cardNumber];
    }
    return NO;
}

+ (NSString *)setCardNumberFormat:(NSMutableString *)cardNumber {
    NSMutableString *cardNumberWithFormat = [NSMutableString string];
    for (int i = 0; i < [cardNumber length]; i++) {
        char currentChar = [cardNumber characterAtIndex:i];
        if(i== 4 || i== 8 || i == 12) {
            [cardNumberWithFormat appendFormat:@" %c", currentChar];
        } else {
            [cardNumberWithFormat appendFormat:@"%c", currentChar];
        }
    }
    return cardNumberWithFormat;
} 

@end
