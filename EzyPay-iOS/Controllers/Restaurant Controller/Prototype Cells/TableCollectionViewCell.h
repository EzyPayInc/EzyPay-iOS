//
//  TableCollectionViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (weak, nonatomic) IBOutlet UILabel *tableName;

@end
