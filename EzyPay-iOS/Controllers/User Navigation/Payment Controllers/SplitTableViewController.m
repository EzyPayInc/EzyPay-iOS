//
//  SplitTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitTableViewController.h"
#import "SplitTableViewCell.h"
#import "UserManager.h"
#import "UIColor+UIColor.h"
#import "PaymentViewController.h"
#import "Friend+CoreDataClass.h"

@interface SplitTableViewController ()<SplitCellDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) float userPayment, paymentShortage;
@property (nonatomic, strong)UILabel *shortageLabel;

@end

@implementation SplitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentShortage = self.payment.cost;
    self.navigationItem.title = @"Split";
    self.tableView.backgroundColor = [UIColor grayBackgroundViewColor];
    self.user = [UserManager getUser];
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
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.payment.friends count];
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 ? 44.f : 80.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Me";
            break;
        case 1:
            return @"Friends";
            break;
        case 2:
            return @"Payment";
;
            break;
        default:
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", (int)self.userPayment];
        cell.totalPayment = self.payment.cost;
        cell.delegate = self;
        [self getImage:cell fromId:self.user.id];
        return cell;

    } else if (indexPath.section == 1) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        Friend *friend = [[self.payment.friends allObjects]objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", (int)friend.cost];
        cell.totalPayment = self.payment.cost;
        cell.paymentFriend = friend;
        cell.delegate = self;
        [self getImage:cell fromId:friend.id];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            self.shortageLabel = cell.detailTextLabel;
            cell.textLabel.text = @"Faltante";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)self.paymentShortage];
        } else {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)self.payment.cost];
        }
        return cell;
    }
}

#pragma mark - Actions
- (void)getImage: (SplitTableViewCell *)cell fromId:(int64_t )id {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:id
               toImageView:cell.profileImageView
              defaultImage:@"profileImage"];
}

-(float)validateQuantity:(float)quantity andFriend:(Friend *)friend
{
    float currentQuantity = 0;
    if(friend) {
        friend.cost = quantity;
    } else {
        self.userPayment = quantity;
    }
    for(Friend *friend in self.payment.friends) {
        currentQuantity += friend.cost;
    }
    currentQuantity += self.userPayment;
    if(currentQuantity  <= self.payment.cost) {
        self.paymentShortage = self.payment.cost - currentQuantity;
        return 0;
    } else {
        self.paymentShortage = 0;
        return self.payment.cost - currentQuantity;

    }

}


#pragma mark - events
- (IBAction)navigateToPayment:(id)sender {
    PaymentViewController *viewController = (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    viewController.payment = self.payment;
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Split cell delegate
- (void)sliderDidChangeValue:(float)value
                      InCell:(SplitTableViewCell *)splitCell
                  WithFriend:(Friend *)paymentFriend {
    float validateValue = [self validateQuantity:value andFriend:paymentFriend];
    if(paymentFriend) {
        paymentFriend.cost += validateValue;
        value = paymentFriend.cost;
    } else {
        self.userPayment += validateValue;
        value = self.userPayment;
        
    }
    self.shortageLabel.text = [NSString stringWithFormat:@"%d",(int)self.paymentShortage];
    splitCell.quantityLabel.text = [NSString stringWithFormat:@"%d",(int)value];
    splitCell.paymentSlider.value = value / splitCell.stepValue;
}

@end
