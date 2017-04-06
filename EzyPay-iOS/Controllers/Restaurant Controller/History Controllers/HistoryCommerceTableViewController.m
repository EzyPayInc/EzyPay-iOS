//
//  HistoryCommerceTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "HistoryCommerceTableViewController.h"
#import "UIColor+UIColor.h"
#import "HistoryCommerceTableViewCell.h"

@interface HistoryCommerceTableViewController ()

@end

@implementation HistoryCommerceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"historyTitle", nil);
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Martes, Marzo 8, 2017";
        case 1:
            return @"Viernes, Marzo 15, 2017";
        case 2:
            return @"Domingo, Marzo 30, 2017";
        default:
            return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCommerceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCommerceCell" forIndexPath:indexPath];
    return cell;
}



@end
