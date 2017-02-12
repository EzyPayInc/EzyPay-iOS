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

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
