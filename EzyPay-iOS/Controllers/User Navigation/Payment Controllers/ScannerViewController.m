//
//  ScannerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "ScannerViewController.h"
#import "RestaurantDetailViewController.h"
#import "BarcodeScannerViewController.h"
#import "TicketManager.h"
#import "UserManager.h"
#import "CoreDataManager.h"

@interface ScannerViewController ()<BarcodeScannerDelegate>

@property (nonatomic, strong) User *user;

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"scannerTitle", nil);
    self.user = [UserManager getUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Ticket *ticket = [TicketManager getTicket];
    if (ticket) {
        [self showRestaurantDetail:ticket];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScanner:(id)sender {
    BarcodeScannerViewController *viewController = (BarcodeScannerViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BarcodeScannerViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)barcodeScannerDidScanBarcode:(NSString *)barcodeString {
    NSError *error;
    NSData *data = [barcodeString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tickeData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error == nil) {
        [self registerTicket:tickeData];
    }
}

- (void)registerTicket:(NSDictionary *)ticketDictionary {
    Ticket *ticket = [TicketManager ticketFromDictionary:ticketDictionary];
    TicketManager *manager = [[TicketManager alloc] init];
    [manager registerTicket:ticket token:self.user.token successHandler:^(id response) {
        [CoreDataManager saveContext];
        [self showRestaurantDetail:ticket];
    } failureHandler:^(id response) {
        NSLog(@"Register ticket request failed");
    }];
    
}

- (void)showRestaurantDetail:(Ticket *)ticket {
    RestaurantDetailViewController *viewController = (RestaurantDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    viewController.ticket = ticket;
    [self.navigationController pushViewController:viewController animated:true];
}


@end
