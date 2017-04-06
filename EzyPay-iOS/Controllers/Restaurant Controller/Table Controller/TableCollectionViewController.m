//
//  TableCollectionViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "TableCollectionViewController.h"
#import "TableCollectionViewCell.h"
#import "UIColor+UIColor.h"
#import "TableManager.h"
#import "UserManager.h"
#import "AddTableViewController.h"
#import "QRPaymentViewController.h"
#import "NavigationController.h"

@interface TableCollectionViewController ()
@property (nonatomic, strong)NSArray *tables;
@property (nonatomic, strong)User *user;
@end

@implementation TableCollectionViewController

static NSString * const reuseIdentifier = @"TableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];
    if(self.user.userType != EmployeeNavigation) {
        [self displayRightBarButton];
    }
    self.navigationItem.title = NSLocalizedString(@"tableTitle", nil);
    self.collectionView.backgroundColor = [UIColor grayBackgroundViewColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getTables];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tables.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100 , 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableCollectionViewCell *cell = (TableCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Table *table = [self.tables objectAtIndex:indexPath.row];
    cell.tableName.text = [NSString stringWithFormat:@"%@ %lld", NSLocalizedString(@"tableLabel", nil),
                           table.tableNumber];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Table *table = [self.tables objectAtIndex:indexPath.row];
    [self showOptions:table];
}

#pragma mark <UICollectionViewDelegate>
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

#pragma mark Actions
- (void)getTables {
    TableManager *manager = [[TableManager alloc] init];
    int64_t userId = self.user.userType == EmployeeNavigation ?
        [[self.userBoss objectForKey:@"id"] integerValue] : self.user.id;
    [manager getTablesByRestaurantFromServer:userId token:self.user.token successHandler:^(id response) {
        self.tables = [TableManager geTablesFromArray:response withUser:self.user];
        [self.collectionView reloadData];
    } failureHandler:^(id response) {
        NSLog(@"%@", response);
    }];
}

- (void) displayRightBarButton {
    UIImage *image = [[UIImage imageNamed:@"ic_add_card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(showAddTable)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)showAddTable {
    AddTableViewController *viewController = (AddTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTableViewController"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showOptions:(Table *)table {
    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:@"Actions" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *quickPaymentAction = [UIAlertAction actionWithTitle:@"Quick Payment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self quickPaymentAction:table];
    }];
    UIAlertAction *reservationAction = [UIAlertAction actionWithTitle:@"Sync" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reservationAction:table];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:quickPaymentAction];
    [alertController addAction:reservationAction];
    [alertController addAction:cancelAction];
    alertController.disablesAutomaticKeyboardDismissal = NO;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


- (void) reservationAction:(Table *)table {
    [self displayQrViewController: table];
}

- (void) quickPaymentAction:(Table *)table {
    [self displayQrViewController: table];
}

- (void) displayQrViewController:(Table *)table {
    QRPaymentViewController *viewController = (QRPaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QRPaymentViewController"];
    table.restaurant = self.user;
    viewController.table = table;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

