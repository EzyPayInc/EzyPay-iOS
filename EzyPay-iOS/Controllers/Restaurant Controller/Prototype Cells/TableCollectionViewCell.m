//
//  TableCollectionViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "TableCollectionViewCell.h"

@implementation TableCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
}

@end
