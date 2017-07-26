//
//  SignInBankAccountViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/19/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SignInBankAccountViewController.h"
#import "BottomBorderTextField.h"
#import "CoreDataManager.h"
#import "BankAccountManager.h"
#import "NavigationController.h"
#import "DeviceTokenManager.h"

@interface SignInBankAccountViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtUserId;

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtBankAccount;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtBank;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation SignInBankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.navigationItem.title = NSLocalizedString(@"bankInformationTitle", nil);
    self.txtBankAccount.placeholder = NSLocalizedString(@"accountNumberPlaceholder", nil);
    self.txtUserId.placeholder = NSLocalizedString(@"userIdentificarionPlaceholder", nil);
    self.txtUsername.placeholder = NSLocalizedString(@"commerceAccountNamePlaceholder", nil);
    self.txtBank.placeholder = NSLocalizedString(@"commerceBankNamePlaceholder", nil);
    [self.btnSave setTitle:NSLocalizedString(@"signInTitle", nil) forState:UIControlStateNormal];
    
    self.txtBankAccount.delegate = self;
    self.txtUserId.delegate = self;
    
    self.btnSave.layer.cornerRadius = 20.f;
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - actions
- (IBAction)saveUserAction:(id)sender {
    [self saveUser];
}

- (void)saveUser {
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:self.user
                   tables: self.tables
           successHandler:^(id response) {
               int64_t userId = (long)[[response valueForKey:@"id"] integerValue];
               self.user.id = userId;
               [self login];
           } failureHandler:^(id response) {
               NSLog(@"Error: %@", response);
           }];
}

- (void)login {
    UserManager *manager = [[UserManager alloc] init];
    [manager login:self.user.email password:self.user.password scope: nil successHandler:^(id response) {
        NSDictionary *accessToken = [response valueForKey:@"access_token"];
        NSString *token = [accessToken valueForKey:@"value"];
        self.user.token = token;
        self.user.id = [[accessToken valueForKey:@"userId"] integerValue];
        [self saveImage];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)saveImage {
    if(self.commerceLogo != nil){
        UserManager *manager = [[UserManager alloc] init];
        [manager uploadUserImage: self.commerceLogo User:self.user successHandler:^(id response) {
            [self saveBankAccount];
        } failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
    
}

- (void)saveBankAccount {
    BankAccount *account = [CoreDataManager createEntityWithName:@"BankAccount"];
    account.userIdentification = self.txtUserId.text;
    account.accountNumber = self.txtBankAccount.text;
    account.userAccount = self.txtUsername.text;
    account.bank = self.txtBank.text;
    account.user = self.user;
    BankAccountManager *manager = [[BankAccountManager alloc] init];
    [manager registerAccount:account
                       token:self.user.token
              successHandler:^(id response) {
                  self.user.bankAccount = account;
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

#pragma mark - registerToken
- (void)registerToken:(User *)user {
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    if(localToken != nil && localToken.isSaved == 0){
        DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
        [manager registerDeviceToken:localToken
                                user:user
                      successHandler:^(id response) {
            localToken.isSaved = 1;
            [CoreDataManager saveContext];
        }
                      failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
}


@end
