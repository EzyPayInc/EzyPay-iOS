//
//  InitialViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "InitialViewController.h"
#import "NavigationController.h"
#import "LoginViewController.h"
#import "UIColor+UIColor.h"

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignInRestaurant;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButtons {
    self.btnSignIn.layer.borderWidth = 2.0f;
    self.btnSignInRestaurant.layer.borderWidth = 2.0f;
    self.btnSignIn.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnSignInRestaurant.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnSignIn.layer.cornerRadius = 4.f;
    self.btnSignInRestaurant.layer.cornerRadius = 4.f;
}

#pragma mark - Events
- (IBAction)signIn:(id)sender {
    [self navigateToLogIn:UserNavigation];
}

- (IBAction)signInAsRestaurant:(id)sender {
    [self navigateToLogIn:RestaurantNavigation];
}


- (void)navigateToLogIn:(NavigationTypes) navigationType
{
    UINavigationController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    [self presentViewController:viewController animated:YES completion:NULL];
}

@end
