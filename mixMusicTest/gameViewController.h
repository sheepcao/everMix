//
//  ViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define DISK_TAG 100
#define TIPS_TAG 200

@interface gameViewController : UIViewController

@property (nonatomic,strong) NSString *levelTitle;
@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
@property (nonatomic, strong) NSMutableArray *myAudioArray;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property int diffculty;
@property (nonatomic, strong) NSMutableArray *singleMusicsViewArray;
@property (nonatomic, strong) NSMutableArray *musicsArray;
@property (nonatomic, strong) NSMutableArray *choicesBoardArray;





//subviews
@property (weak, nonatomic) IBOutlet UIView *playConsoleView;
@property (weak, nonatomic) IBOutlet UIView *downPartView;
@property (strong, nonatomic) IBOutlet UIView *choicesBoardView;

@property (strong, nonatomic) NSMutableArray *diskButtonFrameArray;


- (IBAction)playBtn:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *diskButtons;
- (IBAction)diskTap:(UIButton *)sender;


- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView ;

@end

