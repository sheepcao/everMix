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
#import "MobClick.h"
//#import "DMInterstitialAdController.h"
#import "BaiduMobAdInterstitial.h"


#define VERSIONNUMBER   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface ViewController : UIViewController<prepareSongsDelegate,closeBuyViewDelegate,BaiduMobAdInterstitialDelegate>
{
//    DMInterstitialAdController *_dmInterstitial;
    BaiduMobAdInterstitial *_interstitialView;

}
@property (nonatomic,retain) BaiduMobAdInterstitial *interstitialView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (weak, nonatomic) IBOutlet UIButton *begainGame;
@property (weak, nonatomic) IBOutlet UIButton *continueGame;

//- (IBAction)starTapped:(UIButton *)sender;
- (IBAction)continueTapped:(UIButton *)sender;

- (IBAction)beginTapped:(UIButton *)sender;
- (IBAction)socialShare;
- (IBAction)commentOnStore;
- (IBAction)aboutUs:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *bugCoinsBtn;
@property (strong, nonatomic) IBOutlet UIButton *coinsShowing;

- (IBAction)buyCoinsTapped:(id)sender;

@property (strong,nonatomic) NSMutableDictionary *gameData;

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong,nonatomic) buyCoinsViewController *myBuyController;
@property (strong,nonatomic) UIView *buyCoinsView;

@property (strong,nonatomic) UITableView *itemsToBuy;
@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
//@property (strong,nonatomic) NSMutableArray *musicToNextView;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *difficultySegment;
//-(IBAction)segmentAction:(UISegmentedControl *)Seg;

@property (nonatomic,strong) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UIButton *difficulty1;
@property (strong, nonatomic) IBOutlet UIButton *difficulty2;
@property (strong, nonatomic) IBOutlet UIButton *difficulty3;
@property (strong, nonatomic) IBOutlet UIButton *difficulty4;
@property (strong, nonatomic) IBOutlet UIButton *difficulty5;


- (IBAction)difficultyChanged:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

-(void)closingBuy;

- (IBAction)infoTap;

//info view
@property (strong, nonatomic) IBOutlet UIView *infoView;
- (IBAction)closeInfoBtn;
- (IBAction)feedBack;

@end
