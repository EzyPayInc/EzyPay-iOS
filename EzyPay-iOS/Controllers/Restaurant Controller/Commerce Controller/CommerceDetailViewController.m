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
@property (weak, nonatomic) IBOutlet UILabel *lblCommerceName;
@property (weak, nonatomic) IBOutlet UIImageView *commerceImageView;

@property (nonatomic, strong) User *user;

@end

@implementation CommerceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayRightBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [UserManager getUser];
    if(self.user.userType == EmployeeNavigation) {
        self.lblCommerceName.text = self.user.boss.name;
    } else {
         self.lblCommerceName.text = self.user.name;
    }
    [self getImage];
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
