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
    return [UIColor colorWithRed:186.0f/255.0f
                           green:210.0f/255.0f
                            blue:48.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)ezypayDarkGrayColor
{
    return [UIColor colorWithRed:185.0f/255.0f
                           green:185.0f/255.0f
                            blue:185.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)silverColor {
    return [UIColor colorWithRed:178.0f/255.0f
                           green:178.0f/255.0f
                            blue:178.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)lightGreenColor {
    return [UIColor colorWithRed:213.0f/255.0f
                           green:228.0f/255.0f
                            blue:138.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor *)blackEzyPayColor {
    return [UIColor colorWithRed:80.0f/255.0f
                           green:80.0f/255.0f
                            blue:80.0f/255.0f
                           alpha:1.0f];
}
@end
