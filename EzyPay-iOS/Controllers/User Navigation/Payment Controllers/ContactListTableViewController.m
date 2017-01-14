//
//  ContactListTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ContactListTableViewController.h"
#import <Contacts/Contacts.h>
#import "SplitTableViewController.h"
#import "UserManager.h"

@interface ContactListTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *contactsArray;
@property (nonatomic, strong) NSArray *inmutableContactsArray;
@property (nonatomic, strong) NSMutableArray *contactsChecked;
@property (nonatomic, strong) User *user;

@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactsArray = [NSArray array];
    self.contactsChecked = [NSMutableArray array];
    self.user = [UserManager getUser];
    [self getContactsFromPhone];
    [self addNextButton];
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
    return [self.contactsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
    User *user = [self.contactsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
    cell.imageView.image = [UIImage imageNamed:@"profileImage"];
    if([self validatePhoneNumber:user.phoneNumber]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.contactsArray objectAtIndex:indexPath.row];
    NSUInteger index = [[tableView indexPathsForVisibleRows] indexOfObject:indexPath];
    UITableViewCell *cell = [[tableView visibleCells] objectAtIndex:index];
    if ([cell accessoryType] == UITableViewCellAccessoryNone) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.contactsChecked addObject:user];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.contactsChecked removeObject:user];
    }
}

#pragma mark - Search bar delegate
- (void)addNextButton {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)nextAction {
    SplitTableViewController *tableViewController = (SplitTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SplitTableViewController"];
    tableViewController.splitContacts = self.contactsChecked;
    [self.navigationController pushViewController:tableViewController animated:true];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        self.contactsArray = self.inmutableContactsArray;
        [self.tableView reloadData];
    } else {
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - Actions
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSString *newText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *array = [newText componentsSeparatedByString:@" "];
    NSString *firstName = newText;
    NSString *lastName = newText;
    NSPredicate *predicate = nil;
    
    if ([array count] > 1) {
        firstName = array[0];
        lastName = array[1];
        predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@) OR (name CONTAINS[cd] %@ AND lastName CONTAINS[cd] %@)", firstName, lastName, lastName, firstName];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", firstName, lastName];
    }
    
    self.contactsArray = [self.inmutableContactsArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (void)getContactsFromPhone {
    CNContactStore *store = [[CNContactStore alloc] init];
    NSMutableArray *phoneNumbers =  [NSMutableArray array];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactPhoneNumbersKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                for (CNContact *contact in cnContacts) {
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        NSString *phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            [phoneNumbers addObject:phone];
                        }
                    }
                }
                [self validatePhoneNumbers:phoneNumbers];
            }
        }        
    }];
}

- (BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber ==[c] %@", phoneNumber];
    NSArray *array = [self.contactsChecked filteredArrayUsingPredicate:predicate];
    return [array count] > 0;
}

- (void)validatePhoneNumbers:(NSArray *)phoneNumbers {
    UserManager *manager = [[UserManager alloc] init];
    [manager validatePhoneNumbers:phoneNumbers token:self.user.token successHandler:^(id response) {
        self.contactsArray = [UserManager usersFromArray:response];
        self.inmutableContactsArray = self.contactsArray;
        [self.tableView reloadData];
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
}


@end
