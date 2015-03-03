//
//  ViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AnswerButton.h"
#import "boardView.h"
#import "CommonUtility.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "MobClick.h"
#import "buyCoinsViewController.h"
#import "BaiduMobAdDelegateProtocol.h"

//AD...
//#import "DMAdView.h"

#define DISK_TAG 100
#define TIPS_TAG 200
#define CD_SZIE 80
#define CD_SZIE_IPAD 140
#define DELETE_PRICE 80
#define SINGLE_SONG_PRICE 200
#define SHOW_ANSWER_PRICE 350
#define BOMB_SONG_PRICE 300
#define LEVEL_PASS_COIN 10


//@class buyCoinsViewController;

@protocol prepareSongsDelegate <NSObject,UMSocialUIDelegate>
-(NSMutableArray *)configSongs;
-(void)resetPlist;

@end




@interface gameViewController : UIViewController<closeBuyViewDelegate,BaiduMobAdViewDelegate>
{
//    DMAdView *_dmAdView;
  
    BaiduMobAdView* sharedAdView;

}

@property (nonatomic,weak) id<prepareSongsDelegate> delegate;


@property (nonatomic,strong) NSString *levelTitle;
@property (nonatomic,strong) NSString *currentDifficulty;

@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
@property (nonatomic, strong) NSMutableArray *myAudioArray;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property int diffculty;
@property (nonatomic, strong) NSMutableArray *singleMusicsViewArray;
@property (nonatomic, strong) NSMutableArray *musicsArray;
@property (nonatomic, strong) NSMutableArray *musicsPlayArray;

@property (nonatomic, strong) NSMutableArray *choicesBoardArray;
@property (nonatomic, strong) NSMutableDictionary *gameDataForSingleLevel;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteOneBtn;


//subviews
@property (weak, nonatomic) IBOutlet UIView *playConsoleView;
@property (weak, nonatomic) IBOutlet UIView *downPartView;
@property (strong, nonatomic) boardView *choicesBoardView;

@property (strong, nonatomic) IBOutlet UIView *levelPassView;
@property (weak, nonatomic) IBOutlet UIView *levelPassMessage;
@property (weak, nonatomic) IBOutlet UIView *difficultyPass;

- (IBAction)levelPassTap;
- (IBAction)difficultyPassTap:(id)sender;


@property (strong, nonatomic) NSMutableArray *diskButtonFrameArray;
//choiceBoard
- (IBAction)choicesTaped:(id)sender;
- (IBAction)deleteSomeWords;
- (IBAction)playSingleSong;
- (IBAction)showFullAnswer;



- (IBAction)shareButton:(UIButton *)sender;
- (IBAction)refreshMusics:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *playSingleButton;
@property (strong, nonatomic) IBOutlet UIButton *showAnswerButton;

@property (strong, nonatomic) UIButton *coinShow;

@property (strong,nonatomic) UIView *buyCoinsView;
@property (strong,nonatomic) buyCoinsViewController *myBuyController;
@property (strong,nonatomic) UITableView *itemsToBuy;
@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);

- (IBAction)playBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

@property (strong, nonatomic) NSArray *diskButtons;
- (IBAction)diskTap:(UIButton *)sender;

- (IBAction)returnChoicesBoard:(UIButton *)sender;

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView ;
-(void)closingBuy;
@end

