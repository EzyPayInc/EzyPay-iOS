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
#import "NSString+String.h"
#import "Credentials+CoreDataClass.h"
#import "LoadingView.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, FBSDKLoginButtonDelegate>
    
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, assign) BOOL keyboardisActive;
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UILabel *lblSignUp;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UILabel *forgotLabel;
@property (weak, nonatomic) IBOutlet UIView *googleView;
@property (nonatomic, strong) FBSDKLoginButton *facebookLoginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"logInTitle", nil);
    self.txtPassword.delegate = self;
    self.txtEmail.delegate = self;
    self.btnLogIn.layer.cornerRadius = 20;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self setupView];
    
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

- (void)setupView {
    self.orLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.btnLogIn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    [self.btnLogIn setTitle:NSLocalizedString(@"loginAction", nil) forState:UIControlStateNormal];
    self.orLabel.text = NSLocalizedString(@"orLabel", nil);
    [self setUnderlineText];
    [self setupGestures];
    
    /*Facebook setup*/
    self.facebookLoginButton = [[FBSDKLoginButton alloc] init];
    self.facebookLoginButton.delegate = self;
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email"];
}

- (void)setUnderlineText {
    NSMutableAttributedString *forgotPassword = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"forgotPasswordLabel", nil)];
    [forgotPassword addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[forgotPassword length]}];
    NSMutableAttributedString *noAccount = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"noAccountLabel", nil)];
    NSMutableAttributedString *signUpHere = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"signUpHereLabel", nil)];
    [signUpHere addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:1]
                           range:(NSRange){0,[signUpHere length]}];
    [noAccount appendAttributedString:signUpHere];
    self.forgotLabel.attributedText = forgotPassword;
    self.lblSignUp.attributedText = noAccount;
}

- (void)setupGestures {
    UITapGestureRecognizer *signUpTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(signUpTapLabel:)];
    [self.lblSignUp setUserInteractionEnabled:YES];
    [self.lblSignUp addGestureRecognizer:signUpTapRecognizer];
    
    UITapGestureRecognizer *passTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(forgotPasswordTapLabel:)];
    [self.forgotLabel setUserInteractionEnabled:YES];
    [self.forgotLabel addGestureRecognizer:passTapRecognizer];
    
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)signUpTapLabel:(UITapGestureRecognizer*)sender {
    SignInUserViewController *viewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInUserViewController"];
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)forgotPasswordTapLabel:(UITapGestureRecognizer*)sender {
    ForgotPasswordViewController *viewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if ([self areFieldsFilled]) {
        [LoadingView show];
        NSString *email = self.txtEmail.text;
        NSString *password = self.txtPassword.text;
    
        UserManager *manager = [[UserManager alloc] init];
        [manager login:email password:password scope:nil platformToken:nil successHandler:^(id response) {
            NSDictionary *accessToken = [response valueForKey:@"access_token"];
            int64_t id = (long)[[accessToken valueForKey:@"userId"] integerValue];
            NSString *token = [accessToken valueForKey:@"value"];
            [self getUserFromServer:id token:token];
        } failureHandler:^(id response) {
            [LoadingView dismiss];
            NSLog(@"%@", response);
        }];
    } else {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
    }
    
}

- (void) getUserFromServer:(int64_t ) userId token:(NSString *)token {
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:userId token:token successHandler:^(id response) {
        [LoadingView dismiss];
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
        [LoadingView dismiss];
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

- (void)hideKeyboard {
    [self.view endEditing:YES];
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

#pragma mark - validate data
- (BOOL)areFieldsFilled {
    return ![self.txtEmail.text isEmpty] && ![self.txtPassword.text isEmpty];
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
    NSDictionary *parameters = @{@"fields": @"id, email, first_name, last_name,  picture.type(large)"};
    FBSDKGraphRequest *graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                        parameters:parameters];
    [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error loggin with Facebook %@", error);
            return;
        }
        User *userFromFacebook = [UserManager userFromFacebookLogin:result];
        NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
        userFromFacebook.credential.platformToken = fbAccessToken;
        [self validateCredententialas:userFromFacebook];
    }];
}

- (void)validateCredententialas:(User *)user {
    [LoadingView show];
    NSDictionary *userDictionary = [UserManager userToJson:user];
    UserManager *manager = [[UserManager alloc] init];
    [manager validateCredentialas:userDictionary
                   successHandler:^(id response) {
                       int64_t userId = (long)[[response valueForKey:@"userId"] integerValue];
                       NSString *token = [response valueForKey:@"value"];
                       if(token != nil) {
                           Credentials *credential = user.credential;
                           [self handleUserFacebookResponse:credential
                                                     userId:userId
                                                      token:token];
                       } else {
                           NSLog(@"%@", response);
                           [LoadingView dismiss];
                           SignInUserViewController *viewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInUserViewController"];
                           viewController.user = user;
                           [self.navigationController pushViewController:viewController animated:YES];
                       }
                 } failureHandler:^(id response) {
                     [LoadingView dismiss];
                     NSLog(@"Error validating user");
                   }];
}

- (void)handleUserFacebookResponse:(Credentials *)credential userId:(int64_t)userId token:(NSString *)token {
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:userId token:token successHandler:^(id response) {
        [LoadingView dismiss];
        User *user = [UserManager userFromDictionary:response];
        user.id = userId;
        user.token = token;
        user.credential = credential;
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        [navigationController presentTabBarController:self
                                       withNavigationType:user.userType
                                                 withUser:user];
        [self registerToken:user];
        
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"%@", response);
    }];

}
@end
