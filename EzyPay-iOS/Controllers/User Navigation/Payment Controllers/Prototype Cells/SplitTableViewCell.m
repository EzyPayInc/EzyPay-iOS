//
//  SplitTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SplitTableViewCell.h"
@implementation SplitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.stepValue = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = (int)slider.value * self.stepValue;
    [self.delegate sliderDidChangeValue:value InCell:self WithFriend:self.paymentFriend];
}

-(void)setTotalPayment:(float)totalPayment
{
    _totalPayment = totalPayment;
    float maxValue = _totalPayment / self.stepValue;
    [self.paymentSlider setMaximumValue:maxValue];
}

@end
