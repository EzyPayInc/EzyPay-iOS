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
#import "ValidateCardInformationHelper.h"

@interface CardDetailViewController ()<UITextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cvvLabel;

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
    [self.txtExpirationDate addTarget:self action:@selector(creditCardExpiryFormatter:) forControlEvents:UIControlEventEditingChanged];
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
    self.cardNumberLabel.text = NSLocalizedString(@"cardNumberPlaceholder", nil);
    self.expDateLabel.text = NSLocalizedString(@"expirationDatePlaceholder", nil);
    self.cvvLabel.text = NSLocalizedString(@"cvvPlaceholder", nil);
    [self.btnAction setTitle:NSLocalizedString(@"saveAction", nil) forState:UIControlStateNormal];
    self.txtCvv.userInteractionEnabled = userInteractionEnabled;
    self.txtCardNumber.userInteractionEnabled = self.viewType == AddCard;
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
    
    if(self.viewType == AddCard) {
        UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_micro_camera"]];
        cameraIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.txtCardNumber.rightViewMode = UITextFieldViewModeAlways;
        self.txtCardNumber.rightView = cameraIcon;
        self.txtCardNumber.rightView.userInteractionEnabled = YES;
        UITapGestureRecognizer *scanGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(scanCardAction)];
        [self.txtCardNumber.rightView addGestureRecognizer:scanGesture];
    }
}

- (void)roundedViews {
    self.btnAction.layer.cornerRadius = 20.f;
}

- (void)populateFields {
    if(self.card) {
        NSArray *dateComponents = [self.card.expirationDate componentsSeparatedByString:@"/"];
        NSString *year = [dateComponents[1] substringWithRange:NSMakeRange(2, 2)];
        self.txtExpirationDate.text = [NSString stringWithFormat:@"%@/%@",
                                       dateComponents[0], year];
        self.txtCardNumber.text = self.card.cardNumber;
        self.txtCvv.text = [NSString stringWithFormat:@"%hd", self.card.ccv];
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
    if([ValidateCardInformationHelper validateCardNumber:self.txtCardNumber.text
                                                     cvv:self.txtCvv.text
                                          expirationDate:self.txtExpirationDate.text
                                                viewType:self.viewType
                                          viewController:self]) {
        Card *card = [CoreDataManager createEntityWithName:@"Card"];
        card.id = self.card.id;
        card.user = self.user;
        card.cardNumber = self.txtCardNumber.text;
        card.ccv = [self.txtCvv.text integerValue];
        card.serverId = self.card.serverId;
        card.token = self.card.token;
        card.expirationDate = [ValidateCardInformationHelper getDateFormated:self.txtExpirationDate.text];
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
    [manager registerCard:card user:self.user successHandler:^(id response) {
        [self.navigationController popViewControllerAnimated:true];
    } failureHandler:^(id response) {
        NSLog(@"Connection Failed");
    }];
}

- (void)updateCard:(Card *)card {
    CardManager *manager = [[CardManager alloc] init];
    [manager updateCard:card user:self.user successHandler:^(id response) {
        self.viewType = ViewCard;
        self.card = card;
        [self setupView];
    } failureHandler:^(id response) {
        NSLog(@"Connection Failed");
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField isEqual:self.txtExpirationDate]){
        return [ValidateCardInformationHelper validateExpirationDate:textField
                                       shouldChangeCharactersInRange:range
                                                              string:string];
    } else if ([textField isEqual:self.txtCvv]) {
        return [ValidateCardInformationHelper validateCvvValue:textField string:string];
    } else if ([textField isEqual:self.txtCardNumber]){
        return [ValidateCardInformationHelper validateCardNumberValue:textField
                                        shouldChangeCharactersInRange:range
                                                               string:string];
    }
    return YES;
}

- (void)creditCardExpiryFormatter:(id)sender {
    [ValidateCardInformationHelper creditCardExpiryFormatter:self.txtExpirationDate];
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
    
    self.txtCardNumber.text = [ValidateCardInformationHelper setCardNumberFormat:[NSMutableString stringWithFormat:@"%@", info.cardNumber]];
    NSString *year = [[NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear]
                      substringWithRange:NSMakeRange(2, 2)];
    self.txtExpirationDate.text = [NSString stringWithFormat:@"%02lu/%@",
                                   (unsigned long)info.expiryMonth, year];
    self.txtCvv.text = info.cvv;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
