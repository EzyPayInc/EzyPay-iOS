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

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPayment;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL keyboardisActive;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];
    [self setupView];
    self.navigationItem.title = NSLocalizedString(@"splitTitle", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView {
    self.btnCancel.layer.cornerRadius = 20.f;
    self.btnPayment.layer.cornerRadius = 20.f;
    [self.btnCancel setTitle:NSLocalizedString(@"cancelUpperAction", nil) forState:UIControlStateNormal];
    [self.btnPayment setTitle:NSLocalizedString(@"payAction", nil) forState:UIControlStateNormal];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tipLabel.text = NSLocalizedString(@"tipLabel", nil);
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGSize keyboardSize =
        [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSInteger height = MIN(keyboardSize.height,keyboardSize.width) - 120;
    if(!self.keyboardisActive) {
        self.keyboardisActive = YES;
        [self moveView:CGRectMake(self.tipView.frame.origin.x,
                                  self.tipView.frame.origin.y - height,
                                  self.tipView.frame.size.width,
                                  self.tipView.frame.size.height)];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.keyboardisActive = self.keyboardisActive ? NO : YES;
}

- (void)moveView:(CGRect) newFrame {
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.tipView.frame = newFrame;
                     }
                     completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    return  section == 0 ? NSLocalizedString(@"meLabel", nil) : NSLocalizedString(@"othersLabel", nil);
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
        cell.backgroundColor = [UIColor lightGreenColor];
        cell.userNameLabel.textColor = [UIColor blackEzyPayColor];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:friend.cost];
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
