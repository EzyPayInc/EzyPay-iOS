//
//  LoginViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/26/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RestaurantType,
    UserType
}LoginUserType;

@interface LoginViewController : UIViewController

@property (nonatomic, assign) LoginUserType loginType;

@end
