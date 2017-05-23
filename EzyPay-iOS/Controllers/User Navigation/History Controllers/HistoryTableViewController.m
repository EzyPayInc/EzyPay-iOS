//
//  HistoryTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/1/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"
#import "UIColor+UIColor.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"historyTitle", nil);
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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Martes, Marzo 8, 2017";
        case 1:
            return @"Viernes, Marzo 15, 2017";
        case 2:
            return @"Domingo, Marzo 30, 2017";
        default:
            return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"
                                                                 forIndexPath:indexPath];
    cell.imageViewHistory.image = [UIImage imageNamed:@"restaurant"];
    cell.restaurantName.text = @"Titos & Blancos";
    cell.payment.text = @"$4000";
    return cell;
}



@end
