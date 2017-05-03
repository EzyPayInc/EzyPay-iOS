//
//  SignInPaymentInformationControllerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInPaymentInformationControllerViewController.h"
#import "DropDownTableViewController.h"
#import "CardServiceClient.h"
#import "UserManager.h"
#import "CardManager.h"
#import "Card+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NavigationController.h"
#import "DeviceTokenManager.h"

@interface SignInPaymentInformationControllerViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtExpirationDate;

@end

@implementation SignInPaymentInformationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    self.txtExpirationDate.delegate = self;
    self.txtCardNumber.delegate = self;
    self.txtCvv.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)registerUser:(id)sender {
    [self saveUser];
}

- (void)saveUser {
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:self.user successHandler:^(id response) {
        int64_t userId = (long)[[response valueForKey:@"userId"] integerValue];
        self.user.id = userId;
        [self login];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)login {
    UserManager *manager = [[UserManager alloc] init];
    [manager login:self.user.email password:self.user.password successHandler:^(id response) {
        NSDictionary *accessToken = [response valueForKey:@"access_token"];
        NSString *token = [accessToken valueForKey:@"value"];
        self.user.token = token;
        self.user.id = [[accessToken valueForKey:@"userId"] integerValue];
        [self saveCard];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)saveCard {
    Card *card = [CoreDataManager createEntityWithName:@"Card"];
    card.number = [self.txtCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    card.cvv = [self.txtCvv.text integerValue];
    NSString *expirationDate = self.txtExpirationDate.text;
    card.month = [[[expirationDate componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
    card.year = [[[expirationDate componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
    card.user = self.user;
    CardManager *manager = [[CardManager alloc] init];
    [manager registerCard:card token:self.user.token successHandler:^(id response) {
        [self.user addCardsObject:card];
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = self.user.userType;
        [navigationController presentTabBarController:self
                                   withNavigationType:self.user.userType
                                             withUser:self.user];
        [self registerToken:self.user];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.txtExpirationDate]){
        return [self validateExpirationDate:textField string:string];
    } else if ([textField isEqual:self.txtCvv]) {
        return [self validateCvvValue:textField string:string];
    } else if ([textField isEqual:self.txtCardNumber]){
        return [self validateCardNumberValue:textField string:string];
    }
    return YES;
}

- (BOOL)validateExpirationDate:(UITextField *)textField string:(NSString *)string {
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
            self.txtExpirationDate.text = [NSString stringWithFormat:@"0%@/",expirationDate];
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateCvvValue:(UITextField *)textField string:(NSString *)string {
    NSString *cvvString = [textField.text stringByAppendingString:string];
    return cvvString.length > 3? NO : YES;
}

- (BOOL)validateCardNumberValue:(UITextField *)textField string:(NSString *)string {
    NSString *cardNumber = [textField.text stringByAppendingString:string];
    if (cardNumber.length < 20){
        if([cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""].length % 4 == 0 && string.length > 0){
            textField.text = [cardNumber stringByAppendingString:@" "];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)isNumeric:(NSString *)string {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [numberFormatter numberFromString:string];
    if (number != nil) {
        return YES;
    }
    return NO;
}


- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - registerToken
- (void)registerToken:(User *)user {
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    if(localToken != nil && localToken.isSaved == 0){
        DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
        [manager registerDeviceToken:localToken user:user successHandler:^(id response) {
            localToken.isSaved = 1;
            [CoreDataManager saveContext];
        } failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
}
@end
