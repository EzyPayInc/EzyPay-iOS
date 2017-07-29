//
//  HistoryCommerceTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "HistoryCommerceTableViewCell.h"

@implementation HistoryCommerceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblUser.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.lblEmployee.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.lblCost.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
