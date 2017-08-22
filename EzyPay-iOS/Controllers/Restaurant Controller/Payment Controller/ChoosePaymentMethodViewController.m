//
//  ChoosePaymentMethodViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ChoosePaymentMethodViewController.h"
#import "QRPaymentViewController.h"
#import "PaymentDetailViewController.h"
#import "NavigationController.h"
#import "PaymentManager.h"
#import "CoreDataManager.h"
#import "CurrencyManager.h"

@interface ChoosePaymentMethodViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *quickButton;

@end

@implementation ChoosePaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.titleLabel.text = NSLocalizedString(@"chooseQRLabel", nil);
    [self.syncButton setTitle:NSLocalizedString(@"syncAction", nil) forState:UIControlStateNormal];
    [self.quickButton setTitle:NSLocalizedString(@"quickAction", nil) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];

}

- (IBAction)syncAction:(id)sender {
    [CoreDataManager deleteDataFromEntity:@"Payment"];
    Payment *payment = [CoreDataManager createEntityWithName:@"Payment"];
    payment.cost = 0;
    payment.tableNumber = self.tableNumber;
    payment.commerce = self.user.userType == EmployeeNavigation ? self.user.boss : self.user;
    payment.employeeId = self.user.userType == EmployeeNavigation  ? self.user.id : 0;
    
    QRPaymentViewController *viewController = (QRPaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QRPaymentViewController"];
    viewController.tableNumber = self.tableNumber;
    viewController.cost = 0;
    viewController.user = self.user.userType == EmployeeNavigation ? self.user.boss : self.user;
    viewController.payment = payment;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)quickAction:(id)sender {
    PaymentDetailViewController *viewController = (PaymentDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    viewController.tableNumber = self.tableNumber;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
