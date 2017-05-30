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
    //[self displayRightBarButton];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [UserManager getUser];
    self.employeeLabel.text = self.user.name;
    NSString *title = self.user.userType == EmployeeNavigation ? self.user.boss.name : self.user.name;
    self.navigationItem.title = title;
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

- (void) displayRightBarButton {
    UIImage *image = [[UIImage imageNamed:@"ic_add_card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(displayPaymentDetailViewController)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void) displayPaymentDetailViewController {
    PaymentDetailViewController *viewController = (PaymentDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    viewController.tableNumber = 0;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
