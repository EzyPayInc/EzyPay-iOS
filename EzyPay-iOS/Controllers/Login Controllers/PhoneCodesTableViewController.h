//
//  PhoneCodesTableViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 8/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhoneCodes;
@protocol PhoneCodesDelegate <NSObject>
- (void)didTapOnCode:(NSString *)phoneCode;
@end

@interface PhoneCodesTableViewController : UITableViewController

@property (nonatomic, assign) id <PhoneCodesDelegate> delegate;

@end
