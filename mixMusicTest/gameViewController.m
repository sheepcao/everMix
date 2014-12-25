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
int totalRotateTimes;
@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(home:)];
//    self.navigationItem.leftBarButtonItem=newBackButton;
    //eric:for debug...
    self.diskButtonFrameArray = [[NSMutableArray alloc] init];
//    self.musicsArray = [NSMutableArray arrayWithObjects:@"海阔天空",@"小苹果",@"一场游戏一场梦",@"我可以抱你吗",@"红日", nil];
    
    self.myAudioArray = [NSMutableArray new];
    self.singleMusicsViewArray = [NSMutableArray new];

    isplayed =false;


    [self diskHideToTop];
    [self diskPopUp];
    
    [self.view bringSubviewToFront:self.playConsoleView];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop10secondMusics) object:nil];
    [self stopMusics];

}

- (IBAction)diskTap:(UIButton *)sender {
//    sender.tag = 1;
    int diskNumber = -1;
    
    for(int i = 0 ; i < self.diskButtons.count ; i++ )
    {
        if (sender == self.diskButtons[i]) {
            diskNumber = i;
        }
    }
    
    self.choicesBoardView = [[[NSBundle mainBundle] loadNibNamed:@"choicesBoardView" owner:self options:nil] objectAtIndex:0];
    [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.choicesBoardView];
    
    [UIView animateWithDuration:0.9 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.89 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,self.downPartView.frame.origin.y, self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    
//    NSLog(@"buttonText:%@",sender.titleLabel.text);
//    NSLog(@"buttonNum:%@",[self.diskButtons[diskNumber] titleLabel].text);

    
}

- (IBAction)returnChoicesBoard:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    
}


#pragma mark disk animation

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.15f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         destRotateView.transform = CGAffineTransformRotate(destRotateView.transform, M_PI/4 );
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (destRotateView == self.diskButtons[0]) {
                                 totalRotateTimes ++;
                             }

                             if (animating) {
                                 // if flag still set, keep spinning with constant speed

                                [self spinWithOptions:UIViewAnimationOptionCurveLinear :destRotateView];
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
    NSInteger musicCount = self.musicsArray.count;
    
    for (int i = 0;i<self.diskButtons.count;i++) {
        CGRect destFrame = [self.diskButtons[i] frame];
        
        CGRect startFrame = destFrame;
        startFrame.origin.y = 0 - self.playConsoleView.frame.size.height - destFrame.size.height;
        [self.diskButtons[i] setFrame:startFrame];
        
        [self.diskButtonFrameArray insertObject: [NSValue valueWithCGRect:destFrame] atIndex:i];
        
        if (i < musicCount) {
            [self.diskButtons[i] setHidden:NO];
        }else
        {
            [self.diskButtons[i] setHidden:YES];

        }
        
    }
    
    
}
-(void)diskPopUp
{
    for (int i = 0;i<self.diskButtons.count;i++) {
        
        [self.diskButtons[i] setEnabled:NO];

        
        [UIView animateWithDuration:0.65+i*0.12 delay:0.35 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:0 animations:^{
            [self.diskButtons[i] setFrame:[[self.diskButtonFrameArray objectAtIndex:i] CGRectValue]];
        } completion:nil];

    }
    
    
}



//-(void)drawSingleSongView
//{
//    int diff = 5;
//    
//    for (int i = 0 ; i<diff; i++) {
//        
//        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
//        CGFloat viewHeight = (self.downPartView.frame.size.height-50)/5;
//        
//        UIView *singleMusicView = [[[NSBundle mainBundle] loadNibNamed:@"singleMusicView" owner:self options:nil] objectAtIndex:0];
//        [singleMusicView setFrame:CGRectMake(0,i*viewHeight , viewWidth,viewHeight )];
//        
//        NSInteger wordsCount = [self.musicsArray[i] length];
//        
//        if(wordsCount < 7)
//        {
//            float firstWord_X = ((282+66)- wordsCount*(35+2))/2;
//            for (int j = 0; j<wordsCount; j++) {
//                UIImageView *answerWordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(firstWord_X + j*37, (viewHeight-35)/2, 35, 35)];
//                [answerWordBackground setImage:[UIImage imageNamed:@"Square"]];
//                [singleMusicView addSubview:answerWordBackground];
//                
//            }
//        }else //eric: do not longer than 8 words...
//        {
//            float firstWord_X = 67;
//            float wordLength = (282 - 66)/wordsCount;
//            for (int j = 0; j<wordsCount; j++) {
//                UIImageView *answerWordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(firstWord_X + j * wordLength, (viewHeight-wordLength)/2, (wordLength-1), (wordLength-1))];
//                [answerWordBackground setImage:[UIImage imageNamed:@"Square"]];
//                [singleMusicView addSubview:answerWordBackground];
//                
//            }
//            
//        }
//        
//        [self.downPartView addSubview:singleMusicView];
//        [self.singleMusicsViewArray insertObject:singleMusicView atIndex:i];
//    }
//}

-(void)tapButton
{
    CGRect aframe = self.downPartView.frame;
    aframe.origin.y -= 100;
    [self.downPartView setFrame:aframe];
}


-(void)tapSound:(NSString *)name withType:(NSString *)type
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.%@",name,type]];

    if (soundFilePath)
    {
        NSError *error;
        
        NSFileManager *fileManager =[NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:folderPath] == NO)
        {
            
            [[NSFileManager defaultManager] copyItemAtPath:soundFilePath
                                                    toPath:folderPath
                                                     error:&error];
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
        }
        
    }
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:folderPath ];
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
    
    [self performSelector:@selector(enableButtons) withObject:nil afterDelay:0.35];
}

-(void)enableButtons
{
    for (UIButton *button in self.diskButtons) {
        [UIView animateWithDuration: 0.03f
                              delay: 0.0f
                            options: 0
                         animations: ^{
                             button.transform = CGAffineTransformRotate(button.transform, -(totalRotateTimes%8) *( M_PI/4));
                         }
                         completion:nil];
        
        [button setEnabled:YES];
    }
    totalRotateTimes = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playBtn:(id)sender {
    

    
    [self.playBtn setTitle:self.levelTitle forState:UIControlStateNormal];
    if (isplayed) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop10secondMusics) object:nil];

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
