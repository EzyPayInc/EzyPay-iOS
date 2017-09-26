//
//  SignInPaymentInformationControllerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInPaymentInformationControllerViewController.h"
#import "CardServiceClient.h"
#import "UserManager.h"
#import "CardManager.h"
#import "Card+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NavigationController.h"
#import "DeviceTokenManager.h"
#import "ValidateCardInformationHelper.h"
#import <CardIO.h>
#import "CardDetailViewController.h"
#import "Credentials+CoreDataClass.h"
#import "LoadingView.h"

@interface SignInPaymentInformationControllerViewController ()<UITextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtExpirationDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSingUp;

@end

@implementation SignInPaymentInformationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setupView];
    [self.txtExpirationDate addTarget:self action:@selector(creditCardExpiryFormatter:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - actions
- (void)setupView {
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backLabel", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:nil action:nil];
    self.txtExpirationDate.delegate = self;
    self.txtCardNumber.delegate = self;
    self.txtCvv.delegate = self;
    self.btnSingUp.layer.cornerRadius = 20.f;
    self.txtCardNumber.placeholder = NSLocalizedString(@"cardNumberPlaceholder", nil);
    self.txtExpirationDate.placeholder = NSLocalizedString(@"expirationDatePlaceholder", nil);
    self.txtCvv.placeholder = NSLocalizedString(@"cvvPlaceholder", nil);
    [self.btnSingUp setTitle:NSLocalizedString(@"signUpAction", nil) forState:UIControlStateNormal];
    [self addScanAction];
    [self setupGestures];
}

- (void)addScanAction {
    
    UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_micro_camera"]];
    cameraIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.txtCardNumber.rightViewMode = UITextFieldViewModeAlways;
    self.txtCardNumber.rightView = cameraIcon;
    self.txtCardNumber.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scanGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(scanCardAction)];
    [self.txtCardNumber.rightView addGestureRecognizer:scanGesture];
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}


- (IBAction)registerUser:(id)sender {
    if([ValidateCardInformationHelper validateCardNumber:self.txtCardNumber.text
                                                     cvv:self.txtCvv.text
                                          expirationDate:self.txtExpirationDate.text
                                                viewType:AddCard
                                          viewController:self]) {
        [self saveUser];
    }
}

- (void)saveUser {
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:self.user
                   tables: self.tables
           successHandler:^(id response) {
               int64_t userId = (long)[[response valueForKey:@"userId"] integerValue];
               self.user.id = userId;
               self.user.customerId = [[response valueForKey:@"customerId"] integerValue];
               [self login];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        [self showServerMessage:NSLocalizedString(@"errorEmailAlreadyAssigned", nil)];
        NSLog(@"Error: %@", response);
    }];
}

- (void)login {
    UserManager *manager = [[UserManager alloc] init];
    NSString *scope = self.user.credential ? self.user.credential.platform : nil;
    NSString *platformToken = self.user.credential ? self.user.credential.platformToken : nil;
    NSString *password = (self.user.password && self.user.password.length > 0 ) ?
        self.user.password : self.user.credential.credential;
    [manager login:self.user.email password:password scope:scope platformToken:platformToken successHandler:^(id response) {
        NSDictionary *accessToken = [response valueForKey:@"access_token"];
        NSString *token = [accessToken valueForKey:@"value"];
        self.user.token = token;
        self.user.id = [[accessToken valueForKey:@"userId"] integerValue];
        [self saveCard];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Error: %@", response);
    }];
}

- (void)saveCard {
    Card *card = [CoreDataManager createEntityWithName:@"Card"];
    card.cardNumber = self.txtCardNumber.text;
    card.ccv = [self.txtCvv.text integerValue];
    card.expirationDate = [ValidateCardInformationHelper getDateFormated:self.txtExpirationDate.text];
    card.user = self.user;
    CardManager *manager = [[CardManager alloc] init];
    [manager registerCard:card user:self.user successHandler:^(id response) {
        [LoadingView dismiss];
        [self.user addCardsObject:card];
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = self.user.userType;
        [navigationController presentTabBarController:self
                                   withNavigationType:self.user.userType
                                             withUser:self.user];
        [self registerToken:self.user];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Error: %@", response);
    }];
}

- (void)creditCardExpiryFormatter:(id)sender {
    [ValidateCardInformationHelper creditCardExpiryFormatter:self.txtExpirationDate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField isEqual:self.txtExpirationDate]){
        return [ValidateCardInformationHelper validateExpirationDate:textField
                                       shouldChangeCharactersInRange:range
                                                              string:string];
    } else if ([textField isEqual:self.txtCvv]) {
        return [ValidateCardInformationHelper validateCvvValue:textField string:string];
    } else if ([textField isEqual:self.txtCardNumber]){
        return [ValidateCardInformationHelper validateCardNumberValue:textField
                                        shouldChangeCharactersInRange:range
                                                               string:string];
    }
    return YES;
}


+ (BOOL)isNumeric:(NSString *)string {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [numberFormatter numberFromString:string];
    if (number != nil) {
        return YES;
    }
    return NO;
}

- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scanCardAction {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    scanViewController.hideCardIOLogo = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
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

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.txtCardNumber.text = [ValidateCardInformationHelper setCardNumberFormat:[NSMutableString stringWithFormat:@"%@", info.cardNumber]];
    NSString *year = [[NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear]
                      substringWithRange:NSMakeRange(2, 2)];
    self.txtExpirationDate.text = [NSString stringWithFormat:@"%02lu/%@",
                                   (unsigned long)info.expiryMonth, year];
    self.txtCvv.text = info.cvv;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
