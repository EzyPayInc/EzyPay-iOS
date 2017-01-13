//
//  SettingsTableViewCell.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SettingsTableViewCell.h"

@interface SettingsTableViewCell() <UITextFieldDelegate>

@end

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.txtValue.delegate = self;
    [self.txtValue addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange :(UITextField *)textField {
    [self.delegate cellTableDidChange:textField inCell:self.cellType];
}

@end
