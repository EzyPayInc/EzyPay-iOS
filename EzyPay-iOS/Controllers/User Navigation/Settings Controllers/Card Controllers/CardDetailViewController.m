//
//  CardDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardDetailViewController.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "CardManager.h"
#import "CardIO.h"

@interface CardDetailViewController ()<UITextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtExpirationDate;
@property (weak, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (nonatomic, strong) User *user;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self roundedViews];
    self.user = [UserManager getUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -Actions
- (void)setupView {
    switch (self.viewType) {
        case ViewCard:
            [self setupViewWithInteractionEnabled:NO];
            break;
        case AddCard:
            [self setupViewWithInteractionEnabled:YES];
            break;
        case EditCard:
            [self setupViewWithInteractionEnabled:YES];
            break;
        default:
            break;
    }
    
}

- (void)setupViewWithInteractionEnabled:(BOOL)userInteractionEnabled {
    [self populateFields];
    self.txtCvv.userInteractionEnabled = userInteractionEnabled;
    self.txtCardNumber.userInteractionEnabled = userInteractionEnabled;
    self.txtExpirationDate.userInteractionEnabled = userInteractionEnabled;
    self.btnAction.hidden = !userInteractionEnabled;
    if(!userInteractionEnabled) {
        [self addEditButton];
        self.txtCardNumber.rightView = nil;
    } else {
        [self removeEditButton];
        [self addScanAction];
    }
    self.txtExpirationDate.delegate = self;
    self.txtCardNumber.delegate = self;
    self.txtCvv.delegate = self;
    
}

- (void) setupViewEditType {
    self.txtCvv.userInteractionEnabled = YES;
    self.txtCardNumber.userInteractionEnabled = YES;
    self.txtExpirationDate.userInteractionEnabled = YES;
    self.btnAction.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addScanAction {
    
    UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_micro_camera"]];
    cameraIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.txtCardNumber.rightViewMode = UITextFieldViewModeAlways;
    self.txtCardNumber.rightView = cameraIcon;
    self.txtCardNumber.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *scanGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(scanCardAction)];
    [self.txtCardNumber.rightView addGestureRecognizer:scanGesture];
}

- (void)roundedViews {
    self.btnAction.layer.cornerRadius = 20.f;
}

- (void)populateFields {
    if(self.card) {
        self.txtExpirationDate.text = [NSString stringWithFormat:@"%hd/%hd", self.card.month, self.card.year];
        self.txtCardNumber.text = self.card.number;
        self.txtCvv.text = [NSString stringWithFormat:@"%hd", self.card.cvv];
    }
}

- (void) addEditButton {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)removeEditButton {
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)editAction:(id)sender{
    self.viewType = EditCard;
    [self setupView];
}

- (IBAction)submitAction:(id)sender {
    if([self isCardNumberValid] && [self isCvvValid] && [self isDateValid]) {
        Card *card = [CoreDataManager createEntityWithName:@"Card"];
        card.id = self.card.id;
        card.user = self.user;
        card.number = [self.txtCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        card.cvv = [self.txtCvv.text integerValue];
        NSString *expirationDate = self.txtExpirationDate.text;
        card.month = [[[expirationDate componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
        card.year = [[[expirationDate componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
        switch (self.viewType) {
            case AddCard:
                [self registerCard:card];
                break;
            case EditCard:
                [self updateCard:card];
                break;
            default:
                break;
        }
    } else {
        [self displayErrorMessage];
    }

}

- (void)registerCard:(Card *)card {
    CardManager *manager = [[CardManager alloc] init];
    [manager registerCard:card token:self.user.token successHandler:^(id response) {
        [self.navigationController popViewControllerAnimated:true];
    } failureHandler:^(id response) {
        NSLog(@"Connection Failed");
    }];
}

- (void)updateCard:(Card *)card {
    CardManager *manager = [[CardManager alloc] init];
    [manager updateCardInServer:card token:self.user.token successHandler:^(id response) {
        self.viewType = ViewCard;
        self.card = card;
        [self setupView];
    } failureHandler:^(id response) {
        NSLog(@"Connection Failed");
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.txtExpirationDate]){
        return [self expirationDateFormat:textField string:string];
    } else if ([textField isEqual:self.txtCvv]) {
        return [self cvvFormtat:textField string:string];
    } else if ([textField isEqual:self.txtCardNumber]){
        return [self cardNumberFormat:textField string:string];
    }
    return YES;
}

- (BOOL)expirationDateFormat:(UITextField *)textField string:(NSString *)string {
    NSString *expirationDate = [textField.text stringByAppendingString:string];
    if(expirationDate.length == 2 && string.length > 0) {
        textField.text = [expirationDate stringByAppendingString:@"/"];
        return NO;
    }

    if(expirationDate.length > 5) {
        return NO;
    }
    if(expirationDate.length == 1) {
        NSInteger dateToNumber = [expirationDate integerValue];
        if(dateToNumber > 1) {
            self.txtExpirationDate.text = [NSString stringWithFormat:@"0%@/",expirationDate];
            return NO;
        }
    }
    return YES;
}

- (BOOL)cvvFormtat:(UITextField *)textField string:(NSString *)string {
    NSString *cvvString = [textField.text stringByAppendingString:string];
    return cvvString.length > 3? NO : YES;
}

- (BOOL)cardNumberFormat:(UITextField *)textField string:(NSString *)string {
    NSString *cardNumber = [textField.text stringByAppendingString:string];
    if (cardNumber.length < 20){
        if([cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""].length % 4 == 0 && string.length > 0){
            textField.text = [cardNumber stringByAppendingString:@" "];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)isCardNumberValid {
    return !(self.txtCardNumber.text.length < 16);
}

- (BOOL)isCvvValid {
    return (self.txtCvv.text.length >= 3) && ([self isNumeric:self.txtCvv.text]);
}

- (BOOL)isDateValid {
    NSString *expirationDate = self.txtExpirationDate.text;
    if(expirationDate.length >= 4) {
        NSArray *array = [expirationDate componentsSeparatedByString:@"/"];
        if([array count] == 2) {
            return [self isNumeric:array[0]] && [self isNumeric:array[1]];
        }
    }
    return false;
}

- (BOOL)isNumeric:(NSString *)string {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [numberFormatter numberFromString:string];
    if (number != nil) {
        return YES;
    }
    return NO;
}

- (void)displayErrorMessage {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Invalid data."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scanCardAction {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    scanViewController.hideCardIOLogo = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *cardData = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
    NSLog(@"Card Data : %@", cardData);
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
