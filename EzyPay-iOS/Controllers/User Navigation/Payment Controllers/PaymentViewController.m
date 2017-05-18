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
#import "Currency+CoreDataClass.h"
#import "PaymentResultViewController.h"

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
    [self setupView];
    self.navigationItem.title = @"Payment";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.btnCancel.layer.cornerRadius = 20.f;
    self.btnPayment.layer.cornerRadius = 20.f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  section == 0 ? @"Me" : @"Friends" ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell"
                                                                  forIndexPath:indexPath];
    if(indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.userNameLabel.textColor = [UIColor ezypayGreenColor];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:self.payment.userCost];
        cell.activityIndicator.hidden = YES;
        [self getImage:cell fromUser:self.user.id];
    } else {
        Friend *friend = [[self.payment.friends allObjects] objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:friend.cost];
        NSLog(@"Friend: %@", friend);
        if(friend.state != 0) {
            [cell.activityIndicator stopAnimating];
        } else {
            [cell.activityIndicator startAnimating];
        }
        cell.activityIndicator.hidden = friend.state != 0;
        cell.indicatorImageView.hidden = friend.state == 0;
        cell.indicatorImageView.image = [UIImage imageNamed:@"ic_check"];
        [self getImage:cell fromUser:friend.id];
    }
    return  cell;
}

#pragma mark - actions
- (IBAction)paymentAction:(id)sender {
    [self goToPaymentResultView];
}


- (void)getImage:(PaymentTableViewCell *)cell fromUser:(int64_t)userId {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:userId toImageView:cell.profileImageView defaultImage:@"profileImage"];
}

- (NSString *)quantityWithCurrencyCode:(CGFloat) value {
    NSString *currencyCode = self.payment.currency.code;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    return [NSString stringWithFormat:@"%@ %.02f", currencySymbol, value];
}

- (void)goToPaymentResultView {
    PaymentResultViewController *viewController = (PaymentResultViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentResultViewController"];
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)reloadData {
    [self.tableView reloadData];
}

@end
