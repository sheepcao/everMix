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
    UIButton *_parentCoinsButton;
}
@end

@implementation buyCoinsViewController

- (id)initWithCoinLabel:(UILabel *)coinLabel andParentController:(UIViewController *)controller adnParentCoinButton:(UIButton *)parentCoinsButton{
    
   	self = [super init];
    if (self != nil) {
        
        _parentCoinsButton = parentCoinsButton;
        self.parentControler = controller;
        
        currentCoinsLabel = coinLabel;
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        
    }
    return self;

    
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
                
                [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];

            }else if([product.productIdentifier isEqualToString:@"sheepcao.mixedMusic.money3000"])
            {
                [CommonUtility coinsChange:5000];//3元买5000coins
                
                [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
                [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
            }
                
        }
    }];
    
    
    
}

-(void)reloadwithRefreshControl:(UIRefreshControl *)refreshControl andTableView:(UITableView *)tableview{
    _products = nil;
    self.itemsTable = tableview;
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
    NSInteger productCount = _products.count + 2;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"wechatShare"] isEqualToString:@"yes"]) {
        productCount--;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"]) {
        productCount--;
    }
    
    return productCount;
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
    [cell.textLabel setTextColor:[UIColor whiteColor]];

    if (indexPath.row < _products.count) {
        SKProduct * product = (SKProduct *) _products[indexPath.row];
        cell.textLabel.text = product.localizedTitle;
    }else if (indexPath.row == _products.count)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"wechatShare"] isEqualToString:@"yes"])
        {
        cell.textLabel.text = @"分享朋友圈奖励300金币";
        }else if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
            cell.textLabel.text = @"分享新浪微博奖励300金币";

        }

    }else
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
        cell.textLabel.text = @"分享新浪微博奖励300金币";
        }

    }



//    [_priceFormatter setLocale:product.priceLocale];
//    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];


    
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
    if (indexPath.row < _products.count) {
        SKProduct *product = _products[indexPath.row];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[myIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if(indexPath.row == _products.count)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"wechatShare"] isEqualToString:@"yes"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"wechatShare"];
            [CommonUtility coinsChange:300];
            [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
            
            
        }else if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
            [self shareToSina];

        }

        
    }else
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
            
            [self shareToSina];
            
        }

    }

}

-(void)shareToSina
{
    [UMSocialSnsService presentSnsIconSheetView:self.parentControler
                                         appKey:@"54c46ea7fd98c5071d000668"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:(id)self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        if([[[response.data allKeys] objectAtIndex:0] isEqualToString:@"sina"])
        {
            [CommonUtility coinsChange:300];
            [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
            [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"sinaShare"];
            [self.itemsTable reloadData];

        }
        
    }
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

