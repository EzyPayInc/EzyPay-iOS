//
//  SettingsViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/1/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserManager.h"
#import "CardListTableViewController.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)User *user;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"settingsTitle", nil);
    self.user = [UserManager getUser];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightDetailCell"];
    switch (indexPath.row) {
        case 0:
             cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.user.name;
            break;
        case 1:
            cell.textLabel.text = @"Lastname";
            cell.detailTextLabel.text = self.user.lastName;
            break;
        case 2:
            cell.textLabel.text = @"Phone Number";
            cell.detailTextLabel.text = self.user.phoneNumber;
            break;
        case 3:
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = self.user.email;
            break;
        default:
            break;
    }
    return cell;
}

- (IBAction)showCardList:(id)sender {
    CardListTableViewController *cardListViewController = (CardListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListTableViewController"];
    [self.navigationController pushViewController:cardListViewController animated:YES];
}


@end
