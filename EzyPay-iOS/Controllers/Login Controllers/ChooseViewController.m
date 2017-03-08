//
//  ChooseViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ChooseViewController.h"
#import "SignInUserViewController.h"
#import "SignInCommerceViewController.h"
#import "UIColor+UIColor.h"

@interface ChooseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIButton *btnCommerce;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnUser.layer.borderWidth = 2.0f;
    self.btnCommerce.layer.borderWidth = 2.0f;
    self.btnUser.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnCommerce.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnUser.layer.cornerRadius = 4.f;
    self.btnCommerce.layer.cornerRadius = 4.f;
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
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigateToSignIn
{
    SignInUserViewController *signInUserViewController = (SignInUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInUserViewController"];
    [self.navigationController pushViewController:signInUserViewController animated:true];
}

- (void)navigateToSignInCommerce
{
    SignInCommerceViewController *viewController =
    (SignInCommerceViewController *)[[UIStoryboard storyboardWithName:
                                      @"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInCommerceViewController"];
    [self.navigationController pushViewController:viewController animated:true];
}

@end
