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
#import "UIColor+UIColor.h"
#import "InitialViewController.h"
#import "NavigationController.h"

@interface SettingsTableViewController ()<SettingsCellDelegate, ProfileImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)User *user;

@property (nonatomic, assign) BOOL isEditableMode;
@property (nonatomic, strong) UIImageView *profileImageView;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditableMode = NO;
    self.navigationItem.title = NSLocalizedString(@"settingsTitle", nil);
    self.tableView.backgroundColor = [UIColor grayBackgroundViewColor];
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
    return self.user.userType == UserNavigation ? 5 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return indexPath.row == 0 ? 250.f : 44.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        ProfileImageTableViewCell *cell = (ProfileImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"profileImageCell"];
        cell.delegate = self;
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        self.profileImageView = cell.profileImageView;
        cell.userInteractionEnabled = self.isEditableMode;
        return cell;
        
    } else {
        return self.user.userType == UserNavigation ?
        [self tableView:tableView userCellForRowAtIndexPath:indexPath] :
        [self tableView:tableView commerceCellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row > 0){
        SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.txtValue becomeFirstResponder];
    }
}


#pragma mark - actions
-(UITableViewCell *)tableView:(UITableView *)tableView userCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    switch (indexPath.row) {
        case NameCell:
            cell.detailLabel.text = @"Name";
            cell.txtValue.text = self.user.name;
            cell.cellType = NameCell;
            break;
        case LastNameCell:
            cell.detailLabel.text = @"Last Name";
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

-(UITableViewCell *)tableView:(UITableView *)tableView commerceCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    if (indexPath.row == 1) {
        cell.detailLabel.text = @"Name";
        cell.txtValue.text = self.user.name;
        cell.cellType = NameCell;
    } else if(indexPath.row == 2) {
        cell.detailLabel.text = @"Phone Number";
        cell.txtValue.text = self.user.phoneNumber;
        cell.cellType = PhoneNumberCell;
    } else if(indexPath.row == 3) {
        cell.detailLabel.text = @"Email";
        cell.txtValue.text = self.user.email;
        cell.cellType = EmailCell;
    }
    cell.delegate = self;
    cell.userInteractionEnabled = self.isEditableMode;
    return cell;
}



- (void)addNavigationBarButtons {
    UIImage *cardListImage = [[UIImage imageNamed:@"ic_credit_card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logOutAction];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:editAction];
    [alertController addAction:logOutAction];
    [alertController addAction:cancelAction];
    alertController.disablesAutomaticKeyboardDismissal = NO;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)editAction {
    self.isEditableMode = YES;
    [self addEditButtons];
    [self.tableView reloadData];
}

- (void)logOutAction {
    [UserManager deleteUser];
    InitialViewController *viewController = (InitialViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
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
        [self updateImage];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)updateImage {
    UserManager *manager = [[UserManager alloc] init];
    [manager uploadUserImage: self.profileImageView.image User:self.user successHandler:^(id response) {
         NSLog(@"%@", response);
     } failureHandler:^(id response) {
         NSLog(@"%@", response);
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

#pragma mark - ProfileImageViewDelegate
- (void)imageViewDidTap:(UIImageView *)imageView {
    if(self.isEditableMode) {
        [self imageOptions];
    }
}


#pragma mark - Gallery
- (void)imageOptions {
    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Take Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePicture];
    }];
    UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:@"Open Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:editAction];
    [alertController addAction:logOutAction];
    [alertController addAction:cancelAction];
    alertController.disablesAutomaticKeyboardDismissal = NO;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)openGallery{
    UIImagePickerController *picker;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)takePicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.profileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
