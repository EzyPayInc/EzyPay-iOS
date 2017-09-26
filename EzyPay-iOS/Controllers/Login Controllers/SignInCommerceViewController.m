//
//  SignInCommerceViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SignInCommerceViewController.h"
#import "UserServiceClient.h"
#import "SignInCommerceImageViewController.h"
#import "User+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NSString+String.h"
#import "NavigationController.h"
#import "BottomBorderTextField.h"
#import "PhoneCodesTableViewController.h"
#import "LoadingView.h"

@interface SignInCommerceViewController ()<UITextFieldDelegate, PhoneCodesDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtPhoneCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@property (nonatomic, strong) NSArray *userTypePickerData;

@end

@implementation SignInCommerceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setupView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupView {
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backLabel", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:nil action:nil];
    self.txtName.placeholder = NSLocalizedString(@"namePlaceholder", nil);
    self.txtPhoneNumber.placeholder = NSLocalizedString(@"phoneNumberPlaceholder", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    self.txtPhoneCode.placeholder = @"+1";
    [self.btnNext setTitle:NSLocalizedString(@"nextAction", nil) forState:UIControlStateNormal];
    [self setTextFieldDelegate];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.btnNext.layer.cornerRadius = 20.f;
    [self setupGestures];
}

- (void)setTextFieldDelegate {
    self.txtName.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtPhoneCode.delegate = self;
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
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = self.txtName.text;
    user.lastName = nil;
    user.phoneNumber = [NSString stringWithFormat:@"%@ %@",
                        self.txtPhoneCode.text, self.txtPhoneNumber.text];
    user.email = self.txtEmail.text;
    user.password = self.txtPassword.text;
    
    SignInCommerceImageViewController *viewController = (SignInCommerceImageViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInCommerceImageViewController"];
    viewController.user = user;
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isEqual:self.txtPhoneCode]) {
        PhoneCodesTableViewController *viewController = (PhoneCodesTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneCodesTableViewController"];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:true];
        return false;
    }
    return true;
}

- (IBAction)nextAction:(id)sender {
    if([self isDataValidated]) {
        [self validateUserEmail:self.txtEmail.text];
    }
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
    return [self.txtName hasText]  && [self.txtPhoneNumber hasText]
    && [self.txtEmail hasText] && [self.txtPassword hasText]
    && [self.txtPhoneCode hasText];
}


- (BOOL)isEmailValidated {
    return [self.txtEmail.text isValidEmail];
}

- (BOOL)isPasswordValidated {
    return self.txtPassword.text.length > 4;
}

- (void)validateUserEmail:(NSString*) email {
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager validateUserEmail:email
                successHandler:^(id response) {
                    [LoadingView dismiss];
                    if([[response objectForKey:@"user"] integerValue] == 0) {
                        [self saveUser];
                    } else {
                        [self displayAlertWithMessage:NSLocalizedString(@"errorEmailAlreadyAssigned", nil)];
                    }
                } failureHandler:^(id response) {
                    [LoadingView dismiss];
                    [self displayAlertWithMessage:NSLocalizedString(@"errorEmailErrorRequest", nil)];
                }];
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

- (void)didTapOnCode:(NSString *)phoneCode {
    self.txtPhoneCode.text = phoneCode;
}

@end
