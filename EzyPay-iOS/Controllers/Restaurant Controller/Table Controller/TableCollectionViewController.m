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
#import "PaymentDetailViewController.h"
#import "NavigationController.h"
#import "ChoosePaymentMethodViewController.h"
#import "UIColor+UIColor.h"
#import "LoadingView.h"

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
    [self setupRefreshCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getTables];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshCollectionView {
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.refreshControl.backgroundColor = [UIColor whiteColor];
    self.collectionView.refreshControl.tintColor = [UIColor grayColor];
    [self.collectionView.refreshControl addTarget:self
                                    action:@selector(refreshAction)
                          forControlEvents:UIControlEventValueChanged];
}

- (void)refreshAction {
    [self getTables];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tables.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80 , 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableCollectionViewCell *cell = (TableCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Table *table = [self.tables objectAtIndex:indexPath.row];
    cell.circleView.backgroundColor = table.isActive == 1 ? [UIColor silverColor] : [UIColor ezypayGreenColor];
    cell.tableName.text = [NSString stringWithFormat:@"%lld", table.tableNumber];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Table *table = [self.tables objectAtIndex:indexPath.row];
    [self displayPaymentDetailViewController:table];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark <UICollectionViewDelegate>
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

#pragma mark Actions
- (void)getTables {
    [LoadingView show];
    TableManager *manager = [[TableManager alloc] init];
    int64_t userId = self.user.userType == EmployeeNavigation ?
        self.user.boss.id : self.user.id;
    [manager getTablesByRestaurantFromServer:userId
                                       token:self.user.token
                              successHandler:^(id response) {
        [self.collectionView.refreshControl endRefreshing];
        self.tables = [TableManager geTablesFromArray:response withUser:self.user];
        [self.collectionView reloadData];
        [LoadingView dismiss];
                              } failureHandler:^(id response) {
        NSLog(@"%@", response);
        [LoadingView dismiss];
        [self.collectionView.refreshControl endRefreshing];
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

- (void) displayPaymentDetailViewController:(Table *)table {
    ChoosePaymentMethodViewController *viewController = (ChoosePaymentMethodViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePaymentMethodViewController"];
    viewController.tableNumber = table.tableNumber;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

