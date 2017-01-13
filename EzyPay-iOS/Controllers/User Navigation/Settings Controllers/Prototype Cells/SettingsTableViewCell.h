//
//  SettingsTableViewCell.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NameCell = 1,
    LastNameCell = 2,
    PhoneNumberCell = 3,
    EmailCell = 4
}SettingsCellTypes;

@class SettingsCell;
@protocol SettingsCellDelegate <NSObject>
- (void)cellTableDidChange:(UITextField *)textField inCell:(SettingsCellTypes) cellType;
@end

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField *txtValue;

@property (nonatomic, assign)SettingsCellTypes cellType;

@property (nonatomic, assign) id <SettingsCellDelegate> delegate;

@end
