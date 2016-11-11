//
//  DropDownTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/10/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "DropDownTableViewController.h"

@interface DropDownTableViewController ()

@end

@implementation DropDownTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [self.sourceData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.sourceData objectAtIndex:indexPath.row];;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = [self.sourceData objectAtIndex:indexPath.row];
    NSDictionary *option = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInteger:indexPath.row], @"optionIndex", value, @"value", nil];
    [self.delegate didOptionSelected:option inTextField:self.textfield];
}




@end
