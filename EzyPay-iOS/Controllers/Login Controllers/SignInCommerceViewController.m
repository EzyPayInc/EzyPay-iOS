//
//  SignInCommerceViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SignInCommerceViewController.h"
#import "UserServiceClient.h"
#import "SignInPaymentInformationControllerViewController.h"
#import "User+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NSString+String.h"
#import "NavigationController.h"
#import "BottomBorderTextField.h"

@interface SignInCommerceViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtTables;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@property (nonatomic, strong) NSArray *userTypePickerData;

@end

@implementation SignInCommerceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setTextFieldDelegate];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.btnNext.layer.cornerRadius = 20.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTextFieldDelegate {
    self.txtName.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtTables.delegate = self;
}

- (void)saveUser {
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = self.txtName.text;
    user.lastName = nil;
    user.phoneNumber = self.txtPhoneNumber.text;
    user.email = self.txtEmail.text;
    user.userType = [self.txtTables.text integerValue] > 0 ? RestaurantNavigation : CommerceNavigation;
    user.password = self.txtPassword.text;
    
    SignInPaymentInformationControllerViewController *viewController = (SignInPaymentInformationControllerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInPaymentInformationControllerViewController"];
    viewController.user = user;
    viewController.tables = [self.txtTables.text integerValue];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)nextAction:(id)sender {
    [self saveUser];
}

@end
