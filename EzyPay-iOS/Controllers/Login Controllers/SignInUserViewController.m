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

@interface SignInUserViewController ()

/*UI fields*/
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (nonatomic, strong) NSMutableDictionary *userDictionary;

@end

@implementation SignInUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Sign In";
    self.userDictionary = [NSMutableDictionary dictionary];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUserAction:(id)sender {
    [self.userDictionary setValue:self.txtUserName.text forKey:@"name"];
    [self.userDictionary setValue:self.txtLastname.text forKey:@"lastname"];
    [self.userDictionary setValue:self.txtPhoneNumber.text forKey:@"phoneNumber"];
    [self.userDictionary setValue:self.txtEmail.text forKey:@"email"];
    
    SignInPaymentInformationControllerViewController *viewController = (SignInPaymentInformationControllerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInPaymentInformationControllerViewController"];
    //NSString *idUser = [response valueForKey:@"response"];
    //[self.userDictionary setValue:idUser forKey:idUser];
    viewController.idUser = @"1";
    [self.navigationController pushViewController:viewController animated:true];
    
    //UserServiceClient *service = [[UserServiceClient alloc] init];
    /*[service registerUser:self.userDictionary withSuccessHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"Error message: %@", error);
        } else {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([response valueForKey:@"message"]) {
                [self showServerMessage:[response valueForKey:@"mesage"]];
            } else {
     
            }
        }
    }];*/

}

- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
