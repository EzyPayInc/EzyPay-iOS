//
//  SignInCommerceImageViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SignInCommerceImageViewController.h"
#import "BottomBorderTextField.h"
#import "UIColor+UIColor.h"

@interface SignInCommerceImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileCommerceImage;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *tablesQuantity;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SignInCommerceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.tablesQuantity.placeholder = NSLocalizedString(@"tablesQuantityPlaceholder", nil);
    self.infoLabel.text = NSLocalizedString(@"tablesInfoLabel", nil);
    [self.nextButton setTitle:NSLocalizedString(@"nextAction", nil) forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 20.f;
    self.profileCommerceImage.layer.cornerRadius = self.profileCommerceImage.frame.size.width / 2;
    self.profileCommerceImage.layer.borderWidth = 2.f;
    self.profileCommerceImage.layer.borderColor = [UIColor grayBackgroundViewColor].CGColor;
}

@end
