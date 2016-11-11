//
//  DropDownTableViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/10/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownActions;
@protocol DropDownActionsDelegate

- (void) didOptionSelected:(NSDictionary *)option inTextField:(UITextField *)textfield;
@end

@interface DropDownTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *sourceData;
@property (nonatomic, weak) id  <DropDownActionsDelegate> delegate;
@property (nonatomic, strong) UITextField *textfield;

@end
