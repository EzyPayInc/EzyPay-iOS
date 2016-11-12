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
    [self setupDropDowns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *) arrayMonths {
    if(_arrayMonths) return _arrayMonths;
    
    _arrayMonths = [NSArray arrayWithObjects: @"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"Octuber", @"November", @"December", nil];
    return _arrayMonths;
}

- (NSArray *) arrayYears {
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

- (IBAction)saveCard:(id)sender {
    
    NSMutableDictionary *cardictionary = [NSMutableDictionary dictionary];
    [cardictionary setValue:self.idUser forKey:@"idUser"];
    [cardictionary setValue:self.txtCardnumber.text forKey:@"cardNumber"];
    [cardictionary setValue:self.txtCvv.text forKey:@"cvv"];
    [cardictionary setValue:self.txtMonth.text forKey:@"month"];
    [cardictionary setValue:self.txtYear.text forKey:@"year"];
    CardServiceClient *service = [[CardServiceClient alloc] init];
    [service registerCard:cardictionary successHandler:^(id response) {
        NSLog(@"%@", response);
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
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
    textfield.text = [option valueForKey:@"value"];
}

@end
