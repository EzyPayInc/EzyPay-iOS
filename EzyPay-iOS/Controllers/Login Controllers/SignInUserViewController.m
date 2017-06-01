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
#import "User+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NSString+String.h"
#import "NavigationController.h"

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.txtUserName.placeholder = NSLocalizedString(@"namePlaceholder", nil);
    self.txtLastname.placeholder = NSLocalizedString(@"lastNamePlaceholder", nil);
    self.txtPhoneNumber.placeholder = NSLocalizedString(@"phoneNumberPlaceholder", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    [self.btnNext setTitle:NSLocalizedString(@"nextAction", nil) forState:UIControlStateNormal];
    [self setTextFieldDelegate];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.btnNext.layer.cornerRadius = 20.f;
}

- (void)setTextFieldDelegate {
    self.txtUserName.delegate = self;
    self.txtLastname.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)saveUser {
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = self.txtUserName.text;
    user.lastName = self.txtLastname.text;
    user.phoneNumber = self.txtPhoneNumber.text;
    user.email = self.txtEmail.text;
    user.userType = UserNavigation;
    user.password = self.txtPassword.text;
    
    SignInPaymentInformationControllerViewController *viewController = (SignInPaymentInformationControllerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInPaymentInformationControllerViewController"];
    viewController.user = user;
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveAction:(id)sender {
    [self saveUser];
}

/*- (BOOL)validateFields {
    if([self validateEmptyFields:self.txtUserName withLabel:self.labelNameError] &&
       [self validateEmptyFields:self.txtLastname withLabel:self.labelLastNameError] &&
       [self validateEmptyFields:self.txtPhoneNumber withLabel:self.labelPhoneNumberError] &&
       [self validateEmptyFields:self.txtEmail withLabel:self.labelEmailError] &&
       [self validateEmptyFields:self.txtPassword withLabel:self.labelPasswordError]) {
        if ([self isValidEmail] && [self isValidPassword]) {
            return true;
        }
    }
    return false;
}

- (BOOL)validateEmptyFields:(UITextField *)textField withLabel:(UILabel *)labelError {
    if (![textField hasText]) {
        labelError.text = NSLocalizedString(@"errorFieldRequired", nil);
        return false;
    } else {
        labelError.text = @"";
        return true;
    }
}

- (BOOL)isValidEmail {
    if(![self.txtEmail.text isValidEmail]) {
        self.labelEmailError.text = NSLocalizedString(@"errorEmailInvalid", nil);
        return false;
    } else {
        self.labelEmailError.text = @"";
        return true;

    }
}

- (BOOL)isValidPassword {
    if(self.txtPassword.text.length < 5) {
        self.labelPasswordError.text = NSLocalizedString(@"errorPasswordInvalid", nil);
        return false;
    } else {
        self.labelPasswordError.text = @"";
        return true;
    }
}*/

@end
