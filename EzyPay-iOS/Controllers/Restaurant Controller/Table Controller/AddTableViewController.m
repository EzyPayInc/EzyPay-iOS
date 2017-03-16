//
//  AddTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "AddTableViewController.h"
#import "CoreDataManager.h"
#import "TableManager.h"

@interface AddTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtTableNumber;

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)addTableAction:(id)sender {
    int64_t tableNumber = [self.txtTableNumber.text integerValue];
    Table *table = [CoreDataManager createEntityWithName:@"Table"];
    table.restaurant = self.user;
    table.tableNumber = tableNumber;
    TableManager *manager = [[TableManager alloc] init];
    [manager registerTable:table token:self.user.token successHandler:^(id response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failureHandler:^(id response) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
