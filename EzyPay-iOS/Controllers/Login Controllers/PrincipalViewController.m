//
//  PrincipalViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/26/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "PrincipalViewController.h"
#import "LoginViewController.h"

@interface PrincipalViewController ()

@end

@implementation PrincipalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showUserLogin:(id)sender {
    UINavigationController *loginNavigationController = (UINavigationController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    LoginViewController *loginViewController = (LoginViewController *) [loginNavigationController.viewControllers objectAtIndex:0];
    loginViewController.loginType = UserType;
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

- (IBAction)showRestaurantLogin:(id)sender {
    UINavigationController *loginNavigationController = (UINavigationController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    LoginViewController *loginViewController = (LoginViewController *) [loginNavigationController.viewControllers objectAtIndex:0];
    loginViewController.loginType = RestaurantType;
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

@end
