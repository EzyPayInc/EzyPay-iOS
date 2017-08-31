//
//  EditablePhoneViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 8/30/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditablePhone;
@protocol EditablePhoneDelegate <NSObject>
- (void)didSavePhone:(NSString *)phoneNumber;
@end

@interface EditablePhoneViewController : UIViewController

@property (nonatomic, assign) id <EditablePhoneDelegate> delegate;

@end
