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
#import "Friend+CoreDataClass.h"
#import "UserManager.h"

@interface PaymentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPayment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];
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
    return [self.payment.friends count] > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : [self.payment.friends count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  section == 0 ? @"Me" : @"Friends" ;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    if(indexPath.section == 0) {
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", (int)self.userPayment];
        [self getImage:cell fromUser:self.user.id];
    } else {
        Friend *friend = [[self.payment.friends allObjects] objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", (int)friend.cost];
        cell.indicatorImageView.image = [UIImage imageNamed:@"ic_loading_spinner"];
        [self getImage:cell fromUser:friend.id];
    }
    return  cell;
}

- (void)getImage:(PaymentTableViewCell *)cell fromUser:(int64_t)userId {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:userId toImageView:cell.profileImageView defaultImage:@"profileImage"];
}

@end
