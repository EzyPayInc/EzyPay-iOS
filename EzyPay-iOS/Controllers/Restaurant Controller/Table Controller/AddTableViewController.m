//
//  AddTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "AddTableViewController.h"
#import "CoreDataManager.h"
#import "TableManager.h"
#import "LoadingView.h"

@interface AddTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *tableNumebrAction;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTable;

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"addTableTitle", nil);
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.tableNumebrAction.text = NSLocalizedString(@"tableNumberLabel", nil);
    [self.btnAddTable setTitle:NSLocalizedString(@"addTableAction", nil) forState:UIControlStateNormal];
    self.btnAddTable.layer.cornerRadius = 20.f;
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *generalTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:generalTapRecognizer];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Actions
- (IBAction)addTableAction:(id)sender {
    if(![self.txtTableNumber hasText]) {
        [self displayAlertWithMessage:NSLocalizedString(@"emptyFieldsErrorMessage", nil)];
        return;
    }
    int64_t tableNumber = [self.txtTableNumber.text integerValue];
    Table *table = [CoreDataManager createEntityWithName:@"Table"];
    table.restaurant = self.user;
    table.tableNumber = tableNumber;
    TableManager *manager = [[TableManager alloc] init];
    [LoadingView show];
    [manager registerTable:table token:self.user.token successHandler:^(id response) {
        [LoadingView dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)displayAlertWithMessage:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"errorTitle", nil)
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
