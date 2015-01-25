//
//  ViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameViewController.h"
#import "buyCoinsViewController.h"

@interface ViewController : UIViewController<prepareSongsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (weak, nonatomic) IBOutlet UIButton *begainGame;
@property (weak, nonatomic) IBOutlet UIButton *continueGame;

- (IBAction)starTapped:(UIButton *)sender;
- (IBAction)continueTapped:(UIButton *)sender;

- (IBAction)beginTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *bugCoinsBtn;
@property (strong, nonatomic) IBOutlet UIButton *coinsShowing;

- (IBAction)buyCoinsTapped:(id)sender;

@property (strong,nonatomic) NSMutableDictionary *gameData;
@property (strong,nonatomic) buyCoinsViewController *myBuyController;
@property (strong,nonatomic) UIView *buyCoinsView;

@property (strong,nonatomic) UITableView *itemsToBuy;
@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
//@property (strong,nonatomic) NSMutableArray *musicToNextView;
@end
