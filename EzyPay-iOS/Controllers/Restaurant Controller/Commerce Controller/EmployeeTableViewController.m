//
//  EmployeeTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/4/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "EmployeeTableViewController.h"
#import "UIColor+UIColor.h"
#import "EmployeeDetailViewController.h"

@interface EmployeeTableViewController ()

@property (nonatomic, strong)NSArray *employees;

@end

@implementation EmployeeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"employeesTitle", nil);
    [self displayRightBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getEmployees];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell" forIndexPath:indexPath];
    User *user = [self.employees objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
    return cell;
}


#pragma mark - Action
- (void) displayRightBarButton {
    UIImage *image = [[UIImage imageNamed:@"ic_add_card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(showDetailEmployee:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


-(void) getEmployees {
    UserManager *manager = [[UserManager alloc] init];
    [manager getEmployees:self.user.id token:self.user.token successHandler:^(id response) {
        self.employees = [UserManager employeesFromArray:response];
        [self.tableView reloadData];
    } failureHandler:^(id response) {
        NSLog(@"Error in getEmployees Request: %@", response);
    }];
}

- (IBAction)showDetailEmployee:(id)sender {
    EmployeeDetailViewController *viewController = (EmployeeDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeDetailViewController"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:true];
}
@end
