//
//  PaymentDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "CurrencyManager.h"
#import "CoreDataManager.h"
#import "PaymentManager.h"
#import "NavigationController.h"
#import "QRPaymentViewController.h"
#import "PushNotificationManager.h"
#import "UIColor+UIColor.h"

@interface PaymentDetailViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (nonatomic, strong) NSArray *pickerDataSource;
@property (nonatomic, strong) Currency *currentCurrency;
@property (nonatomic, assign) CGFloat *cost;

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencyPicker.delegate = self;
    self.currencyPicker.dataSource = self;
    [self setupView];
    [self getCurrencies];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self.currencyPicker.subviews objectAtIndex:1] setHidden:YES];
    [[self.currencyPicker.subviews objectAtIndex:2] setHidden:YES];
}

- (void)setupView {
    self.titleLabel.text = NSLocalizedString(@"totalCostLabel", nil);
    [self.btnSend setTitle:NSLocalizedString(@"sendAction", nil) forState:UIControlStateNormal];
    self.txtQuantity.placeholder = NSLocalizedString(@"totalCostPlaceholder", nil);
    self.btnSend.layer.cornerRadius = 20.f;
}


#pragma mark - Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDataSource.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Currency *currency = [self.pickerDataSource objectAtIndex:row];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:[self getCurrencyCode:currency.code] attributes:@{NSForegroundColorAttributeName:[UIColor ezypayGreenColor]}];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.currentCurrency = [self.pickerDataSource objectAtIndex:row];
    NSLog(@"Currency %@", self.currentCurrency.name);
}

#pragma mark - Actions
- (void)getCurrencies {
    CurrencyManager *manager = [[CurrencyManager alloc] init];
    [manager getAllCurriencies:self.user.token successHandler:^(id response) {
        self.pickerDataSource = [CurrencyManager currenciesFromArray:response];
        if([self.pickerDataSource count] > 0) {
            self.currentCurrency = [self.pickerDataSource firstObject];
            [self.currencyPicker reloadAllComponents];
        }
    } failureHandler:^(id response) {
        NSLog(@"Error trying to get currencies");
    }];
}

- (IBAction)displayQrViewController:(id)sender {
    if(!self.isNotification){
        [CoreDataManager deleteDataFromEntity:@"Payment"];
        Payment *payment = [CoreDataManager createEntityWithName:@"Payment"];
        payment.currency = self.currentCurrency;
        payment.cost = [self.txtQuantity.text isEqualToString:@""]? 0.f : [self.txtQuantity.text floatValue];
        payment.tableNumber = self.tableNumber;
        payment.commerce = self.user.userType == EmployeeNavigation ? self.user.boss : self.user;
        payment.employeeId = self.user.userType == EmployeeNavigation  ? self.user.id : 0;
        [self navigateToQRViewController:payment];
    } else {
        if([self.txtQuantity.text floatValue] > 0) {
            [self updatePaymentCurrency];
        }
    }
}

- (void)navigateToQRViewController:(Payment *)payment {
    QRPaymentViewController *viewController = (QRPaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QRPaymentViewController"];
    viewController.tableNumber = payment.tableNumber;
    viewController.cost = payment.cost;
    viewController.user = self.user.userType == EmployeeNavigation ? self.user.boss : self.user;
    viewController.payment = payment;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)updatePaymentCurrency {
    PaymentManager *manager = [[PaymentManager alloc] init];
    [manager updatePaymentAmount:self.paymentId
                        currencyId:self.currentCurrency.id
                          amount:[self.txtQuantity.text floatValue]
                           token:self.user.token
                  successHandler:^(id response) {
                      [self sendBillNotification];
                } failureHandler:^(id response) {
                    NSLog(@"%@", response);
                }];
}

- (void)sendBillNotification {
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager sendBillNotification:self.clientId
                     currencyCode:self.currentCurrency.code
                           amount:[self.txtQuantity.text floatValue]
                        paymentId:self.paymentId
                            token:self.user.token
                   successHandler:^(id response) {
                       NSLog(@"%@", response);
                   } failureHandler:^(id response) {
                       NSLog(@"%@", response);
                   }];
}

- (NSString *)getCurrencyCode:(NSString *) currencyCode {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    return currencySymbol;
}


@end
