//
//  UIColor+UIColor.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "UIColor+UIColor.h"

@implementation UIColor (UIColor)


+ (UIColor *)grayBackgroundViewColor
{
    return [UIColor colorWithRed:102.0f/255.0f
                           green:102.0f/255.0f
                            blue:102.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)ezypayGreenColor
{
    return [UIColor colorWithRed:207.0f/255.0f
                           green:222.0f/255.0f
                            blue:40.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)ezypayDarkGrayColor
{
    return [UIColor colorWithRed:185.0f/255.0f
                           green:185.0f/255.0f
                            blue:185.0f/255.0f
                           alpha:1.0f];
}
@end
