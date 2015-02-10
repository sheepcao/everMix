//
//  buyCoinsViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 1/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "CommonUtility.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "globalVar.h"


@interface buyCoinsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) UIView *centerView;

@property (weak,nonatomic) id<closeBuyViewDelegate> closeDelegate;

@property (strong, nonatomic) UITableView *itemsTable;
//
//@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
@property (nonatomic,weak) UIViewController *parentControler;
- (id)initWithCoinLabel:(UILabel *)coinLabel andParentController:(UIViewController *)controller andParentCoinButton:(UIButton *)parentCoinsButton andLoadingView:(UIView *)loadingView andTableView:(UITableView *)tableview;
-(void)reloadwithRefreshControl:(UIRefreshControl *)refreshControl;
@end
