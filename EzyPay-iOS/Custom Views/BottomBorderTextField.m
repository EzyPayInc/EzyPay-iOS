//
//  BottomBorderTextField.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 5/23/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BottomBorderTextField.h"

@implementation BottomBorderTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.5;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

@end
