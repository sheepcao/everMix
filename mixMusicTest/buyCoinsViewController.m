//
//  buyCoinsViewController.m
//  mixMusicTest
//
//  Created by Eric Cao on 1/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "buyCoinsViewController.h"
#import "myIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface buyCoinsViewController (){
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
    UILabel *currentCoinsLabel;
}
@end

@implementation buyCoinsViewController

- (id)initWithCoinLabel:(UILabel *)coinLabel {
    
   	self = [super init];
    if (self != nil) {
        
        currentCoinsLabel = coinLabel;
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        
    }
    return self;
//    [super viewDidLoad];
//    
//    self.itemsTable = [[UITableView alloc] initWithFrame:CGRectMake(37, 115, 246, 337)];
//    self.itemsTable.delegate = self;
//    self.itemsTable.dataSource = self;
//    
//
//    [self.view addSubview:self.itemsTable];


    
    
//    [self.itemsTable setBackgroundColor:[UIColor colorWithRed:17/255.0f green:42/255.0f blue:75/255.0f alpha:1.0]];
//    [self.view setBackgroundColor:[UIColor colorWithRed:15/255.0f green:15/255.0f blue:15/255.0f alpha:1.0]];
   
//    [self.view setBackgroundColor:[UIColor clearColor]];
//    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
//    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.3]];
//    [self.itemsTable setBackgroundColor:[[UIColor colorWithRed:17/255.0f green:42/255.0f blue:75/255.0f] colorWithAlphaComponent:1.0]];

//    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.01]];
//    [self.itemsTable setBackgroundColor:[[UIColor colorWithRed:17/255.0f green:42/255.0f blue:75/255.0f alpha:1.0] colorWithAlphaComponent:1.0]];
    
    // Do any additional setup after loading the view from its nib.
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.itemsTable addSubview:self.refreshControl];
//
//    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
//    [self reload];
//    [self.refreshControl beginRefreshing];
    

    
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
//            [self.itemsTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            *stop = YES;
            
            if ([product.productIdentifier isEqualToString:@"sheepcao.mixedMusic.money"]) {
                [CommonUtility coinsChange:1000];
                
                [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
                
            }
        }
    }];
    
    
    
}

-(void)reloadwithRefreshControl:(UIRefreshControl *)refreshControl andTableView:(UITableView *)tableview{
    _products = nil;
//    [self.itemsTable reloadData];
    [[myIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [tableview reloadData];
        }
        [refreshControl endRefreshing];
    }];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"1");
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"2");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    [cell.textLabel setTextColor:[UIColor whiteColor]];

    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];


    
//    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    buyButton.frame = CGRectMake(0, 0, 72, 37);
//    [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
//    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    buyButton.tag = indexPath.row;
//    [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.accessoryView = buyButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *product = _products[indexPath.row];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[myIAPHelper sharedInstance] buyProduct:product];
}
//- (void)buyButtonTapped:(id)sender {
//
//    
//    UIButton *buyButton = (UIButton *)sender;
//    SKProduct *product = _products[buyButton.tag];
//    
//    NSLog(@"Buying %@...", product.productIdentifier);
//    [[myIAPHelper sharedInstance] buyProduct:product];
//    
//}

@end

