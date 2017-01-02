//
//  CardListTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/28/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardListTableViewController.h"
#import "CardManager.h"
#import "UserManager.h"
#import "CardDetailViewController.h"

@interface CardListTableViewController ()

@property (nonatomic, strong)NSArray *cards;
@property (nonatomic, strong)User *user;

@end

@implementation CardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserManager getUser];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
     [self getCardsFromServer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    Card *card = [self.cards objectAtIndex:indexPath.row];
    cell.textLabel.text = card.number;
    cell.imageView.image = [UIImage imageNamed:@"ic_credit_card"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *card = [self.cards objectAtIndex:indexPath.row];
    CardDetailViewController *cardDetailViewController = (CardDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
    cardDetailViewController.card = card;
    cardDetailViewController.viewType = ViewCard;
    [self.navigationController pushViewController:cardDetailViewController animated:true];
}


#pragma mark - actions
- (void)getCardsFromServer {
    CardManager *manager = [[CardManager alloc] init];
    [manager getCardsByUserFromServer:self.user.id token:self.user.token successHandler:^(id response) {
        self.cards = [CardManager getCardsFromArray:response];
        [self.tableView reloadData];
    } failureHandler:^(id response) {
        NSLog(@"Connection Failed");
    }];
}


- (IBAction)showDetailCard:(id)sender {
    CardDetailViewController *cardDetailViewController = (CardDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
    cardDetailViewController.viewType = AddCard;
    [self.navigationController pushViewController:cardDetailViewController animated:true];
}

@end
