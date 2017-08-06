//
//  SignInUserViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInUserViewController.h"
#import "UserServiceClient.h"
#import "SignInPaymentInformationControllerViewController.h"
#import "CoreDataManager.h"
#import "NSString+String.h"
#import "NavigationController.h"
#import "LoginViewController.h"

@interface SignInUserViewController ()<UITextFieldDelegate>

/*UI fields*/
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation SignInUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setupView];
    self.user = self.user ? self.user : [CoreDataManager createEntityWithName:@"User"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupView {
    self.navigationController.navigationBar.topItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backLabel", nil)
                                         style:UIBarButtonItemStylePlain
                                         target:nil action:nil];
    self.txtUserName.placeholder = NSLocalizedString(@"namePlaceholder", nil);
    self.txtLastname.placeholder = NSLocalizedString(@"lastNamePlaceholder", nil);
    self.txtPhoneNumber.placeholder = NSLocalizedString(@"phoneNumberPlaceholder", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    [self.btnNext setTitle:NSLocalizedString(@"nextAction", nil) forState:UIControlStateNormal];
    [self setTextFieldDelegate];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.btnNext.layer.cornerRadius = 20.f;
    [self setupGestures];
    [self validateFields];
}


- (void)setTextFieldDelegate {
    self.txtUserName.delegate = self;
    self.txtLastname.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)validateFields {
    if(self.user) {
        self.txtUserName.userInteractionEnabled = NO;
        self.txtLastname.userInteractionEnabled = NO;
        self.txtPhoneNumber.userInteractionEnabled = YES;
        self.txtEmail.userInteractionEnabled = NO;
        
        self.txtUserName.text = self.user.name;
        self.txtLastname.text = self.user.lastName;
        self.txtEmail.text = self.user.email;
        
        self.txtPassword.hidden = YES;
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

- (void)saveUser {
    if([self isDataValidated]) {
        self.user.name = self.txtUserName.text;
        self.user.lastName = self.txtLastname.text;
        self.user.phoneNumber = self.txtPhoneNumber.text;
        self.user.email = self.txtEmail.text;
        self.user.userType = UserNavigation;
        self.user.password = self.txtPassword.text;
    
        SignInPaymentInformationControllerViewController *viewController = (SignInPaymentInformationControllerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInPaymentInformationControllerViewController"];
        viewController.user = self.user;
        viewController.tables = 0;
        [self.navigationController pushViewController:viewController animated:true];
    }
}


#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveAction:(id)sender {
    [self saveUser];
}


#pragma mark - validate Data
- (BOOL)isDataValidated {
    if(![self areFieldsFilled]) {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
        return false;
    } else if (![self isEmailValidated]) {
        [self displayAlertWithMessage:NSLocalizedString(@"errorEmailInvalid", nil)];
        return false;
    } else if (![self isPasswordValidated]) {
        [self displayAlertWithMessage:NSLocalizedString(@"errorPasswordInvalid", nil)];
        return false;
    }
    
    return YES;
}

- (BOOL)areFieldsFilled {
    return [self.txtUserName hasText] && [self.txtLastname hasText] && [self.txtPhoneNumber hasText]
        && [self.txtEmail hasText] && ([self.txtPassword hasText] || self.txtPassword.hidden);
}


- (BOOL)isEmailValidated {
    return [self.txtEmail.text isValidEmail];
}

- (BOOL)isPasswordValidated {
    return (self.txtPassword.text.length > 4 || self.txtPassword.hidden);
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
