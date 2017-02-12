//
//  HistoryTableViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHistory;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *payment;

@end
