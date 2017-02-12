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
#import "GeneralServiceClient.h"
#import "UserServiceClient.h"
#import "UserManager.h"
#import "User+CoreDataClass.h"
#import "NavigationController.h"
#import "CoreDataManager.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, assign) BOOL keyboardisActive;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"logInTitle", nil);
    self.txtPassword.delegate = self;
    self.txtEmail.delegate = self;
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
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = newFrame;
                     }
                     completion:nil];
}

- (IBAction)showSignInView:(id)sender {
    SignInUserViewController *signInUserViewController = (SignInUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInUserViewController"];
    [self.navigationController pushViewController:signInUserViewController animated:true];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    NSString *email = self.txtEmail.text;
    NSString *password = self.txtPassword.text;
    
    UserManager *manager = [[UserManager alloc] init];
    [manager login:email password:password successHandler:^(id response) {
        NSDictionary *accessToken = [response valueForKey:@"access_token"];
        int64_t id = (long)[[accessToken valueForKey:@"userId"] integerValue];
        NSString *token = [accessToken valueForKey:@"value"];
        [self getUserFromServer:id token:token];
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
    
}

- (void) getUserFromServer:(int64_t ) userId token:(NSString *)token {
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:userId token:token successHandler:^(id response) {
        User *user = [UserManager userFromDictionary:response];
        user.id = userId;
        user.token = token;
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = UserNavigation;
        [navigationController presentTabBarController:self];
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
}



@end
