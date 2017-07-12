//
//  ValidateCardInformationHelper.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ValidateCardInformationHelper.h"
#import "NSString+String.h"

@implementation ValidateCardInformationHelper

#pragma mark - Cvv validation
+ (BOOL)validateCvvValue:(UITextField *)textField string:(NSString *)string {
    NSString *cvvString = [textField.text stringByAppendingString:string];
    return cvvString.length <= 4;
}

#pragma mark - Card number  formatting and validation
+ (BOOL)validateCardNumberValue:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
                         string:(NSString *)string{
    NSMutableString *cardNumber = [NSMutableString stringWithString:textField.text];
    string.length == 0 ? [cardNumber deleteCharactersInRange:range] :  [cardNumber insertString:string atIndex:range.location];
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

#pragma mark - Expiration date formatting and validation

+ (BOOL)validateExpirationDate:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range
                        string:(NSString *)string {
    NSMutableString *expirationDate = [NSMutableString stringWithString:textField.text];
    [expirationDate insertString:string atIndex:range.location];
    if(expirationDate.length > 5) {
        return NO;
    }
    if(expirationDate.length == 1) {
        if([expirationDate integerValue] > 1)  {
            textField.text = [NSString stringWithFormat:@"0%@",expirationDate];
            return NO;
        }
    } else if(expirationDate.length == 2) {
        return [expirationDate integerValue] <= 12;
    }
    return YES;
}

+ (void)creditCardExpiryFormatter:(UITextField *)textField {
    NSString *formattedText = [ValidateCardInformationHelper formatCreditCardExpiry:textField.text];
    if (![formattedText isEqualToString:textField.text]) {
        textField.text = formattedText;
    }
}

+ (NSString *)formatCreditCardExpiry:(NSString *)input
{
    input = [[self class] trimSpecialCharacters:input];
    NSString *output;
    switch (input.length) {
        case 1:
        case 2:
            output = [NSString stringWithFormat:@"%@", [input substringToIndex:input.length]];
            break;
        case 3:
        case 4:
            output = [NSString stringWithFormat:@"%@/%@", [input substringToIndex:2], [input substringFromIndex:2]];
            break;
        default:
            output = @"";
            break;
    }
    return output;
}

+ (NSString *)trimSpecialCharacters:(NSString *)input
{
    NSCharacterSet *special = [NSCharacterSet characterSetWithCharactersInString:@"/+-() "];
    return [[input componentsSeparatedByCharactersInSet:special] componentsJoinedByString:@""];
}


#pragma mark - validate fields
+ (BOOL)validateCardNumber:(NSString *)cardNumber
                       cvv:(NSString *)cvv
            expirationDate:(NSString *)expirationDate
                  viewType:(CardDetailViewType) viewType
            viewController:(UIViewController *)viewController {
    if([cardNumber isEmpty] || [cvv isEmpty] || [expirationDate isEmpty]) {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil) viewController:viewController];
        return NO;
    }
    return [[self class] validateExpirationDate:expirationDate viewController:viewController] &&
    [[self class] validateCardNumber:cardNumber viewType:viewType viewController:viewController] &&
    [[self class] validateCvv:cvv viewController:viewController];
}

+ (BOOL)validateCvv:(NSString *)cvv viewController:(UIViewController *)viewController{
    if(cvv.length == 3 || cvv.length == 4) {
        return YES;
    }
    [self displayAlertWithMessage:NSLocalizedString(@"invalidCvvError", nil) viewController:viewController];
    return NO;
}

+ (BOOL)validateCardNumber:(NSString *)cardNumber
                  viewType:(CardDetailViewType)viewType
            viewController:(UIViewController *)viewController {
    if(cardNumber.length == 19 || viewType == EditCard) {
        return YES;
    }
    [self displayAlertWithMessage:NSLocalizedString(@"invalidCardNumberError", nil) viewController:viewController];
    return NO;
}

+ (BOOL)validateExpirationDate:(NSString *)expirationDate viewController:(UIViewController *)viewController {
    NSArray *components = [expirationDate componentsSeparatedByString:@"/"];
    if([components count] < 2) {
        [self displayAlertWithMessage:NSLocalizedString(@"invalidExpirationDateError", nil) viewController:viewController];
        return NO;
    }
    NSString *stringDate = [NSString stringWithFormat:@"%@/20%@",components[0], components[1]];
    NSDate *dateTovalidate = [[self class] getDateFromString:stringDate];
    NSDate *currenDate = [[self class]getDateFromString:[[self class] getDateFromFormat:@"MM/yyyy"]];
    if(currenDate > dateTovalidate) {
        [self displayAlertWithMessage:NSLocalizedString(@"invalidExpirationDateError", nil) viewController:viewController];
        return NO;
    }
    return YES;
}

+(NSString *)getDateFromFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSDate *)getDateFromString:(NSString *)stringDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/yyyy"];
    return [formatter dateFromString:stringDate];
}

+ (void)displayAlertWithMessage:(NSString *)message viewController:(UIViewController *)viewController {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"errorTitle", nil)
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)getDateFormated:(NSString *)expirationDate {
    NSArray *components = [expirationDate componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@/20%@",components[0], components[1]];
}
@end
