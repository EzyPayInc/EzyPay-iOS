//
//  TestTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserManager.h"
#import "ProfileImageTableViewCell.h"
#import "CardListTableViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong)User *user;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"settingsTitle", nil);
    self.user = [UserManager getUser];
    
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0? 200.f:44.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        ProfileImageTableViewCell *cell = (ProfileImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"profileImageCell"];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.hidden = NO;
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = self.user.name;
                break;
            case 2:
                cell.textLabel.text = @"Lastname";
                cell.detailTextLabel.text = self.user.lastName;
                break;
            case 3:
                cell.textLabel.text = @"Phone Number";
                cell.detailTextLabel.text = self.user.phoneNumber;
                break;
            case 4:
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text = self.user.email;
                break;
            default:
                break;
        }
        cell.hidden = NO;
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - actions
- (IBAction)showCardList:(id)sender {
    CardListTableViewController *cardListViewController = (CardListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListTableViewController"];
     [self.navigationController pushViewController:cardListViewController animated:YES];
}

@end
