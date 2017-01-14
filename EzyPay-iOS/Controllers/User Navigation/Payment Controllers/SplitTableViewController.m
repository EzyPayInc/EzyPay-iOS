//
//  SplitTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitTableViewController.h"
#import "SplitTableViewCell.h"
#import "UserManager.h"

@interface SplitTableViewController ()

@property (nonatomic, strong) User *user;

@end

@implementation SplitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.splitContacts count];
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 ? 44.f : 80.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Me";
            break;
        case 1:
            return @"Contacts";
            break;
        case 2:
            return @"Payment";
;
            break;
        default:
            break;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = @"$1000";
        return cell;

    } else if (indexPath.section == 1) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        User *user = [self.splitContacts objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
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
