//
//  SettingsPaswwordViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 9/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SettingsPaswwordViewController.h"
#import "UserManager.h"
#import "LoadingView.h"

@interface SettingsPaswwordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation SettingsPaswwordViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.txtNewPassword.placeholder = NSLocalizedString(@"newPasswordPlaceholder", nil);
    [self.btnSave setTitle:NSLocalizedString(@"saveAction", nil) forState:UIControlStateNormal];
}

- (IBAction)changePassword:(id)sender {
    NSString * newPassword = self.txtNewPassword.text;
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager updatePassword:newPassword
                       user:self.user
             successHandler:^(id response) {
                 [LoadingView dismiss];
                 [self.navigationController popViewControllerAnimated:YES];
             } failureHandler:^(id response) {
                 NSLog(@"New Password");
             }];
    
}



@end
