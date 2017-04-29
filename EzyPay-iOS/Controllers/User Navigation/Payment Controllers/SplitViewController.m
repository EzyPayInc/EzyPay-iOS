//
//  SplitViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitViewController.h"
#import "SplitTableViewCell.h"
#import "UserManager.h"
#import "UIColor+UIColor.h"
#import "PaymentViewController.h"
#import "FriendManager.h"
#import "Currency+CoreDataClass.h"
#import "PushNotificationManager.h"

@interface SplitViewController ()<UITableViewDataSource, UITableViewDelegate, SplitCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) float userPayment, paymentShortage;
@property (nonatomic, strong) UILabel *shortageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *modalBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UIButton *btnSendNotifications;

@property (nonatomic, assign) BOOL keyboardisActive;
@property (nonatomic, strong) SplitTableViewCell *currentSelectedCell;

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentShortage = self.payment.cost;
    self.navigationItem.title = @"Split";
    self.tableView.backgroundColor = [UIColor grayBackgroundViewColor];
    self.user = [UserManager getUser];
    [self setupGestures];
    [self setupButtons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.modalBackgroundView.hidden = YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButtons {
    self.btnCancel.layer.borderWidth = 2.0f;
    self.btnChange.layer.borderWidth = 2.0f;
    self.btnCancel.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnChange.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnCancel.layer.cornerRadius = 4.f;
    self.btnChange.layer.cornerRadius = 4.f;
}

- (void)setupGestures {
    //table view gesture
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTapPress:)];
    tapGesture.delegate = self;
    [self.modalBackgroundView addGestureRecognizer:tapGesture];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    if(!self.keyboardisActive) {
        self.keyboardisActive = YES;
        [self moveView:CGRectMake(self.modalView.frame.origin.x,
                                  self.modalView.frame.origin.y -160.,
                                  self.modalView.frame.size.width,
                                  self.modalView.frame.size.height)];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if (self.keyboardisActive) {
        self.keyboardisActive = NO;
        [self moveView:CGRectMake(self.modalView.frame.origin.x,
                                  self.modalView.frame.origin.y +160.,
                                  self.modalView.frame.size.width,
                                  self.modalView.frame.size.height)];
    }
    
}

- (void)moveView:(CGRect) newFrame {
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.modalView.frame = newFrame;
                     }
                     completion:nil];
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
        cell.quantityLabel.text = [self quantityWithCurrencyCode:self.userPayment];
        cell.totalPayment = self.payment.cost;
        cell.delegate = self;
        [self getImage:cell fromId:self.user.id];
        return cell;
        
    } else if (indexPath.section == 1) {
        SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell" forIndexPath:indexPath];
        Friend *friend = [[self.payment.friends allObjects]objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:friend.cost];
        cell.totalPayment = self.payment.cost;
        cell.paymentFriend = friend;
        cell.delegate = self;
        [self getImage:cell fromId:friend.id];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            self.shortageLabel = cell.detailTextLabel;
            cell.textLabel.text = @"Shortage";
            cell.detailTextLabel.text = [self quantityWithCurrencyCode:self.paymentShortage];
        } else {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [self quantityWithCurrencyCode:self.payment.cost];
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

- (float)validateQuantity:(float)quantity andFriend:(Friend *)friend
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

- (NSString *)quantityWithCurrencyCode:(CGFloat) value {
    NSString *currencyCode = self.payment.currency.code;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    return [NSString stringWithFormat:@"%@ %.02f", currencySymbol, value];
}


#pragma mark - events
- (IBAction)navigateToPayment:(id)sender {
    FriendManager *manager = [[FriendManager alloc] init];
    [manager addFriendsToPayment:self.payment
                            user:self.user
                           userCost:self.userPayment
                  successHandler:^(id response) {
                      [self sendSplitNotifications];
                  } failureHandler:^(id response) {
        NSLog(@"%@Response: ", response);
    }];
   
}

- (void)sendSplitNotifications {
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager splitRequestNotification:self.user payment:self.payment successHandler:^(id response) {
        PaymentViewController *viewController = (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        viewController.payment = self.payment;
        viewController.userPayment = self.userPayment;
        [self.navigationController pushViewController:viewController animated:true];
    } failureHandler:^(id response) {
        NSLog(@"Response: %@", response);
    }];
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
    self.shortageLabel.text = [self quantityWithCurrencyCode:self.paymentShortage];
    splitCell.quantityLabel.text = [self quantityWithCurrencyCode:value];
    splitCell.paymentSlider.value = value / splitCell.stepValue;
    if(self.paymentShortage <= 0) {
        self.btnSendNotifications.hidden = NO;
    } else {
        self.btnSendNotifications.hidden = YES;
    }
}

#pragma mark - Gesture recognizer delegate
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (indexPath.section < 2) {
            self.currentSelectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
            self.txtCost.text = [NSString stringWithFormat:@"%.02f",
                                 self.currentSelectedCell.paymentSlider.value];
            self.modalBackgroundView.hidden = NO;
        }
    }
    
}

-(void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    self.modalBackgroundView.hidden = YES;
}

#pragma mark - modal buttons events
- (IBAction)cancelChange:(id)sender {
    [self.view endEditing:YES];
    self.modalBackgroundView.hidden = YES;
}

- (IBAction)changeCost:(id)sender {
    [self.view endEditing:YES];
    float value =  [self.txtCost.text floatValue];
    [self sliderDidChangeValue:value
                        InCell:self.currentSelectedCell
                    WithFriend:self.currentSelectedCell.paymentFriend];
    self.modalBackgroundView.hidden = YES;
}

@end
