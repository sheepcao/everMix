//
//  buyCoinsViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 1/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtility.h"

@interface buyCoinsViewController : NSObject<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) UIView *centerView;
//@property (strong, nonatomic) UITableView *itemsTable;
//
//@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);

-(id)initWithCoinLabel:(UILabel *)coinLabel;
-(void)reloadwithRefreshControl:(UIRefreshControl *)refreshControl andTableView:(UITableView *)tableview;
@end
