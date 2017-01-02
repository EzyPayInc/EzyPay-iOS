//
//  CardDetailViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card+CoreDataClass.h"

typedef enum {
    ViewCard,
    AddCard,
    EditCard
}CardDetailViewType;

@interface CardDetailViewController : UIViewController

@property(nonatomic, strong)Card *card;
@property(nonatomic, assign)CardDetailViewType viewType;

@end
