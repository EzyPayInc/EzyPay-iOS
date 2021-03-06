//
//  LogInCommerceViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "LogInCommerceViewController.h"
#import "BottomBorderTextField.h"
#import "UserManager.h"
#import "NavigationController.h"
#import "CoreDataManager.h"
#import "DeviceTokenManager.h"
#import "LoadingView.h"
#import "ForgotPasswordViewController.h"

@interface LogInCommerceViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BottomBorderTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UILabel *forgotPassLabel;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation LogInCommerceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.btnSignIn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.btnSignUp.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.txtEmail.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"passwordPlaceholder", nil);
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    [self.btnSignIn setTitle:NSLocalizedString(@"loginAction", nil) forState:UIControlStateNormal];
    self.forgotPassLabel.text = NSLocalizedString(@"forgotPasswordLabel", nil);
    self.orLabel.text = NSLocalizedString(@"orLabel", nil);
    [self.btnSignUp setTitle:NSLocalizedString(@"registerCommerceAction", nil) forState:UIControlStateNormal];
    
    self.btnSignIn.layer.cornerRadius = 20.f;
    self.btnSignUp.layer.cornerRadius = 20.f;
    [self setupGestures];
    [self setUnderlineText];
}

- (void)setUnderlineText {
    NSMutableAttributedString *forgotPassword = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"forgotPasswordLabel", nil)];
    [forgotPassword addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:1]
                           range:(NSRange){0,[forgotPassword length]}];
    self.forgotPassLabel.attributedText = forgotPassword;
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
    
    UITapGestureRecognizer *passTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(forgotPasswordTapLabel:)];
    [self.forgotPassLabel setUserInteractionEnabled:YES];
    [self.forgotPassLabel addGestureRecognizer:passTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)forgotPasswordTapLabel:(UITapGestureRecognizer*)sender {
    ForgotPasswordViewController *viewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma - mark actions
- (IBAction)signInAction:(id)sender {
    [self.view endEditing:YES];
    if([self areFieldsFilled]) {
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

- (IBAction)signUpAction:(id)sender {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInCommerceViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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
            [LoadingView dismiss];
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
        [LoadingView dismiss];
        NavigationController *navigationController = [NavigationController sharedInstance];
        [navigationController presentTabBarController:self
                                   withNavigationType:user.userType
                                             withUser:user];
    } failureHandler:^(id response) {
            [LoadingView dismiss];
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

#pragma mark - validate data
- (BOOL)areFieldsFilled {
    return [self.txtEmail hasText] && [self.txtPassword hasText];
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

@end
