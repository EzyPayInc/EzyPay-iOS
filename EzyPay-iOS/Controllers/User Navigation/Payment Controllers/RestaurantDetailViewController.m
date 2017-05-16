//
//  RestaurantDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "ContactListTableViewController.h"
#import "UserManager.h"
#import "PaymentManager.h"
#import "CoreDataManager.h"
#import "UIColor+UIColor.h"
#import "PushNotificationManager.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIView *paymentOptionsView;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIButton *btnSplit;
@property (weak, nonatomic) IBOutlet UIView *actionsView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) User *user;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.payment.commerce.name;
    self.user = [UserManager getUser];
    [self setupView];
    [self addCancelButton];
    [self getImage];
    self.paymentOptionsView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.paymentOptionsView.hidden = (self.payment.cost == 0);
    self.questionLabel.hidden = (self.payment.cost == 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.btnPay.layer.cornerRadius = 20.f;
    self.btnSplit.layer.cornerRadius = 20.f;
    self.actionsView.layer.cornerRadius = 20.f;
    self.actionView.layer.cornerRadius = 20.f;
}

#pragma mark - actions
- (void)addCancelButton {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)cancelAction {
    [PaymentManager deletePayment];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)requestBill:(id)sender {
    [self requestBillAction];
}

- (IBAction)callWaiter:(id)sender {
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager callWaiterNotification:self.payment token:self.user.token successHandler:^(id response) {
        NSLog(@"Success: %@", response);
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}


- (IBAction)splitPayment:(id)sender {
    ContactListTableViewController *tableViewController = (ContactListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactListTableViewController"];
     self.payment.paymentDate = [NSDate date];
     PaymentManager *manager = [[PaymentManager alloc] init];
     [manager updatePayment:self.payment user:self.user successHandler:^(id response) {
         [CoreDataManager saveContext];
         tableViewController.payment = self.payment;
     [self.navigationController pushViewController:tableViewController animated:true];
     } failureHandler:^(id response) {
     NSLog(@"%@", response);
     }];
}

- (void)requestBillAction {
    if(self.payment.cost > 0) {
        self.paymentOptionsView.hidden = NO;
    } else {
        PushNotificationManager *manager = [[PushNotificationManager alloc] init];
        [manager billRequestNotification:self.payment
                                   token:self.user.token successHandler:^(id response) {
                                       NSLog(@"%@", response);
                                   } failureHandler:^(id response) {
                                       NSLog(@"%@", response);
                                   }];
    }
}

- (void)getImage {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:self.payment.commerce.id
               toImageView:self.restaurantImageView
              defaultImage:@"restaurant"];
}

- (void)showPaymentView{
    self.paymentOptionsView.hidden = NO;
    self.questionLabel.hidden = NO;
}

@end
