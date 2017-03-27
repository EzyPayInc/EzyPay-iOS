//
//  PaymentViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentViewController.h"
#import "UIColor+UIColor.h"
#import "PaymentTableViewCell.h"
#import "UserManager.h"

@interface PaymentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPayment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtons];
    self.navigationItem.title = @"Payment";
    self.tableView.backgroundColor = [UIColor grayBackgroundViewColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButtons {
    self.btnCancel.layer.borderWidth = 2.0f;
    self.btnPayment.layer.borderWidth = 2.0f;
    self.btnCancel.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnPayment.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnCancel.layer.cornerRadius = 4.f;
    self.btnPayment.layer.cornerRadius = 4.f;
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.splitContacts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  @"Friends";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    User *user = [self.splitContacts objectAtIndex:indexPath.row];
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
    cell.quantityLabel.text = @"$4000";
    cell.indicatorImageView.image = [UIImage imageNamed:@"ic_loading_spinner"];
    [self getImage:cell fromUser:user.id];
    
    return  cell;
}

- (void)getImage:(PaymentTableViewCell *)cell fromUser:(int64_t)userId {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:userId toImageView:cell.profileImageView defaultImage:@"profileImage"];
}

@end
