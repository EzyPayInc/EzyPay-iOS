//
//  EmployeeDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/4/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "EmployeeDetailViewController.h"
#import "CoreDataManager.h"
#import "Connection.h"
#import "NavigationController.h"
#import "LoadingView.h"


@interface EmployeeDetailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation EmployeeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"employeeTitle", nil);
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.txtName.placeholder = NSLocalizedString(@"namePlaceholder", nil);
    self.txtLastName.placeholder = NSLocalizedString(@"lastNamePlaceholder", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"userNamePlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    [self.btnSave setTitle:NSLocalizedString(@"saveAction", nil) forState:UIControlStateNormal];
    [self setTextFieldDelegate];
    self.btnSave.layer.cornerRadius = 20.f;
    [self setupGestures];
}


- (void)setTextFieldDelegate {
    self.txtName.delegate = self;
    self.txtLastName.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions
- (IBAction)saveEmployee:(id)sender {
    if(![self isDataValidated]) {
        return;
    }
    [LoadingView show];
    User *employee = [CoreDataManager createEntityWithName:@"User"];
    employee.name = self.txtName.text;
    employee.lastName = self.txtLastName.text;
    employee.email = self.txtEmail.text;
    employee.password = self.txtPassword.text;
    employee.userType = EmployeeNavigation;
    employee.boss = self.user;
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:employee tables:0 successHandler:^(id response) {
        [LoadingView dismiss];
        [self.navigationController popViewControllerAnimated:true];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Error in register employee request %@", response);
    }];
}

#pragma mark - validate Data
- (BOOL)isDataValidated {
    if(![self areFieldsFilled]) {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
        return false;
    } else if (![self isUserNameValidated]) {
        [self displayAlertWithMessage:NSLocalizedString(@"errorUserNameInvalid", nil)];
        return false;
    } else if (![self isPasswordValidated]) {
        [self displayAlertWithMessage:NSLocalizedString(@"errorPasswordInvalid", nil)];
        return false;
    }
    
    return YES;
}

- (BOOL)areFieldsFilled {
    return [self.txtName hasText] && [self.txtLastName hasText]
    && [self.txtEmail hasText] && [self.txtPassword hasText];
}


- (BOOL)isUserNameValidated {
    return self.txtEmail.text.length > 4;
}

- (BOOL)isPasswordValidated {
    return self.txtPassword.text.length > 4;
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
