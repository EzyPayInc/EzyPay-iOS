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
#import "SettingsTableViewCell.h"
#import "Connection.h"
#import "CoreDataManager.h"

@interface SettingsTableViewController ()<SettingsCellDelegate>

@property (nonatomic, strong)User *user;

@property (nonatomic, assign) BOOL isEditableMode;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditableMode = NO;
    self.navigationItem.title = NSLocalizedString(@"settingsTitle", nil);
    self.user = [UserManager getUser];
    [self addNavigationBarButtons];
    
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
        cell.userInteractionEnabled = self.isEditableMode;
        return cell;
        
    } else {
        SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        switch (indexPath.row) {
            case NameCell:
                cell.detailLabel.text = @"Name";
                cell.txtValue.text = self.user.name;
                cell.cellType = NameCell;
                break;
            case LastNameCell:
                cell.detailLabel.text = @"Lastname";
                cell.txtValue.text = self.user.lastName;
                cell.cellType = LastNameCell;
                break;
            case PhoneNumberCell:
                cell.detailLabel.text = @"Phone Number";
                cell.txtValue.text = self.user.phoneNumber;
                cell.cellType = PhoneNumberCell;
                break;
            case EmailCell:
                cell.detailLabel.text = @"Email";
                cell.txtValue.text = self.user.email;
                cell.cellType = EmailCell;
                break;
            default:
                break;
        }
        cell.delegate = self;
        cell.userInteractionEnabled = self.isEditableMode;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row > 0){
        SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.txtValue becomeFirstResponder];
    }
}


#pragma mark - actions
- (void)addNavigationBarButtons {
    UIImage *cardListImage = [UIImage imageNamed:@"ic_add_card"];
    UIBarButtonItem *cardButton = [[UIBarButtonItem alloc] initWithImage:cardListImage style:UIBarButtonItemStyleDone target:self action:@selector(showCardList:)];
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showOptions:)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = @[optionsButton, cardButton];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (IBAction)showCardList:(id)sender {
    CardListTableViewController *cardListViewController = (CardListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListTableViewController"];
     [self.navigationController pushViewController:cardListViewController animated:YES];
}

- (IBAction)showOptions:(id)sender {
    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:@"Actions" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editAction];
    }];
    UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:editAction];
    [alertController addAction:logOutAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)editAction {
    self.isEditableMode = YES;
    [self addEditButtons];
    [self.tableView reloadData];
}

- (void)addEditButtons {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateUserAction)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelUpdateAction)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.leftBarButtonItem = leftBarButton;

}
                                       
- (void)updateUserAction {
    [self.view endEditing:YES];
    UserManager *manager = [[UserManager alloc] init];
    [manager updateUser:self.user successHandler:^(id response) {
        self.isEditableMode = NO;
        [CoreDataManager saveContext];
        [self.tableView reloadData];
        [self addNavigationBarButtons];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)cancelUpdateAction {
    self.isEditableMode = NO;
    [self.user.managedObjectContext rollback];
    [self.tableView reloadData];
    [self addNavigationBarButtons];
}

#pragma mark - SettigsCellDelegate
- (void)cellTableDidChange:(UITextField *)textField inCell:(SettingsCellTypes)cellType {
    switch (cellType) {
        case NameCell:
            self.user.name = textField.text;
            break;
        case LastNameCell:
            self.user.lastName = textField.text;
            break;
        case PhoneNumberCell:
            self.user.phoneNumber = textField.text;
            break;
        case EmailCell:
            self.user.email = textField.text;
            break;
        default:
            break;
    }
}

@end
