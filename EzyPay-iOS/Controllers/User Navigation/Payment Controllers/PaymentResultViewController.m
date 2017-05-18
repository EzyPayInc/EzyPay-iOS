//
//  PaymentResultViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 5/18/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentResultViewController.h"

@interface PaymentResultViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *btnGoHome;


@end

@implementation PaymentResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupView {
    self.containerView.layer.cornerRadius = self.containerView.frame.size.width / 2;
    self.resultView.layer.cornerRadius = self.resultView.frame.size.width / 2;
    self.btnGoHome.layer.cornerRadius = 20.f;
}


@end
