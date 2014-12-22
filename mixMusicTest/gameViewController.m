//
//  ViewController.m
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import "gameViewController.h"

@interface gameViewController ()

@end

bool isplayed;
BOOL animating;
@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //eric:for debug...
    self.diskButtonFrameArray = [[NSMutableArray alloc] init];
    self.musicsArray = [NSMutableArray arrayWithObjects:@"海阔天空",@"小苹果",@"一场游戏一场梦",@"我可以抱你吗",@"红日", nil];
    
    self.myAudioArray = [NSMutableArray new];
    self.singleMusicsViewArray = [NSMutableArray new];

    isplayed =false;

//    [self drawSingleSongView];

    [self diskHideToTop];
    [self diskPopUp];
    
    [self.view bringSubviewToFront:self.playConsoleView];
    
    
}


#pragma mark disk animation
- (IBAction)diskTap:(UIButton *)sender {
}

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         destRotateView.transform = CGAffineTransformRotate(destRotateView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                [self spinWithOptions:UIViewAnimationOptionCurveLinear :destRotateView];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut :destRotateView];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        for (UIButton * button in self.diskButtons) {
            if (button.tag == 0) {
                [self spinWithOptions: UIViewAnimationOptionCurveEaseIn:button];
            }

        }
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

-(void)diskHideToTop
{
    
    
    for (int i = 0;i<6;i++) {
        CGRect destFrame = [self.diskButtons[i] frame];
        
        CGRect startFrame = destFrame;
        startFrame.origin.y = 0 - self.playConsoleView.frame.size.height - destFrame.size.height;
        [self.diskButtons[i] setFrame:startFrame];
        
        [self.diskButtonFrameArray insertObject: [NSValue valueWithCGRect:destFrame] atIndex:i];
        
    }
    
    
}
-(void)diskPopUp
{
    for (int i = 0;i<6;i++) {
        
        [UIView animateWithDuration:1.2+i*0.17 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:0 animations:^{
            [self.diskButtons[i] setFrame:[[self.diskButtonFrameArray objectAtIndex:i] CGRectValue]];
        } completion:nil];

    }
    
    
}



-(void)drawSingleSongView
{
    int diff = 5;
    
    for (int i = 0 ; i<diff; i++) {
        
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = (self.downPartView.frame.size.height-50)/5;
        
        UIView *singleMusicView = [[[NSBundle mainBundle] loadNibNamed:@"singleMusicView" owner:self options:nil] objectAtIndex:0];
        [singleMusicView setFrame:CGRectMake(0,i*viewHeight , viewWidth,viewHeight )];
        
        NSInteger wordsCount = [self.musicsArray[i] length];
        
        if(wordsCount < 7)
        {
            float firstWord_X = ((282+66)- wordsCount*(35+2))/2;
            for (int j = 0; j<wordsCount; j++) {
                UIImageView *answerWordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(firstWord_X + j*37, (viewHeight-35)/2, 35, 35)];
                [answerWordBackground setImage:[UIImage imageNamed:@"Square"]];
                [singleMusicView addSubview:answerWordBackground];
                
            }
        }else //eric: do not longer than 8 words...
        {
            float firstWord_X = 67;
            float wordLength = (282 - 66)/wordsCount;
            for (int j = 0; j<wordsCount; j++) {
                UIImageView *answerWordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(firstWord_X + j * wordLength, (viewHeight-wordLength)/2, (wordLength-1), (wordLength-1))];
                [answerWordBackground setImage:[UIImage imageNamed:@"Square"]];
                [singleMusicView addSubview:answerWordBackground];
                
            }
            
        }
        
        [self.downPartView addSubview:singleMusicView];
        [self.singleMusicsViewArray insertObject:singleMusicView atIndex:i];
    }
}

-(void)tapButton
{
    CGRect aframe = self.downPartView.frame;
    aframe.origin.y -= 100;
    [self.downPartView setFrame:aframe];
}


-(void)tapSound:(NSString *)name withType:(NSString *)type
{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    AVAudioPlayer *myAudioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    myAudioPlayer.volume = 1.0f;

    [self.myAudioArray addObject:myAudioPlayer];
    [myAudioPlayer play];
    
}
-(void)stopMusics
{
    for (AVAudioPlayer *audio in self.myAudioArray) {
        if ([audio isPlaying]) {
            [audio stop];
            
        }
    }
    [self stopSpin];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playBtn:(id)sender {
    

    
    [self.playBtn setTitle:self.levelTitle forState:UIControlStateNormal];
    if (isplayed) {
        [self stopMusics];
        isplayed =false;
    }else
    {
        [self initMusics];
        isplayed = true;
        [self performSelector:@selector(stop10secondMusics) withObject:nil afterDelay:10.0f];
    }
}

-(void)initMusics
{
    [self.myAudioArray removeAllObjects];
    
    for (int i = 0; i< self.musicsArray.count; i++) {
        [self tapSound:self.musicsArray[i] withType:@"m4a"];
    }
    [self startSpin];

}
-(void)stop10secondMusics
{
    if (isplayed) {
        [self stopMusics];
        isplayed =false;
    }
}
@end
