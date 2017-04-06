//
//  ContactTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width / 2;
    self.userProfileImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
