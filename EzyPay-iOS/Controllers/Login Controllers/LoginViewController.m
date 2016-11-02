//
//  LoginViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/26/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "SessionHandler.h"
#import "SignInUserViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, assign) BOOL keyboardisActive;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Log In";
    self.txtPassword.delegate = self;
    self.txtEmail.delegate = self;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if(!self.keyboardisActive) {
        self.keyboardisActive = YES;
        [self moveView:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height)];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if (self.keyboardisActive) {
        self.keyboardisActive = NO;
        [self moveView:self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height)];
    }
    
}

- (void)moveView:(CGRect) newFrame {
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = newFrame;
                     }
                     completion:nil];
}

- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSignInView:(id)sender {
    SignInUserViewController *signInUserViewController = (SignInUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInUserViewController"];
    [self.navigationController pushViewController:signInUserViewController animated:true];
}

- (IBAction)loginAction:(id)sender {
    NSString *userEmail = self.txtEmail.text;
    NSString *userPassword = self.txtPassword.text;
    NSString *body= [NSString stringWithFormat:@"email=%@&password=%@", userEmail, userPassword];
    if(self.loginType == UserType) {
        SessionHandler *sessionHandler = [[SessionHandler alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000/login"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
        [sessionHandler sendRequestWithRequest:request successHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                NSLog(@"Error message: %@", error);
            } else {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if([response valueForKey:@"message"]) {
                    [self showServerMessage:[response valueForKey:@"message"]];
                } else {
                    [self showServerMessage:@"Success"];
                }
            }
        }];
    }
    
}

- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
