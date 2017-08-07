//
//  CommerceDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "CommerceDetailViewController.h"
#import "UserManager.h"
#import "NavigationController.h"
#import "PaymentDetailViewController.h"
#import "DeviceTokenManager.h"
#import "ChooseViewController.h"
#import "TableCollectionViewController.h"
#import "CoreDataManager.h"

@interface CommerceDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *commerceImageView;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeEmployeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerateQR;

@property (nonatomic, strong) User *user;

@end

@implementation CommerceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [UserManager getUser];
    if(self.user.userType == EmployeeNavigation) {
        self.employeeLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.name, self.user.lastName];
        self.navigationItem.title = self.user.boss.name;
    } else {
        self.employeeLabel.text = self.user.name;
        self.navigationItem.title = self.user.name;
    }
    [self getImage];
}

- (void)setupView {
    self.commerceImageView.layer.borderWidth = 2.0f;
    self.commerceImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.commerceImageView.layer.cornerRadius = self.commerceImageView.frame.size.width / 2;
    self.commerceImageView.clipsToBounds = YES;
    NSMutableAttributedString *underlineString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"changeEmployeeLabel", nil)];
    [underlineString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[underlineString length]}];
    self.signInLabel.text = NSLocalizedString(@"currentlySignedInLabel", nil);
    self.changeEmployeeLabel.attributedText = underlineString;
    [self.btnGenerateQR setTitle:  NSLocalizedString(@"generateQRAction", nil) forState:UIControlStateNormal];
    self.btnGenerateQR.layer.cornerRadius = 20.f;
    
    UITapGestureRecognizer *gestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(logOutAction)];
    [self.changeEmployeeLabel setUserInteractionEnabled:YES];
    [self.changeEmployeeLabel addGestureRecognizer:gestureRecognizer];
    self.employeeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)getImage {
    NSString *avatar = self.user.userType == EmployeeNavigation ? self.user.boss.avatar : self.user.avatar;
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:avatar
               toImageView:self.commerceImageView
              defaultImage:@"restaurant"];
}

- (IBAction)generateQRAction:(id)sender {
    if(self.user.userType == EmployeeNavigation && self.user.boss.userType == RestaurantNavigation) {
        [self displayTablesViewController];
    } else {
        [self displayPaymentDetailViewController];
    }
}

- (void)displayPaymentDetailViewController {
    PaymentDetailViewController *viewController = (PaymentDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    viewController.tableNumber = 0;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)displayTablesViewController {
    TableCollectionViewController *viewController = (TableCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TableCollectionViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)logOutAction {
    [NavigationController logoutUser:self.user fromViewController:self];
}

@end
