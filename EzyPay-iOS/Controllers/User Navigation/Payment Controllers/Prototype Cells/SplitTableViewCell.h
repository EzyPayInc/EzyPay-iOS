//
//  SplitTableViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataClass.h"

@class SplitCell, SplitTableViewCell;
@protocol SplitCellDelegate <NSObject>
- (void)sliderDidChangeValue:(float)value
                      InCell:(SplitTableViewCell *)splitCell
                  WithFriend:(Friend *)paymentFriend;
@end

@interface SplitTableViewCell : UITableViewCell

@property (nonatomic, assign) id <SplitCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UISlider *paymentSlider;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (nonatomic, assign)float totalPayment, stepValue, lastValue;
@property (nonatomic, strong)Friend *paymentFriend;

@end
