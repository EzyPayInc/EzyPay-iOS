//
//  ContactTableViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/5/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
