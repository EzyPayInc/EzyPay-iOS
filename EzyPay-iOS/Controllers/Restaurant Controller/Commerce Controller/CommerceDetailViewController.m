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
#import "LoginViewController.h"
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)getImage {
    int64_t id = self.user.userType == EmployeeNavigation ? self.user.boss.id : self.user.id;
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:id
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
    LocalToken *localToken = [DeviceTokenManager getDeviceToken];
    DeviceTokenManager *manager = [[DeviceTokenManager alloc] init];
    [manager deleteDeviceToken:localToken.deviceId user:self.user successHandler:^(id response) {
        localToken.isSaved = 0;
        [CoreDataManager saveContext];
        LoginViewController *viewController = (LoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [UserManager deleteUser];
        [self presentViewController:viewController animated:YES completion:nil];
    } failureHandler:^(id response) {
        NSLog(@"Response %@", response);
    }];
}

@end
