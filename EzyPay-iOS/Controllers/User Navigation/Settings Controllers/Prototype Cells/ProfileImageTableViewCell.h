//
//  ProfileImageTableViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileImageView;
@protocol ProfileImageViewDelegate <NSObject>
- (void)imageViewDidTap:(UIImageView *)imageView;
@end

@interface ProfileImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic, assign) id <ProfileImageViewDelegate> delegate;


@end
