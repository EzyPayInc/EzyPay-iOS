//
//  SplitTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitTableViewController.h"
#import "SplitTableViewCell.h"

@interface SplitTableViewController ()

@end

@implementation SplitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0? [self.splitContacts count] : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 80.f : 44.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0? @"Contacts" : @"Payment";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        NSDictionary *contact = [self.splitContacts objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", [contact objectForKey:@"firstName"], [contact objectForKey:@"lastName"]];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = @"$1000";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Faltante";
            cell.detailTextLabel.text = @"$0";
        } else {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = @"$15000";
        }
        return cell;
    }
}

@end
