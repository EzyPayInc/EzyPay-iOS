//
//  HistoryTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.restaurantName.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.payment.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
