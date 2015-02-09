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
                [MobClick event:@"ClickTier1"];

                
                [CommonUtility coinsChange:1000];
                
                [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
                [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];

            }else if([product.productIdentifier isEqualToString:@"sheepcao.mixedMusic.money3000"])
            {
                [MobClick event:@"ClickTier2"];

                [CommonUtility coinsChange:4000];//3元买4000coins
                
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
    NSInteger productCount = _products.count + 3;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"wechatShare"] isEqualToString:@"yes"]) {
        productCount--;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"]) {
        productCount--;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reviewed"] isEqualToString:@"yes"] ||[CommonUtility fetchCoinAmount] > 400) {
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
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"buyCellView" owner:self options:nil] lastObject];//加载nib文件

    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:17];

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

    }else if (indexPath.row == _products.count + 1)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
        cell.textLabel.text = @"分享新浪微博奖励300金币";
        }

    }
    else if ([CommonUtility fetchCoinAmount] < 400 && indexPath.row == _products.count + 2)
    {
        NSLog(@"review!!!");
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"reviewed"] isEqualToString:@"yes"])
        {
            cell.textLabel.text = @"好评一下，奖励300金币";
            
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
    [CommonUtility tapSound:@"click" withType:@"mp3"];
    
    if (indexPath.row < _products.count) {
        SKProduct *product = _products[indexPath.row];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[myIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if(indexPath.row == _products.count)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"wechatShare"] isEqualToString:@"yes"])
        {
            [self shareToWechat];
            
            
        }else if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
            [self shareToSina];

        }
        [self.closeDelegate closingBuy];


        
    }else if(indexPath.row == _products.count + 1)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"sinaShare"] isEqualToString:@"yes"])
        {
            
            [self shareToSina];
            
        }
        [self.closeDelegate closingBuy];


    }else if ([CommonUtility fetchCoinAmount] < 400 )
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"reviewed"] isEqualToString:@"yes"])
        {
        [self reviewUS];
        }
        [self.closeDelegate closingBuy];

    }
    
    
}

-(void)reviewUS
{
    
    [CommonUtility coinsChange:300];
    [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
    [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"reviewed"];
    
    [self.itemsTable reloadData];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
        

    
}

-(void)shareToWechat
{
    [UMSocialSnsService presentSnsIconSheetView:self.parentControler
                                         appKey:@"54c46ea7fd98c5071d000668"
                                      shareText:@"我在玩魔音大师，还挺挑战的，朋友们也来试试!"
                                     shareImage:[UIImage imageNamed:@"iconNew.png"]
                                shareToSnsNames:@[UMShareToWechatTimeline]
                                       delegate:(id)self];
    
    // music url
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:@"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8"];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
}

-(void)shareToSina
{
    [UMSocialSnsService presentSnsIconSheetView:self.parentControler
                                         appKey:@"54c46ea7fd98c5071d000668"
                                      shareText:@"我在玩魔音大师，还挺挑战的，朋友们也来试试!"
                                     shareImage:[UIImage imageNamed:@"iconNew.png"]
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:(id)self];
    
    // music url
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:@"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8"];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        

        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        [CommonUtility coinsChange:300];
        [currentCoinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
        [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
        if([[[response.data allKeys] objectAtIndex:0] isEqualToString:@"sina"])
        {
            [MobClick event:@"CoinFromSina"];

            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"sinaShare"];

        }else if ([[[response.data allKeys] objectAtIndex:0] isEqualToString:@"wxtimeline"])
        {
            [MobClick event:@"CoinFromWechat"];

            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"wechatShare"];

        }
        [self.itemsTable reloadData];

        
    }
}


@end

