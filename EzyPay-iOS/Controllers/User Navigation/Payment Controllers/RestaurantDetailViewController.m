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

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnBill;
@property (weak, nonatomic) IBOutlet UIButton *btnWaiter;
@property (weak, nonatomic) IBOutlet UILabel *lblCommerceName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIView *paymentOptionsView;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIButton *btnSplit;

@property (nonatomic, strong) User *user;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Commerce";
    self.lblCommerceName.text = self.payment.commerce.name;
    self.btnWaiter.hidden = self.payment.tableNumber == 0;
    self.user = [UserManager getUser];
    [self addCancelButton];
    [self getImage];
    [self setupButtons];
    self.paymentOptionsView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButtons {
    self.btnPay.layer.borderWidth = 2.0f;
    self.btnSplit.layer.borderWidth = 2.0f;
    self.btnPay.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnSplit.layer.borderColor = [[UIColor grayBackgroundViewColor] CGColor];
    self.btnPay.layer.cornerRadius = 4.f;
    self.btnSplit.layer.cornerRadius = 4.f;
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

- (IBAction)payBill:(id)sender {
    self.paymentOptionsView.hidden = NO;
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

- (void)getImage {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:self.payment.commerce.id
               toImageView:self.restaurantImageView
              defaultImage:@"restaurant"];
}

#pragma mark - Animation
/*- (void)slideUpOptionsView {
    self.paymentOptionsView.hidden = NO;
    [self moveView:CGRectMake(self.paymentOptionsView.frame.origin.x,
                              self.paymentOptionsView.frame.origin.y * -1,
                              self.paymentOptionsView.frame.size.width,
                              self.paymentOptionsView.frame.size.height)
            hidden:NO];
}

- (void)slideDownOptionsView {
    [self moveView:CGRectMake(self.paymentOptionsView.frame.origin.x,
                              self.paymentOptionsView.frame.origin.y * -1,
                              self.paymentOptionsView.frame.size.width,
                              self.paymentOptionsView.frame.size.height)
     hidden:YES];
}

- (void)moveView:(CGRect)newFrame hidden:(BOOL)hidden {
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.paymentOptionsView.frame = newFrame;
                     }
                     completion:nil];
}*/

@end
