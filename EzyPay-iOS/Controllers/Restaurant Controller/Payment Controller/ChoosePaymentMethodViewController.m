//
//  ChoosePaymentMethodViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ChoosePaymentMethodViewController.h"

@interface ChoosePaymentMethodViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *quickButton;

@end

@implementation ChoosePaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.titleLabel.text = NSLocalizedString(@"chooseQRLabel", nil);
    [self.syncButton setTitle:NSLocalizedString(@"syncAction", nil) forState:UIControlStateNormal];
    [self.quickButton setTitle:NSLocalizedString(@"quickAction", nil) forState:UIControlStateNormal];
}

- (IBAction)syncAction:(id)sender {
}

- (IBAction)quickAction:(id)sender {
}



@end
