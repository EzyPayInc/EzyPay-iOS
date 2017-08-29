//
//  PhoneCodesTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 8/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PhoneCodesTableViewController.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "UIColor+UIColor.h"

@interface PhoneCodesTableViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *phoneCodes;
@property (nonatomic, strong) NSArray *inmutablePhonesArray;

@end

@implementation PhoneCodesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPhoneCodes];
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
    return self.phoneCodes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"codesCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor = [UIColor blackEzyPayColor];
    NSDictionary *country = [self.phoneCodes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (+%@)",[country objectForKey:@"name"],
                           [country objectForKey:@"phonecode"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *country = [self.phoneCodes objectAtIndex:indexPath.row];
    NSString *countryCode = [NSString stringWithFormat:@"+%@",[country objectForKey:@"phonecode"]];
    [self.delegate didTapOnCode:countryCode];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        self.phoneCodes = self.inmutablePhonesArray;
        [self.tableView reloadData];
    } else {
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - actions

#pragma mark - Actions
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    self.phoneCodes = [self.inmutablePhonesArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (void) getPhoneCodes {
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager getPhoneCodes:^(id response) {
        [LoadingView dismiss];
        self.phoneCodes = response;
        self.inmutablePhonesArray = response;
        [self.tableView reloadData];
    } failureHandler:^(id response) {
         NSLog(@"Error response %@", response);
        [LoadingView dismiss];
    }];
}


@end
