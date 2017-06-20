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
#import "NavigationController.h"
#import "SessionHandler.h"
#import "EmployeeTableViewController.h"
#import "DeviceTokenManager.h"
#import "ChooseViewController.h"

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
    self.user = [UserManager getUser];
    [self addNavigationBarButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.user.userType != UserNavigation ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.user.userType == UserNavigation ? 9 : 7;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return indexPath.row == 0 ? 200.f : indexPath.row % 2 == 0 ? 5.f : 44.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 20.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"" : NSLocalizedString(@"employeesTitle", nil);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            ProfileImageTableViewCell *cell = (ProfileImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"profileImageCell"];
            cell.delegate = self;
            if(!self.isEditableMode) {
                [self getImage];
            }
            
            self.profileImageView = cell.profileImageView;
            cell.userInteractionEnabled = self.isEditableMode;
            return cell;
            
        } else {
            if(indexPath.row % 2 == 0) {
                return [tableView dequeueReusableCellWithIdentifier:@"transparentCell"];
            }
            return self.user.userType == UserNavigation ?
            [self tableView:tableView userCellForRowAtIndexPath:indexPath] :
            [self tableView:tableView commerceCellForRowAtIndexPath:indexPath];
        }
    } else {
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeCell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"addNewEmployee", nil);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row > 0) {
        if(indexPath.row % 2 != 0) {
            SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.txtValue becomeFirstResponder];
        }
    } else {
        if (indexPath.section == 1) {
            EmployeeTableViewController *tableViewController = (EmployeeTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeTableViewController"];
            tableViewController.user = self.user;
            [self.navigationController pushViewController:tableViewController animated:YES];
        }
    }
}


#pragma mark - actions
-(UITableViewCell *)tableView:(UITableView *)tableView
    userCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    NSInteger row = indexPath.row == 1 ? 1 : (indexPath.row/ 2) + 1 ;
    switch (row) {
        case NameCell:
            cell.detailLabel.text =NSLocalizedString(@"namePlaceholder", nil);
            cell.txtValue.text = self.user.name;
            cell.cellType = NameCell;
            break;
        case LastNameCell:
            cell.detailLabel.text = NSLocalizedString(@"lastNamePlaceholder", nil);
            cell.txtValue.text = self.user.lastName;
            cell.cellType = LastNameCell;
            break;
        case PhoneNumberCell:
            cell.detailLabel.text = NSLocalizedString(@"phoneNumberPlaceholder", nil);
            cell.txtValue.text = self.user.phoneNumber;
            cell.cellType = PhoneNumberCell;
            break;
        case EmailCell:
            cell.detailLabel.text = NSLocalizedString(@"emailPlaceholder", nil);
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

- (UITableViewCell *)tableView:(UITableView *)tableView
 commerceCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    NSInteger row = indexPath.row == 1 ? 1 : (indexPath.row/ 2) + 1 ;
    if (row == 1) {
        cell.detailLabel.text = NSLocalizedString(@"namePlaceholder", nil);
        cell.txtValue.text = self.user.name;
        cell.cellType = NameCell;
    } else if(row == 2) {
        cell.detailLabel.text = NSLocalizedString(@"phoneNumberPlaceholder", nil);
        cell.txtValue.text = self.user.phoneNumber;
        cell.cellType = PhoneNumberCell;
    } else if(row == 3) {
        cell.detailLabel.text = NSLocalizedString(@"emailPlaceholder", nil);
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
    UIAlertController  *alertController =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"actionsLabel", nil)
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"editAction", nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        [self editAction];
    }];
    UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"logOutAction", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self logOutAction];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancelAction", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
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
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
    [manager deleteDeviceToken:localToken.deviceId user:self.user successHandler:^(id response) {
        localToken.isSaved = 0;
        [CoreDataManager saveContext];
        ChooseViewController *viewController = (ChooseViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        [UserManager deleteUser];
        [self presentViewController:viewController animated:YES completion:nil];
    } failureHandler:^(id response) {
        NSLog(@"Response %@", response);
    }];
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
    if(self.profileImageView.image != nil){
        UserManager *manager = [[UserManager alloc] init];
        [manager uploadUserImage: self.profileImageView.image User:self.user successHandler:^(id response) {
            [self getImage];
        } failureHandler:^(id response) {
            NSLog(@"%@", response);
        }];
    }
    
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

- (void)getImage {
   dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%lld",BASE_URL, @"user/downloadImage/", self.user.id]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data == nil) {
                self.profileImageView.image = [UIImage imageNamed:@"profileImage"];
            } else {
                UIImage *image = [UIImage imageWithData: data];
                self.profileImageView.image = image;
            }
        });
    });
}

@end
