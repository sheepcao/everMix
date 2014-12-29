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

#define DISK_TAG 100
#define TIPS_TAG 200

@protocol prepareSongsDelegate <NSObject>
-(NSMutableArray *)configSongs;

@end


@interface gameViewController : UIViewController

@property (nonatomic,weak) id<prepareSongsDelegate> delegate;


@property (nonatomic,strong) NSString *levelTitle;
@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
@property (nonatomic, strong) NSMutableArray *myAudioArray;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property int diffculty;
@property (nonatomic, strong) NSMutableArray *singleMusicsViewArray;
@property (nonatomic, strong) NSMutableArray *musicsArray;
@property (nonatomic, strong) NSMutableArray *musicsPlayArray;

@property (nonatomic, strong) NSMutableArray *choicesBoardArray;
@property (nonatomic, strong) NSMutableDictionary *gameDataForSingleLevel;





//subviews
@property (weak, nonatomic) IBOutlet UIView *playConsoleView;
@property (weak, nonatomic) IBOutlet UIView *downPartView;
@property (strong, nonatomic) boardView *choicesBoardView;

@property (strong, nonatomic) NSMutableArray *diskButtonFrameArray;
//choiceBoard
- (IBAction)choicesTaped:(id)sender;


- (IBAction)playBtn:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *diskButtons;
- (IBAction)diskTap:(UIButton *)sender;

- (IBAction)returnChoicesBoard:(UIButton *)sender;

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView ;

@end

