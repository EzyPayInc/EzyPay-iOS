//
//  ChooseViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ChooseViewController.h"
#import "LoginViewController.h"
#import "LogInCommerceViewController.h"
#import "UIColor+UIColor.h"

@interface ChooseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIButton *btnCommerce;

@property (weak, nonatomic) IBOutlet UILabel *orLabel;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnUser.layer.cornerRadius = 20.f;
    self.btnCommerce.layer.cornerRadius = 20.f;
    self.orLabel.text = NSLocalizedString(@"orLabel", nil);
    [self.btnUser setTitle:NSLocalizedString(@"userAction", nil)
                  forState:UIControlStateNormal];
    [self.btnCommerce setTitle:NSLocalizedString(@"commerceAction", nil)
                  forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userAction:(id)sender {
    [self navigateToSignIn];
}

- (IBAction)commerceAction:(id)sender {
    [self navigateToSignInCommerce];
}

- (void)navigateToSignIn
{
    LoginViewController *viewController = (LoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)navigateToSignInCommerce
{
    LogInCommerceViewController *viewController =
    (LogInCommerceViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInCommerceViewController"];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];;
}

@end
