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

+ (BOOL)validateCardNumberValue:(UITextField *)textField string:(NSString *)string {
    NSString *cardNumber = [textField.text stringByAppendingString:string];
    if (cardNumber.length <= 20){
        if([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length % 4 == 0 && string.length > 0){
            textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@" %@", string]];
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
