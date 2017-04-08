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

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnBill;
@property (weak, nonatomic) IBOutlet UIButton *btnWaiter;
@property (weak, nonatomic) IBOutlet UILabel *lblCommerceName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ContactListTableViewController *tableViewController = (ContactListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactListTableViewController"];
    self.payment.cost = 150000;
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

@end
