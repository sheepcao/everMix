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

#define DISK_TAG 100
#define TIPS_TAG 200
#define CD_SZIE 80

@protocol prepareSongsDelegate <NSObject>
-(NSMutableArray *)configSongs;

@end


@interface gameViewController : UIViewController

@property (nonatomic,weak) id<prepareSongsDelegate> delegate;


@property (nonatomic,strong) NSString *levelTitle;
@property (nonatomic,strong) NSString *currentDifficulty;

@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
@property (nonatomic, strong) NSMutableArray *myAudioArray;

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

@property (strong, nonatomic) NSMutableArray *diskButtonFrameArray;
//choiceBoard
- (IBAction)choicesTaped:(id)sender;

- (IBAction)shareButton:(UIButton *)sender;
- (IBAction)refreshMusics:(UIButton *)sender;


- (IBAction)playBtn:(id)sender;

@property (strong, nonatomic) NSArray *diskButtons;
- (IBAction)diskTap:(UIButton *)sender;

- (IBAction)returnChoicesBoard:(UIButton *)sender;

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView ;

@end

