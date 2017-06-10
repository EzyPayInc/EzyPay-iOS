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
#import "CoreDataManager.h"
#import "NavigationController.h"
#import "DeviceTokenManager.h"
#import "ChooseViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController ()<UITextFieldDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, assign) BOOL keyboardisActive;
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UILabel *lblSignUp;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UILabel *forgotLabel;
@property (nonatomic, strong) FBSDKLoginButton *facebookLoginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"logInTitle", nil);
    self.txtPassword.delegate = self;
    self.txtEmail.delegate = self;
    self.btnLogIn.layer.cornerRadius = 20;
    UITapGestureRecognizer *signUpTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(signUpTapLabel:)];
    [self.lblSignUp setUserInteractionEnabled:YES];
    [self.lblSignUp addGestureRecognizer:signUpTapRecognizer];
    [self setupView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.facebookLoginButton.frame = self.facebookView.frame;
    [self.view addSubview:self.facebookLoginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView {
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    [self.btnLogIn setTitle:NSLocalizedString(@"loginAction", nil) forState:UIControlStateNormal];
    self.lblSignUp.text = NSLocalizedString(@"signUpHereLabel", nil);
    self.orLabel.text = NSLocalizedString(@"orLabel", nil);
    self.forgotLabel.text = NSLocalizedString(@"forgotPasswordLabel", nil);
    
    /*Facebook setup*/
    self.facebookLoginButton = [[FBSDKLoginButton alloc] init];
    self.facebookLoginButton.delegate = self;
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email"];

}

- (void)signUpTapLabel:(UITapGestureRecognizer*)sender {
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInNavigationViewController"];
    [self presentViewController:navigationController animated:YES completion:nil];

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
        int64_t companyId = [[response objectForKey:@"boss"] integerValue];
        [CoreDataManager saveContext];
        if (user.userType == EmployeeNavigation) {
            [self getUserCompany:user companyId:companyId];
        } else {
            NavigationController *navigationController = [NavigationController sharedInstance];
            [navigationController presentTabBarController:self
                                       withNavigationType:user.userType
                                                 withUser:user];
        }
        [self registerToken:user];
        
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
}

- (void)getUserCompany:(User *)user companyId:(int64_t)companyId {
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:companyId token:user.token successHandler:^(id response) {
        User *company = [UserManager userFromDictionary:response];
        company.id = [[response objectForKey:@"id"] integerValue];
        company.token = nil;
        user.boss = company;
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        [navigationController presentTabBarController:self
                                   withNavigationType:user.userType
                                             withUser:user];
    } failureHandler:^(id response) {
        NSLog(@"Error getting user");
    }];
}


#pragma mark - register Token
- (void)registerToken:(User *)user {
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    if(localToken != nil && localToken.isSaved == 0){
        DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
        [manager registerDeviceToken:localToken user:user successHandler:^(id response) {
            localToken.isSaved = 1;
            [CoreDataManager saveContext];
        } failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
}


#pragma mark - facebook delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    [self fetchFacebookProfile];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

- (void)fetchFacebookProfile {
    NSDictionary *parameters = @{@"fields": @"email, first_name, last_name,  picture.type(large)"};
    FBSDKGraphRequest *graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                        parameters:parameters];
    [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error loggin with Facebook %@", error);
            return;
        }
        NSString *email = result[@"email"];
        NSLog(@"User Email %@", email);
    }];
}

@end
