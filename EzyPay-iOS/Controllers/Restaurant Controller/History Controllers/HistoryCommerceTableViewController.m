//
//  HistoryCommerceTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "HistoryCommerceTableViewController.h"
#import "UIColor+UIColor.h"
#import "HistoryCommerceTableViewCell.h"
#import "UserManager.h"
#import "LoadingView.h"

@interface HistoryCommerceTableViewController ()

@property (nonatomic, strong)NSMutableDictionary *history;
@property (nonatomic, strong)NSArray *historyDates;
@property (nonatomic, strong)User *user;

@end

@implementation HistoryCommerceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];
    self.history = [NSMutableDictionary dictionary];
    self.navigationItem.title = NSLocalizedString(@"historyTitle", nil);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getHistoryDates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.historyDates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.historyDates[section] objectForKey:@"quantity"] integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *stringDate = [self.historyDates[section] objectForKey:@"paymentDate"];
    return [self getDateName:stringDate];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCommerceTableViewCell *cell = (HistoryCommerceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCommerceCell" forIndexPath:indexPath];
    NSString *date = [[self.historyDates objectAtIndex:indexPath.section] objectForKey:@"paymentDate"];
    NSDictionary *historyElement = [[self.history objectForKey: date] objectAtIndex:indexPath.row];
    NSString *userFullName = [NSString stringWithFormat:@"%@ %@",
                              [historyElement objectForKey:@"name"], [historyElement objectForKey:@"lastName"]];
    CGFloat quantity = [[historyElement objectForKey:@"cost"] floatValue];
    NSString * currencyCode = [historyElement objectForKey:@"code"];
    NSString *commerceName;
    if ([historyElement objectForKey:@"EName"] == nil ||
        [[historyElement objectForKey:@"EName"] isKindOfClass:[NSNull class]]) {
        commerceName = self.user.name;
    } else {
        commerceName = [NSString stringWithFormat:@"%@ %@",
                        [historyElement objectForKey:@"EName"], [historyElement objectForKey:@"ELastName"]];
    }
    
    cell.lblUser.text = userFullName;
    cell.lblEmployee.text = commerceName;
    cell.lblCost.text = [self quantityWithCurrencyCode:quantity currencyCode:currencyCode];
    return cell;
}

#pragma mark - actions
- (void)getHistoryDates {
    [LoadingView show];
    UserManager *manager = [[UserManager alloc] init];
    [manager getCommerceHistoryDates:self.user
                  successHandler:^(id response) {
                      self.historyDates = response;
                      [self getHistory];
                  } failureHandler:^(id response) {
                      [LoadingView dismiss];
                      NSLog(@"Error: %@", response);
                  }];
}

- (void)getHistory {
    UserManager *manager = [[UserManager alloc] init];
    [manager getCommerceHistory:self.user
             successHandler:^(id response) {
                 [LoadingView dismiss];
                 [self getHistoryByDates:response];
             } failureHandler:^(id response) {
                 NSLog(@"Error: %@", response);
                 [LoadingView dismiss];
             }];
}

- (void)getHistoryByDates:(NSArray *)historyArray {
    for (NSDictionary *date in self.historyDates) {
        NSString *filter = [NSString stringWithFormat:@"paymentDate like[c] '%@'", [date objectForKey:@"paymentDate"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
        NSArray *historyByDates = [historyArray filteredArrayUsingPredicate:predicate];
        [self.history setObject:historyByDates forKey:[date objectForKey:@"paymentDate"]];
    }
    [self.tableView reloadData];
}


- (NSString *)quantityWithCurrencyCode:(CGFloat) value currencyCode:(NSString *)currencyCode {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    return [NSString stringWithFormat:@"%@ %.02f", currencySymbol, value];
}

- (NSDate *)stringToDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)getDateName:(NSString *)dateString {
    NSDate *date = [self stringToDate:dateString];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *day = [self getDayName:date];
    NSString *dayNumber = [self getDayNumber:date];
    NSString *month = [self getMonthName:date];
    NSString *year = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@, %@ %@, %@", day, month, dayNumber, year];
}

- (NSString *)getMonthName:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *monthNames = [dateFormatter standaloneMonthSymbols];
    [dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[dateFormatter stringFromDate:date] integerValue];
    return [monthNames objectAtIndex:month - 1];
}

- (NSString *)getDayName:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)getDayNumber:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    return NSLocalizedString(day, nil);
}



@end
