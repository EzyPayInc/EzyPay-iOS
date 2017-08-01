//
//  LoadingView.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 7/31/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView *)loadingViewInView:(UIView *)superView;
- (void)removeView;

@end
