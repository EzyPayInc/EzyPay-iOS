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

@interface SignInUserViewController ()

/*UI fields*/
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelNameError;
@property (weak, nonatomic) IBOutlet UILabel *labelLastNameError;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumberError;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailError;
@property (weak, nonatomic) IBOutlet UILabel *labelPasswordError;

@end

@implementation SignInUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"signInNextAction", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveUser)];
    self.navigationItem.rightBarButtonItem = refreshItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveUser {
    if([self validateFields]) {
        User *user = [CoreDataManager createEntityWithName:@"User"];
        user.name = self.txtUserName.text;
        user.lastName = self.txtLastname.text;
        user.phoneNumber = self.txtPhoneNumber.text;
        user.email = self.txtEmail.text;
        user.password = self.txtPassword.text;
        
        SignInPaymentInformationControllerViewController *viewController = (SignInPaymentInformationControllerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInPaymentInformationControllerViewController"];
        viewController.user = user;
        [self.navigationController pushViewController:viewController animated:true];
    }
}

- (BOOL)validateFields {
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
}

@end
