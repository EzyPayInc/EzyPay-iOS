//
//  SignInUserTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInUserTableViewController.h"

@interface SignInUserTableViewController ()

@end

@implementation SignInUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Sign In";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style: UIBarButtonItemStylePlain target:self action:@selector(nextView)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextView{
    
}

@end
