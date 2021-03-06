//
//  CardListTableViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 12/28/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardListTableViewController.h"
#import "UserManager.h"
#import "CardManager.h"
#import "CardDetailViewController.h"
#import "UIColor+UIColor.h"
#import "LoadingView.h"
#import "ValidateCardInformationHelper.h"

@interface CardListTableViewController ()

@property (nonatomic, strong)NSArray *cards;
@property (nonatomic, strong)User *user;

@end

static NSString *const CARD_STARTS = @"**** ";

@implementation CardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"paymentTitle", nil);
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.cards.count > 0 ? NSLocalizedString(@"cardsLabel", nil) : @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIButton* btnAddCard = [[UIButton alloc] initWithFrame:
                            CGRectMake(0, 100, 200, 50)];
    btnAddCard.center = CGPointMake(CGRectGetMidX(self.view.bounds), btnAddCard.center.y);
    btnAddCard.layer.cornerRadius = 25.f;
    btnAddCard.backgroundColor = [UIColor ezypayGreenColor];
    [btnAddCard setTitle:NSLocalizedString(@"addCardAction", nil) forState:UIControlStateNormal];
    [btnAddCard setImage:[UIImage imageNamed:@"ic_add_card"] forState:UIControlStateNormal];
    [btnAddCard addTarget:self action:@selector(goToDetailCard) forControlEvents:UIControlEventTouchDown];
    btnAddCard.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [view  addSubview:btnAddCard];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    Card *card = [self.cards objectAtIndex:indexPath.row];
    NSString *lastCharacters = [card.cardNumber substringFromIndex:MAX((int)[card.cardNumber length]-4, 0)];
    cell.textLabel.text = [CARD_STARTS stringByAppendingString:lastCharacters];
    cell.imageView.image = [self creditCardIcon:card];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor = [UIColor blackEzyPayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *card = [self.cards objectAtIndex:indexPath.row];
    CardDetailViewController *cardDetailViewController = (CardDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
    cardDetailViewController.card = card;
    cardDetailViewController.viewType = ViewCard;
    [self.navigationController pushViewController:cardDetailViewController animated:true];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Card *card = [self.cards objectAtIndex:indexPath.row];
        [self validateDeleteAction:card];
    }
}


#pragma mark - actions
- (void)getCardsFromServer {
    [LoadingView show];
    CardManager *manager = [[CardManager alloc] init];
    [manager getCardsByUserFromServer:self.user.id token:self.user.token successHandler:^(id response) {
        [LoadingView dismiss];
        self.cards = [CardManager getCardsFromArray:response];
        [self.tableView reloadData];
    } failureHandler:^(id response) {
        [LoadingView dismiss];
        NSLog(@"Connection Failed");
    }];
}

- (void)goToDetailCard {
    CardDetailViewController *cardDetailViewController = (CardDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
    cardDetailViewController.viewType = AddCard;
    [self.navigationController pushViewController:cardDetailViewController animated:true];
}

- (UIImage *)creditCardIcon:(Card *)card {
    return [ValidateCardInformationHelper getCardImage:card.cardVendor];
}

- (void)validateDeleteAction:(Card *)card {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"deleteTitle", nil)
                                                                   message:NSLocalizedString(@"deleteConfirmationMessage", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yesAction", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self deleteAction:card];
                                                     }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"noAction", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteAction:(Card *)card {
    if(!card.isFavorite) {
        [LoadingView show];
        CardManager *manager = [[CardManager alloc] init];
        [manager deleteCard:card.serverId
                       user:self.user successHandler:^(id response) {
                           [LoadingView dismiss];
                           [self getCardsFromServer];
                       }
             failureHandler:^(id response) {
                 [LoadingView dismiss];
                 NSLog(@"Error deleting card");
             }];
    } else {
        [self displayErrorMessage:NSLocalizedString(@"cardDeleteValidation", nil)];
        [self.tableView reloadData];
    }
}

- (void)displayErrorMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
