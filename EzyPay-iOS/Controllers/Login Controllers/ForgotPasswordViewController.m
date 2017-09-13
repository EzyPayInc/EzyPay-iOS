//
//  ForgotPasswordViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 9/4/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "BottomBorderTextField.h"
#import "UserManager.h"
#import "LoadingView.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;


@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequestAction:(id)sender {
    NSString *email = self.txtEmail.text;
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager forgotPassword:email
             successHandler:^(id response) {
                 [LoadingView dismiss];
                 [self.navigationController popViewControllerAnimated:YES];
             } failureHandler:^(id response) {
                 [LoadingView dismiss];
                 NSLog(@"Error: %@", response);
             }];
}

@end
