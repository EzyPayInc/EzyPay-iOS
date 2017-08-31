//
//  EditablePhoneViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 8/30/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "EditablePhoneViewController.h"
#import "BottomBorderTextField.h"
#import "PhoneCodesTableViewController.h"

@interface EditablePhoneViewController ()<UITextFieldDelegate, PhoneCodesDelegate>

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtPhoneCode;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation EditablePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)setupView {
    self.txtPhoneCode.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtPhoneNumber.placeholder = NSLocalizedString(@"phoneNumberPlaceholder", nil);
    self.txtPhoneCode.placeholder = @"+1";
    [self.btnSubmit setTitle:NSLocalizedString(@"saveAction", nil) forState:UIControlStateNormal];
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)submitAction:(id)sender {
    if([self isDataValid]) {
        NSString *phoneNumber = [NSString stringWithFormat:@"%@ %@",
                                 self.txtPhoneCode.text, self.txtPhoneNumber.text];
        [self.delegate didSavePhone:phoneNumber];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
    }
}

- (BOOL)isDataValid {
    return [self.txtPhoneNumber hasText] && [self.txtPhoneCode hasText];
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

- (void)didTapOnCode:(NSString *)phoneCode {
    self.txtPhoneCode.text = phoneCode;
}



@end
