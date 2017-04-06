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

@interface SignInCommerceViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUserType;
@property (weak, nonatomic) IBOutlet UIPickerView *userTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtTables;

@property (nonatomic, strong) NSArray *userTypePickerData;

@end

@implementation SignInCommerceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setTextFieldDelegate];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.userTypePickerData = @[@"Restaurant", @"Commerce"];
    self.userTypePicker.showsSelectionIndicator = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self closePicker];
}

- (void)setTextFieldDelegate {
    self.txtName.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtUserType.delegate = self;
}

- (void)saveUser {
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = self.txtName.text;
    user.lastName = nil;
    user.phoneNumber = self.txtPhoneNumber.text;
    user.email = self.txtEmail.text;
    if([self.txtUserType.text isEqualToString:@"Restaurant"]) {
         user.userType = RestaurantNavigation;
    } else {
        user.userType = CommerceNavigation;
    }
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

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual:self.txtUserType]) {
        [self showPicker];
        [textField resignFirstResponder];
    } else {
        [self closePicker];
    }
}

- (IBAction)nextAction:(id)sender {
    [self saveUser];
}

#pragma mark - Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.userTypePickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.userTypePickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.txtUserType.text = self.userTypePickerData[row];
    [self closePicker];
}

- (void)showPicker {
    self.userTypePicker.hidden = NO;
}

- (void)closePicker {
    self.userTypePicker.hidden = YES;
 
}

@end
