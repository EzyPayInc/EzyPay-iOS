//
//  SignInPaymentInformationControllerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SignInPaymentInformationControllerViewController.h"
#import "DropDownTableViewController.h"
#import "CardServiceClient.h"
#import "UserManager.h"
#import "CardManager.h"
#import "Card+CoreDataClass.h"
#import "CoreDataManager.h"
#import "NavigationController.h"

@interface SignInPaymentInformationControllerViewController ()<UITextFieldDelegate, UIPopoverPresentationControllerDelegate, DropDownActionsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCardnumber;
@property (strong, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;

@property (nonatomic, strong) NSArray *arrayMonths;
@property (nonatomic, strong) NSArray *arrayYears;
@end

@implementation SignInPaymentInformationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"signInTitle", nil);
    [self setupDropDowns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)arrayMonths {
    if(_arrayMonths) return _arrayMonths;
    
    _arrayMonths = [NSArray arrayWithObjects:
                    NSLocalizedString(@"januaryMonth", nil), NSLocalizedString(@"februaryMonth", nil), NSLocalizedString(@"marchMonth", nil), NSLocalizedString(@"aprilMonth", nil), NSLocalizedString(@"mayMonth", nil), NSLocalizedString(@"juneMonth", nil), NSLocalizedString(@"julyMonth", nil), NSLocalizedString(@"augustMonth", nil), NSLocalizedString(@"septemberMonth", nil), NSLocalizedString(@"octoberMonth", nil), NSLocalizedString(@"novemberMonth", nil), NSLocalizedString(@"decemberMonth", nil), nil];
    return _arrayMonths;
}

- (int16_t )getMonth:(NSString *)value {
    int16_t month = 0;
    for (NSString *monthName in self.arrayMonths) {
        month = month + 1;
        if([monthName isEqualToString:value]) {
            return month;
        }
    }
    return month;
}

- (NSArray *)arrayYears {
    if(_arrayYears) return _arrayYears;
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:currentDate]; // Get necessary date components
    
    NSInteger year = [components year];
    NSInteger index;
    NSMutableArray *temporalYears = [NSMutableArray array];
    for (index = year; index <= year + 10; index++) {
        [temporalYears addObject: [NSString stringWithFormat: @"%ld", (long)index]];
    }
    
    _arrayYears = temporalYears;
    return _arrayYears;
    
}


- (void)setupDropDowns {
    self.txtMonth.delegate = self;
    self.txtYear.delegate = self;
    self.txtMonth.rightViewMode = UITextFieldViewModeAlways;
    self.txtYear.rightViewMode = UITextFieldViewModeAlways;
    self.txtMonth.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownIcon"]];
    self.txtYear.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownIcon"]];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DropDownTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DropDownTableViewController"];
    controller.textfield = textField;
    controller.delegate = self;
    if([textField isEqual:self.txtMonth]){
        controller.sourceData = self.arrayMonths;
    } else {
        controller.sourceData = self.arrayYears;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.modalPresentationStyle =UIModalPresentationPopover;
    navigationController.preferredContentSize = CGSizeMake(320, 280);
    navigationController.popoverPresentationController.delegate = self;
    navigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    navigationController.popoverPresentationController.sourceView = textField;
    navigationController.popoverPresentationController.sourceRect = textField.bounds;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    return NO;
}

- (IBAction)registerUser:(id)sender {
    [self saveUser];
}

- (void)saveUser {
    UserManager *manager = [[UserManager alloc] init];
    [manager registerUser:self.user successHandler:^(id response) {
        int64_t userId = (long)[[response valueForKey:@"userId"] integerValue];
        self.user.id = userId;
        [self login];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)login {
    UserManager *manager = [[UserManager alloc] init];
    [manager login:self.user.email password:self.user.password successHandler:^(id response) {
        NSDictionary *accessToken = [response valueForKey:@"access_token"];
        NSString *token = [accessToken valueForKey:@"value"];
        self.user.token = token;
        [self saveCard];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)saveCard {
    Card *card = [CoreDataManager createEntityWithName:@"Card"];
    card.number = self.txtCardnumber.text;
    card.cvv = [self.txtCvv.text integerValue];
    card.month = [self getMonth:self.txtMonth.text];
    card.year = [self.txtYear.text integerValue];
    card.user = self.user;
    CardManager *manager = [[CardManager alloc] init];
    [manager registerCard:card token:self.user.token successHandler:^(id response) {
        [self.user addCardsObject:card];
        [CoreDataManager saveContext];
        NavigationController *navigationController = [NavigationController sharedInstance];
        navigationController.navigationType = UserNavigation;
        [navigationController presentTabBarController:self];
    } failureHandler:^(id response) {
        NSLog(@"Error: %@", response);
    }];
}

- (void)showServerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}


- (void) didOptionSelected:(NSDictionary *)option inTextField:(UITextField *)textfield{
    [self dismissViewControllerAnimated:YES completion:nil];
    textfield.text = [option valueForKey:@"value"];
}

@end
