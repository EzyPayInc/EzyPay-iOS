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
#import "Payment+CoreDataClass.h"
#import "NavigationController.h"
#import "QRPaymentViewController.h"
#import "PushNotificationManager.h"

@interface PaymentDetailViewController () <UITextFieldDelegate, UIPickerViewDelegate,
UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPicker;

@property (nonatomic, strong) NSArray *pickerDataSource;
@property (nonatomic, strong) Currency *currentCurrency;
@property (nonatomic, assign) CGFloat *cost;

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCurrencies];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual:self.txtCurrency]) {
        [self.txtCost resignFirstResponder];
        [self.view endEditing:YES];
        [self showPicker];
    } else {
        [self closePicker];
    }
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
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Currency *currency = [self.pickerDataSource objectAtIndex:row];
    return currency.name;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.currentCurrency = [self.pickerDataSource objectAtIndex:row];
    self.txtCurrency.text = self.currentCurrency.name;
    [self closePicker];
}

- (void)showPicker {
    self.currencyPicker.hidden = NO;
}

- (void)closePicker {
    self.currencyPicker.hidden = YES;
    
}

#pragma mark - Actions
- (void)getCurrencies {
    CurrencyManager *manager = [[CurrencyManager alloc] init];
    [manager getAllCurriencies:self.user.token successHandler:^(id response) {
        self.pickerDataSource = [CurrencyManager currenciesFromArray:response];
        if([self.pickerDataSource count] > 0) {
            self.currentCurrency = [self.pickerDataSource firstObject];
            self.txtCurrency.text = self.currentCurrency.name;
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
        payment.cost = [self.txtCost.text isEqualToString:@""]? 0.f : [self.txtCost.text floatValue];
        payment.tableNumber = self.tableNumber;
        payment.commerce = self.user.userType == EmployeeNavigation ? self.user.boss : self.user;
        payment.employeeId = self.user.userType == EmployeeNavigation  ? self.user.id : 0;
        [self navigateToQRViewController:payment];
    } else {
        [self sendBillNotification];
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

- (void)sendBillNotification {
    PushNotificationManager *manager = [[PushNotificationManager alloc] init];
    [manager sendBillNotification:self.clientId
                     currencyCode:self.currentCurrency.code
                           amount:[self.txtCost.text floatValue]
                            token:self.user.token
                   successHandler:^(id response) {
                       NSLog(@"%@", response);
                   } failureHandler:^(id response) {
                       NSLog(@"%@", response);
                   }];
}


@end
