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
#import "CoreDataManager.h"

@interface SplitViewController ()<UITableViewDataSource, UITableViewDelegate, SplitCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) float paymentShortage;
@property (weak, nonatomic) IBOutlet UILabel *shortageLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortageValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *modalBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UIButton *btnSendNotifications;
@property (weak, nonatomic) IBOutlet UIView *infoPaymentView;

@property (nonatomic, assign) BOOL keyboardisActive;
@property (nonatomic, strong) SplitTableViewCell *currentSelectedCell;

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentShortage = self.payment.cost;
    self.navigationItem.title = @"Split";
    self.user = [UserManager getUser];
    [self setupGestures];
    [self setupView];
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

- (void)setupView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.btnSendNotifications.userInteractionEnabled = self.paymentShortage <= 0;
    self.btnCancel.layer.cornerRadius = 20.f;
    self.btnChange.layer.cornerRadius = 20.f;
    self.btnSendNotifications.layer.cornerRadius = self.btnSendNotifications.frame.size.width / 2;
    self.infoPaymentView.layer.cornerRadius = 20.f;
    self.shortageValueLabel.text = [self quantityWithCurrencyCode:self.paymentShortage];
    self.totalValueLabel.text = [self quantityWithCurrencyCode:self.payment.cost];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : [self.payment.friends count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Me";
            break;
        case 1:
            return @"Others";
            break;
        default:
            break;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SplitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"splitCell"
                                                               forIndexPath:indexPath];
    if(indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.userNameLabel.textColor = [UIColor ezypayGreenColor];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:self.payment.userCost];
        cell.totalPayment = self.payment.cost;
        cell.delegate = self;
        [self getImage:cell fromId:self.user.id];
    } else {
        Friend *friend = [[self.payment.friends allObjects]objectAtIndex:indexPath.row];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.name, friend.lastname];
        cell.profileImageView.image = [UIImage imageNamed:@"profileImage"];
        cell.quantityLabel.text = [self quantityWithCurrencyCode:friend.cost];
        cell.totalPayment = self.payment.cost;
        cell.paymentFriend = friend;
        cell.delegate = self;
        [self getImage:cell fromId:friend.id];
    }
    return cell;
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
        self.payment.userCost = quantity;
    }
    for(Friend *friend in self.payment.friends) {
        currentQuantity += friend.cost;
    }
    currentQuantity += self.payment.userCost;
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
                           userCost:self.payment.userCost
                  successHandler:^(id response) {
                      [self sendSplitNotifications];
                  } failureHandler:^(id response) {
        NSLog(@"%@Response: ", response);
    }];
   
}

- (void)sendSplitNotifications {
    [CoreDataManager saveContext];
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager splitRequestNotification:self.user payment:self.payment successHandler:^(id response) {
        PaymentViewController *viewController = (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        viewController.payment = self.payment;
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
        self.payment.userCost += validateValue;
        value = self.payment.userCost;
        
    }
    self.shortageValueLabel.text = [self quantityWithCurrencyCode:self.paymentShortage];
    splitCell.quantityLabel.text = [self quantityWithCurrencyCode:value];
    splitCell.paymentSlider.value = value / splitCell.stepValue;
    self.btnSendNotifications.userInteractionEnabled = self.paymentShortage <= 0;
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
