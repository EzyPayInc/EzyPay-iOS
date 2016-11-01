//
//  SignInUserViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInUserViewController.h"
#import "UserServiceClient.h"

@interface SignInUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtCardnumber;
@property (strong, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;

@end

@implementation SignInUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Sign In";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUserAction:(id)sender {
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
    [userDictionary setValue:self.txtUserName.text forKey:@"name"];
    [userDictionary setValue:self.txtLastname.text forKey:@"lastname"];
    [userDictionary setValue:self.txtPhoneNumber.text forKey:@"phoneNumber"];
    [userDictionary setValue:self.txtEmail.text forKey:@"email"];
    [userDictionary setValue:self.txtPassword.text forKey:@"password"];
    [userDictionary setValue:self.txtCardnumber.text forKey:@"cardNumber"];
    [userDictionary setValue:self.txtCvv.text forKey:@"cvv"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d.M.yyyy";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [userDictionary setValue:date forKey:@"expirationDate"];
    
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service registerUser:userDictionary withSuccessHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"Error message: %@", error);
        } else {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([response valueForKey:@"message"]) {
                [self showServerMessage:[response valueForKey:@"mesage"]];
            } else {
                [self showServerMessage:@"Success"];
            }
        }
    }];

}

- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
