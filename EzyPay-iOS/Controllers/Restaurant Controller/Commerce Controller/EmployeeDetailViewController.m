//
//  EmployeeDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/4/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "EmployeeDetailViewController.h"
#import "CoreDataManager.h"
#import "Connection.h"
#import "NavigationController.h"


@interface EmployeeDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation EmployeeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"employeeTitle", nil);
    self.btnSave.layer.cornerRadius = 20.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)saveEmployee:(id)sender {
    User *employee = [CoreDataManager createEntityWithName:@"User"];
    employee.name = self.txtName.text;
    employee.lastName = self.txtLastName.text;
    employee.email = self.txtEmail.text;
    employee.password = self.txtPassword.text;
    employee.userType = EmployeeNavigation;
    employee.boss = self.user;
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:employee tables:0 successHandler:^(id response) {
        [self.navigationController popViewControllerAnimated:true];
    } failureHandler:^(id response) {
        NSLog(@"Error in register employee request %@", response);
    }];
}

@end
