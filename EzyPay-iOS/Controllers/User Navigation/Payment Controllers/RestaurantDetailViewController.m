//
//  RestaurantDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "ContactListTableViewController.h"
#import "UserManager.h"
#import "TicketManager.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnBill;
@property (weak, nonatomic) IBOutlet UIButton *btnWaiter;
@property (weak, nonatomic) IBOutlet UILabel *lblCommerceName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;

@property (nonatomic, strong) User *user;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Restaurant";
    self.user = [UserManager getUser];
    [self addCancelButton];
    [self getRestaurantInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (void)getRestaurantInfo
{
    UserManager *manager = [[UserManager alloc] init];
    [manager getUserFromServer:self.ticket.restaurantId token:self.user.token successHandler:^(id response) {
        self.lblCommerceName.text = [[response objectForKey:@"name"] uppercaseString];
        [self getImage];
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
}

- (void)addCancelButton {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)cancelAction {
    [TicketManager deleteTicket];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)payBill:(id)sender {
    ContactListTableViewController *tableViewController = (ContactListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactListTableViewController"];
    [self.navigationController pushViewController:tableViewController animated:true];
}


- (void)getImage {
    UserManager *manager = [[UserManager alloc] init];
    [manager downloadImage:self.ticket.restaurantId
               toImageView:self.restaurantImageView
              defaultImage:@"restaurant"];
}

@end
