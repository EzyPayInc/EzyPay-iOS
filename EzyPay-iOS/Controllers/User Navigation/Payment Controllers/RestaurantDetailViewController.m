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
#import "FriendManager.h"
#import "PaymentResultViewController.h"
#import "LoadingView.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIView *paymentOptionsView;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIButton *btnSplit;
@property (weak, nonatomic) IBOutlet UIView *actionsView;
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
    self.questionLabel.text = NSLocalizedString(@"paymentQuestionLabel", nil);
    [self.btnPay setTitle:NSLocalizedString(@"aloneAction", nil) forState:UIControlStateNormal];
    [self.btnSplit setTitle:NSLocalizedString(@"splitAction", nil) forState:UIControlStateNormal];
}

#pragma mark - actions
- (void)addCancelButton {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancelAction", nil)
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (IBAction)payAloneAction:(id)sender {
    [self savePayment];
}


- (void)cancelAction {
    [self deletePayment];
}

- (IBAction)requestBill:(id)sender {
    [self requestBillAction];
}

- (IBAction)callWaiter:(id)sender {
    [LoadingView show];
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager callWaiterNotification:self.payment token:self.user.token successHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Success: %@", response);
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Error: %@", response);
    }];
}


- (IBAction)splitPayment:(id)sender {
    [LoadingView show];
    ContactListTableViewController *tableViewController = (ContactListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactListTableViewController"];
     self.payment.paymentDate = [NSDate date];
     PaymentManager *manager = [[PaymentManager alloc] init];
     [manager updatePayment:self.payment user:self.user successHandler:^(id response) {
         [LoadingView dismiss];
         [CoreDataManager saveContext];
         tableViewController.payment = self.payment;
     [self.navigationController pushViewController:tableViewController animated:true];
     } failureHandler:^(id response) {
         [LoadingView dismiss];
         NSLog(@"%@", response);
     }];
}

- (void)requestBillAction {
    if(self.payment.cost > 0) {
        self.paymentOptionsView.hidden = NO;
    } else {
        [LoadingView show];
        PushNotificationManager *manager = [[PushNotificationManager alloc] init];
        [manager billRequestNotification:self.payment
                                   token:self.user.token successHandler:^(id response) {
                                       [LoadingView dismiss];
                                       NSLog(@"%@", response);
                                   } failureHandler:^(id response) {
                                       [LoadingView dismiss];
                                       NSLog(@"%@", response);
                                   }];
    }
}

- (void)getImage {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:self.payment.commerce.avatar
               toImageView:self.restaurantImageView
              defaultImage:@"restaurant"];
}

- (void)showPaymentView{
    self.paymentOptionsView.hidden = NO;
    self.questionLabel.hidden = NO;
}

- (void)deletePayment {
    [LoadingView show];
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager deletePayment:self.payment.id
                     token:self.user.token
            successHandler:^(id response) {
                [LoadingView dismiss];
                [PaymentManager deletePayment];
                [self.navigationController popViewControllerAnimated:YES];
            }
            failureHandler:^(id response) {
                [LoadingView dismiss];
                NSLog(@"Error deleting a payment : %@", response);
            }];
}

- (void)savePayment {
    [LoadingView show];
    self.payment.userCost = self.payment.cost;
    FriendManager *manager = [[FriendManager alloc] init];
    self.payment.paymentDate = [NSDate date];
    [manager addFriendsToPayment:self.payment
                            user:self.user
                        userCost:self.payment.userCost
                  successHandler:^(id response) {
                      [self performPayment];
                  } failureHandler:^(id response) {
                      [LoadingView dismiss];
                      NSLog(@"%@Response: ", response);
                  }];
}

- (void)performPayment {
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager performPayment:self.payment
                      token:self.user.token
             successHandler:^(id response) {
                 [LoadingView dismiss];
                 self.payment.isCanceled = 1;
                 [CoreDataManager saveContext];
                 PaymentResultViewController *viewController = (PaymentResultViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentResultViewController"];
                 [self.navigationController pushViewController:viewController animated:true];
             } failureHandler:^(id response) {
                 [LoadingView dismiss];
                 NSLog(@"Error performing the pay: %@", response);
             }];
}

@end
