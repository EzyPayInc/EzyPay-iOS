//
//  ProfileImageTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "ProfileImageTableViewCell.h"

@implementation ProfileImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)];
    tapGesture.numberOfTapsRequired =1;
    [self.profileImageView addGestureRecognizer:tapGesture];
    [self.profileImageView setMultipleTouchEnabled:YES];
    self.profileImageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)imageViewDidTap {
    [self.delegate imageViewDidTap:self.profileImageView];
}

@end
