//
//  ScannerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "ScannerViewController.h"
#import "RestaurantDetailViewController.h"
#import "BarcodeScannerViewController.h"
#import "PaymentManager.h"
#import "UserManager.h"
#import "CoreDataManager.h"

@interface ScannerViewController ()<BarcodeScannerDelegate>

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIButton *scannerButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scannerButton.layer.cornerRadius = self.scannerButton.frame.size.width / 2;
    self.containerView.layer.cornerRadius = self.containerView.frame.size.width / 2;
    self.navigationItem.title = @"EzyPay";
    self.user = [UserManager getUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Payment *payment = [PaymentManager getPayment];
    if (payment.id > 0) {
       [self showCommerceDetail:payment];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScanner:(id)sender {
    BarcodeScannerViewController *viewController = (BarcodeScannerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BarcodeScannerViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)barcodeScannerDidScanBarcode:(NSString *)barcodeString {
    NSError *error;
    NSData *data = [barcodeString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paymentData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error == nil) {
        [self registerPayment:paymentData];
    }
}

- (void)registerPayment:(NSDictionary *)paymentDictionary {
    Payment *payment = [PaymentManager paymentFromDictionary:paymentDictionary];
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager registerPayment:payment user:self.user successHandler:^(id response) {
        NSLog(@"Response: %@", response);
        payment.id = [[response objectForKey:@"id"] integerValue];
        [CoreDataManager saveContext];
        [self showCommerceDetail:payment];
    } failureHandler:^(id response) {
        NSLog(@"Register payment request failed: %@", response);
    }];
    
}

- (void)showCommerceDetail:(Payment *)payment {
    RestaurantDetailViewController *viewController = (RestaurantDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    viewController.payment = payment;
    [self.navigationController pushViewController:viewController animated:true];
}


@end
