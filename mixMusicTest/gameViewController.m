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
@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.myAudioArray = [NSMutableArray new];
    self.singleMusicsViewArray = [NSMutableArray new];

    isplayed =false;
    int diff = 6;
    
    for (int i = 0 ; i<diff; i++) {
        
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = self.downPartView.frame.size.height/6;

        UIView *singleMusicView = [[[NSBundle mainBundle] loadNibNamed:@"singleMusicView" owner:self options:nil] objectAtIndex:0];
        [singleMusicView setFrame:CGRectMake(0,i*viewHeight , viewWidth,viewHeight )];
        [self.downPartView addSubview:singleMusicView];
        [self.singleMusicsViewArray insertObject:singleMusicView atIndex:i];
    }

    

    
    [self.view bringSubviewToFront:self.playConsoleView];
    
    
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
        [self tapSound:@"backMusic" withType:@"mp3"];
        [self tapSound:@"1" withType:@"mp3"];
        [self tapSound:@"2" withType:@"mp3"];
        [self tapSound:@"4" withType:@"mp3"];
        [self tapSound:@"5" withType:@"mp3"];
        isplayed = true;
        [self performSelector:@selector(stop15secondMusics) withObject:nil afterDelay:15.0f];
    }
}
-(void)stop15secondMusics
{
    if (isplayed) {
        [self stopMusics];
        isplayed =false;
    }
}
@end
