//
//  RestaurantDetailViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "ContactListTableViewController.h"
#import "TicketManager.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnBill;
@property (weak, nonatomic) IBOutlet UIButton *btnWaiter;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBill.layer.cornerRadius = 25;
    self.btnBill.layer.borderWidth = 1;
    self.btnBill.layer.borderColor = [[UIColor colorWithRed:(0/255.0) green:(120/255.0) blue:(255/255.0) alpha:1] CGColor];
    self.btnWaiter.layer.cornerRadius = 25;
    self.btnWaiter.layer.borderWidth = 1;
    self.btnWaiter.layer.borderColor = [[UIColor colorWithRed:(0/255.0) green:(120/255.0) blue:(255/255.0) alpha:1] CGColor];
    [self addCancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

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



@end
