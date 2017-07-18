//
//  BankAccountViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/22/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BankAccountViewController.h"
#import "BottomBorderTextField.h"
#import "BankAccountManager.h"
#import "CoreDataManager.h"

@interface BankAccountViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtUserId;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtBankAccount;

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtUserAccount;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtBank;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (nonatomic, strong) BankAccount *bankAccount;

@end

@implementation BankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"bankInformationTitle", nil);
    [self setupView];
    [self getCommerceBankAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.btnSave.layer.cornerRadius = 20.f;
    self.txtUserId.placeholder = NSLocalizedString(@"userIdentificarionPlaceholder", nil);
    self.txtBankAccount.placeholder = NSLocalizedString(@"accountNumberPlaceholder", nil);
    self.txtUserAccount.placeholder = NSLocalizedString(@"commerceAccountNamePlaceholder", nil);
    self.txtBank.placeholder = NSLocalizedString(@"commerceBankNamePlaceholder", nil);
    [self.btnSave setTitle:NSLocalizedString(@"saveAction", nil) forState:UIControlStateNormal];
    [self setupViewMode];
    [self setupGestures];
}

- (void)setupViewMode {
    BOOL editionEnabled = self.viewMode == ViewBankAccount ? NO : YES;
    self.txtBankAccount.userInteractionEnabled = editionEnabled;
    self.txtUserId.userInteractionEnabled = editionEnabled;
    self.txtUserAccount.userInteractionEnabled = editionEnabled;
    self.txtBank.userInteractionEnabled = editionEnabled;
    self.btnSave.hidden = !editionEnabled;
    if(self.viewMode == ViewBankAccount) {
        [self addNavigationBarButton];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)addNavigationBarButton {
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"editAction", nil)
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = @[editButton];
    self.navigationItem.leftBarButtonItem = nil;
    
}

#pragma mark - actions
- (void)getCommerceBankAccount {
    BankAccountManager *manager = [[BankAccountManager alloc] init];
    [manager getAccountByUserFromServer:self.user.id
                                  token:self.user.token
                         successHandler:^(id response) {
                             if(response == nil || [response count] == 0) {
                                 self.viewMode = AddBankAccount;
                                 [self setupViewMode];
                             } else {
                                 self.bankAccount =
                                    [BankAccountManager createBankAccountFromDictionary:[response firstObject]];
                                 self.txtBankAccount.text = self.bankAccount.accountNumber;
                                 self.txtUserId.text = self.bankAccount.userIdentification;
                                 self.txtUserAccount.text = self.bankAccount.userAccount;
                                 self.txtBank.text = self.bankAccount.bank;
                             }
                         } failureHandler:^(id response) {
                             NSLog(@"Error getting Bank Account %@", response);
                         }];
}

- (void)editAction {
    self.viewMode = EditBankAccount;
    [self setupViewMode];
}

- (IBAction)saveBankAccount:(id)sender {
    if ([self isDataValid]) {
        self.bankAccount = self.bankAccount == nil ? [CoreDataManager createEntityWithName:@"BankAccount"] : self.bankAccount;
        self.bankAccount.userIdentification = self.txtUserId.text;
        self.bankAccount.accountNumber = self.txtBankAccount.text;
        self.bankAccount.userAccount = self.txtUserAccount.text;
        self.bankAccount.bank = self.txtBank.text;
        self.bankAccount.user = self.user;
        if (self.viewMode == AddBankAccount) {
            [self saveBankAccount];
        } else{
            [self updateBankAccount];
        }
    } else {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
    }

}

- (void)saveBankAccount {
    BankAccountManager *manager = [[BankAccountManager alloc] init];
    [manager registerAccount:self.bankAccount
                     token:self.user.token
            successHandler:^(id response) {
                self.viewMode = ViewBankAccount;
                [self setupViewMode];
            } failureHandler:^(id response) {
                NSLog(@"Error updating Bank Account %@", response);
            }
     ];
    
}

- (void)updateBankAccount {
    BankAccountManager *manager = [[BankAccountManager alloc] init];
    [manager updateAccount:self.bankAccount
                     token:self.user.token
            successHandler:^(id response) {
                self.viewMode = ViewBankAccount;
                [self setupViewMode];
            } failureHandler:^(id response) {
                NSLog(@"Error updating Bank Account %@", response);
            }
     ];
}

#pragma mark - validate data
- (BOOL)isDataValid {
    return [self.txtUserId hasText] && [self.txtBankAccount hasText] && [self.txtUserAccount hasText] &&
    [self.txtBank hasText];
}

- (void)displayAlertWithMessage:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"errorTitle", nil)
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
