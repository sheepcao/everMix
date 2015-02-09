//
//  ViewController.m
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import "ViewController.h"
#import "myAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "globalVar.h"
#import "fallAnimation.h"
#import <MessageUI/MessageUI.h>

//#import <CoreVideo/CVOpenGLESTextureCache.h>
//#import "RippleModel.h"
//#include <stdlib.h>

#define DMPUBLISHERID        @"56OJxqiIuN5cJKR8fX"
#define DMPLCAEMENTID_INTER @"16TLej7oApZ2kNUOza5fBhvz"

@interface ViewController ()<MFMailComposeViewControllerDelegate>
{
    bool first;
    
}
@property (nonatomic,strong)CustomIOS7AlertView *dailyRewardAlert;
@property (nonatomic,strong)NSArray *difficultyButtons;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIImageView *musicNote1;
@property (nonatomic, strong) UIImageView *musicNote2;
@property (nonatomic, strong) UIImageView *musicNote3;
@property (nonatomic, strong) UIImageView *musicNote4;
@property (nonatomic, strong) UIImageView *musicNote5;
@property (nonatomic, strong) UIImageView *musicNote6;
@property (nonatomic, strong) UIImageView *musicNote7;
@property (nonatomic, strong) UIImageView *musicNote8;
@property (nonatomic, strong) NSArray *musicNotes;
@property CGFloat topCon;
@property CGFloat frameBottom;

@end
int difficultyNow;

@implementation ViewController
@synthesize timer;


- (void)viewDidLoad {
    [super viewDidLoad];
 
    

    //eric:check font
//    NSArray *fontFamilies = [UIFont familyNames];
//    
//    for (int i=0; i<[fontFamilies count]; i++)
//    {
//        NSLog(@"Font: %@ ...", [fontFamilies objectAtIndex:i]);
//    }

    self.musicNote1 = [[UIImageView alloc] init];
    self.musicNote2 = [[UIImageView alloc] init];
    self.musicNote3 = [[UIImageView alloc] init];
    self.musicNote4 = [[UIImageView alloc] init];
    self.musicNote5 = [[UIImageView alloc] init];
    self.musicNote6 = [[UIImageView alloc] init];
    self.musicNote7 = [[UIImageView alloc] init];
    self.musicNote8 = [[UIImageView alloc] init];


    
    self.musicNotes = [NSArray arrayWithObjects:self.musicNote1,self.musicNote2,self.musicNote3,self.musicNote4,self.musicNote5,self.musicNote6,self.musicNote7,self.musicNote8, nil];
    
    [self dailyReward];


    // Do any additional setup after loading the view.
    [self copyPlistToDocument:@"gameData"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coinsAmount"] ==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",500] forKey:@"coinsAmount"];
    }

    [self.view sendSubviewToBack:self.backgroundImg];
    [self setupDifficultyBtns];

    self.difficultyButtons = [NSArray arrayWithObjects:self.difficulty1,self.difficulty2,self.difficulty3,self.difficulty4,self.difficulty5, nil];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(bigADshow) userInfo:nil repeats:NO];

    //big AD...
    
    self.interstitialView = [[BaiduMobAdInterstitial alloc] init];
    self.interstitialView.delegate = self;
    self.interstitialView.interstitialType = BaiduMobAdViewTypeInterstitialGame;
    [self.interstitialView load];
    // 初始化插屏⼲⼴广告,此处使⽤用的是测试ID,请登陆多盟官⺴⽹网(www.domob.cn)获取新的ID _dmInterstitial = [[DMInterstitialAdController alloc]
//    _dmInterstitial = [[DMInterstitialAdController alloc] initWithPublisherId:DMPUBLISHERID
//                                                                  placementId:DMPLCAEMENTID_INTER
//                                                           rootViewController:self];
//    _dmInterstitial.delegate = self;
//    // load advertisement
//    [_dmInterstitial loadAd];
    
    backFromGame = NO;
    first = YES;
    [self dropDown];
    

    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"homePage"];
    
    [self.navigationController setNavigationBarHidden:YES];

    
    NSString *currentCoins = [NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]];
    
    [self.coinsShowing setTitle:currentCoins forState:UIControlStateNormal];

//    self.difficultySegment.layer.borderWidth = 0;
//    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                           forKey:NSFontAttributeName];
//    [self.difficultySegment setTitleTextAttributes:attributes
//                                    forState:UIControlStateNormal];
////    [self.difficultySegment setBackgroundImage:[UIImage imageNamed:@"answerBack1"]
////                                forState:UIControlStateNormal
////                              barMetrics:UIBarMetricsDefault];
//    CGRect frame= self.difficultySegment.frame;
//    [self.difficultySegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35)];
    

    [self.versionLabel setText:[NSString stringWithFormat:@"Version: %@",VERSIONNUMBER]];
  
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (backFromGame) {
        if (timer != nil)
        {
            [timer invalidate];
            
            timer = nil;
            
        }
        [self bigADshow];
      
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"homePage"];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}
-(void)setupDifficultyBtns
{
    
    self.difficulty1 = [[UIButton alloc] init];
    [self.difficulty1 setTitle:@"简单" forState:UIControlStateNormal];
    self.difficulty1.tag = 1;
    
    self.difficulty2 = [[UIButton alloc] init];
    [self.difficulty2 setTitle:@"较易" forState:UIControlStateNormal];
    self.difficulty2.tag = 2;

    
    self.difficulty3 = [[UIButton alloc] init];
    [self.difficulty3 setTitle:@"困难" forState:UIControlStateNormal];
    self.difficulty3.tag = 3;

    
    self.difficulty4 = [[UIButton alloc] init];
    [self.difficulty4 setTitle:@"疯狂" forState:UIControlStateNormal];
    self.difficulty4.tag = 4;

    
    self.difficulty5 = [[UIButton alloc] init];
    [self.difficulty5 setTitle:@"变态" forState:UIControlStateNormal];
    self.difficulty5.tag = 5;

    
    
    [self setupPointFor:self.difficulty1];
    [self setupPointFor:self.difficulty2];
    [self setupPointFor:self.difficulty3];
    [self setupPointFor:self.difficulty4];
    [self setupPointFor:self.difficulty5];
    
    CGRect kframe = CGRectMake(25, 327, 63, 30);
    [self.difficulty1 setFrame:kframe];
    
    CGRect mframe = CGRectMake(98, 300, 63, 30);
    [self.difficulty2 setFrame:mframe];
    
    CGRect nframe = CGRectMake(141, 365, 63, 30);
    [self.difficulty3 setFrame:nframe];
    
    CGRect oframe = CGRectMake(191, 273, 63, 30);
    [self.difficulty4 setFrame:oframe];
    
    CGRect pframe = CGRectMake(257, 308, 63, 30);
    [self.difficulty5 setFrame:pframe];
    
    if(IS_IPHONE_5)
    {
      
        
    }else if (IS_IPHONE_6)
    {
        CGRect kframe = self.difficulty1.frame;
        kframe.origin.x += 20;
        kframe.origin.y += 56;
        
        [self.difficulty1 setFrame:kframe];
        
        CGRect aframe = self.difficulty2.frame;
        aframe.origin.x += 18;
        aframe.origin.y += 56;
        
        [self.difficulty2 setFrame:aframe];
        
        CGRect bframe = self.difficulty3.frame;
        bframe.origin.x += 25;
        bframe.origin.y += 65;
    
        [self.difficulty3 setFrame:bframe];
        
        CGRect cframe = self.difficulty4.frame;
        cframe.origin.x += 32;
        cframe.origin.y += 55;
        [self.difficulty4 setFrame:cframe];
        
        CGRect dframe = self.difficulty5.frame;
        dframe.origin.x += 55;
        dframe.origin.y += 62;
        
        [self.difficulty5 setFrame:dframe];
        
    }else if (IS_IPHONE_6P)
    {
        CGRect kframe = self.difficulty1.frame;
        kframe.origin.x += 28;
        kframe.origin.y += 100;
        
        [self.difficulty1 setFrame:kframe];
        
        CGRect aframe = self.difficulty2.frame;
        aframe.origin.x += 31;
        aframe.origin.y += 98;
        
        [self.difficulty2 setFrame:aframe];
        
        CGRect bframe = self.difficulty3.frame;
        bframe.origin.x += 45;
        bframe.origin.y += 115;
        
        [self.difficulty3 setFrame:bframe];
        
        CGRect cframe = self.difficulty4.frame;
        cframe.origin.x += 55;
        cframe.origin.y += 94;
        [self.difficulty4 setFrame:cframe];
        
        CGRect dframe = self.difficulty5.frame;
        dframe.origin.x += 85;
        dframe.origin.y += 105;
        
        [self.difficulty5 setFrame:dframe];
    }else if(IS_IPHONE_4_OR_LESS)
    {
        CGRect kframe = self.difficulty1.frame;
        kframe.origin.y -=66;
        [self.difficulty1 setFrame:kframe];
        
        CGRect aframe = self.difficulty2.frame;
        aframe.origin.y -= 53;
        
        [self.difficulty2 setFrame:aframe];
        
        CGRect bframe = self.difficulty3.frame;
        bframe.origin.y -= 63;
        [self.difficulty3 setFrame:bframe];
        
        CGRect cframe = self.difficulty4.frame;
        cframe.origin.y -= 47;
        [self.difficulty4 setFrame:cframe];
        
        CGRect dframe = self.difficulty5.frame;
        dframe.origin.y -= 50;
        
        [self.difficulty5 setFrame:dframe];
        
    }
    [self.view addSubview:self.difficulty1];
    [self.view addSubview:self.difficulty2];
    [self.view addSubview:self.difficulty3];
    [self.view addSubview:self.difficulty4];
    [self.view addSubview:self.difficulty5];
    
    
    
    NSLog(@"1:%@\n2:%@\n3:%@\n4:%@\n5:%@\n",self.difficulty1,self.difficulty2,self.difficulty3,self.difficulty4,self.difficulty5);
    

}
-(void)setupPointFor:(UIButton *)button
{
    [button setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"pointYellow"] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(difficultyChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 9, 52)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    
    self.gameData = [self readDataFromPlist:@"gameData"] ;
    NSString *currentDifficulty = [self.gameData objectForKey:@"difficulty"];
    
//    [self drawStars:[currentDifficulty intValue]];
//    self.difficultySegment.selectedSegmentIndex = [currentDifficulty intValue];
    
    [self changeDifficultyTo:currentDifficulty];
    NSMutableArray *currentMusics = [self.gameData objectForKey:@"musicPlaying"];
    
    if (currentMusics && currentMusics.count > 0) {
        
        [self.begainGame setImage:[UIImage imageNamed:@"重新开始"] forState:UIControlStateNormal];
        [self.begainGame setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - self.continueGame.frame.origin.x - self.continueGame.frame.size.width, self.continueGame.frame.origin.y, self.continueGame.frame.size.width, self.continueGame.frame.size.height)];
        [self.continueGame setHidden:NO];
    }else
    {
        
        [self.begainGame setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
        [self.begainGame setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - self.continueGame.frame.size.width/2 , self.continueGame.frame.origin.y, self.continueGame.frame.size.width, self.continueGame.frame.size.height)];
        [self.continueGame setHidden:YES];
        
        
    }
//    
//    if (self.ripple) {
//        [self.ripple removeFromSuperview];
//    }
//    if (self.ripple2) {
//        [self.ripple2 removeFromSuperview];
//    }
//    if (self.ripple3) {
//        [self.ripple3 removeFromSuperview];
//    }
//    
//    self.ripple = [[UILabel alloc] initWithFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//    [self.ripple setBackgroundColor:[UIColor clearColor]];
//    [self.ripple.layer setCornerRadius:self.ripple.bounds.size.height /2]; //Assuming square images
//    
//    [self.ripple.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.ripple.layer setBorderWidth:1];
//    [self.view addSubview:self.ripple];
//    self.ripple.alpha = 0.4;
//    
//    [self buttonAnimate:self.ripple andRange:1.5 andBorderWidth:1];
//    //
//    self.ripple2 = [[UILabel alloc] initWithFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//    [self.ripple2 setBackgroundColor:[UIColor clearColor]];
//    [self.ripple2.layer setCornerRadius:self.ripple2.bounds.size.height /2]; //Assuming square images
//    
//    [self.ripple2.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.ripple2.layer setBorderWidth:2.5];
//    [self.view addSubview:self.ripple2];
//    self.ripple2.alpha = 0.4;
//    [self buttonAnimate:self.ripple2 andRange:1.35 andBorderWidth:2.5];
//    
//    
//    self.ripple3 = [[UILabel alloc] initWithFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//    [self.ripple3 setBackgroundColor:[UIColor clearColor]];
//    [self.ripple3.layer setCornerRadius:self.ripple3.bounds.size.height /2]; //Assuming square images
//    
//    [self.ripple3.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.ripple3.layer setBorderWidth:4];
//    [self.view addSubview:self.ripple3];
//    self.ripple3.alpha = 0.4;
//    [self buttonAnimate:self.ripple3 andRange:1.2 andBorderWidth:4];
//    

 
}

-(void)changeDifficultyTo:(NSString *)diff
{
    difficultyNow = [diff intValue];
    
//    UIButton *button = (UIButton *)[self.view viewWithTag:difficultyNow +1];
    for (UIButton *btn in self.difficultyButtons) {
        if (btn.tag == difficultyNow +1) {
            [btn setEnabled:NO];
        }else
        {
            [btn setEnabled:YES];

        }
    }
    
}

-(void)buttonAnimate:(UIView *)view andRange:(CGFloat)scale andBorderWidth:(CGFloat)borderWith
{
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [view.layer setBorderWidth:borderWith];

    view.alpha = 0.4;

    
    [UIView animateWithDuration:1.5 animations:^{
        view.transform = CGAffineTransformMakeScale(scale, scale);
//        view.layer.borderWidth = 20;

        view.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self buttonAnimate:view andRange:scale andBorderWidth:borderWith];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    gameViewController *myGameViewController = [segue destinationViewController];
//    myGameViewController.levelTitle = @"PLAY1234";
//    NSMutableArray *passMusics = [self configSongs];
//    
//    myGameViewController.musicsArray = passMusics;
//    myGameViewController.delegate = self;
//    
//}

#pragma mark ConfigSongs delegate
-(NSMutableArray *)configSongs
{
    NSMutableArray *musicToNextView = [[NSMutableArray alloc] init];
    self.gameData = [self readDataFromPlist:@"gameData"] ;

    NSString *currentDifficulty = [self.gameData objectForKey:@"difficulty"];
    NSArray *unfinishedSongs = [NSArray arrayWithArray:[self.gameData objectForKey:@"musicUnfinished"]];
    
    NSMutableArray * allArrayNumber = [[NSMutableArray alloc] init];
    for (int i = 0; i < unfinishedSongs.count; i++) {
        if ([(NSArray *)unfinishedSongs[i] count]>0)
        {
            [allArrayNumber addObject:[NSNumber numberWithInt:i]];
        }
    }
    for (int i = 0; i < [currentDifficulty intValue]+1; i++) {
        unsigned int randomNumber = arc4random()%allArrayNumber.count;
        int subArrayPicked = [allArrayNumber[randomNumber] intValue];
        
        unsigned int randomElement = arc4random()%[unfinishedSongs[subArrayPicked] count];
        NSString *songPicked = [unfinishedSongs[subArrayPicked] objectAtIndex: randomElement] ;
        
        
        [musicToNextView addObject:songPicked];
        [unfinishedSongs[subArrayPicked] removeObjectAtIndex:randomElement];
        [self deleteSongsFromPlist:@"gameData" withArrayNum:subArrayPicked andElementNum:randomElement];
        
        [allArrayNumber removeObjectAtIndex:randomNumber];
    }
    
    


    return musicToNextView;
}



//-(void)drawStars:(int)Differentlevel
//{
//
//    
//    for (int i = 0; i<5; i++) {
//        if (i <= Differentlevel) {
//            [(UIButton *)self.starButtons[i] setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
//        }
//        if (i>Differentlevel) {
//            [(UIButton *)self.starButtons[i] setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
//        }
//    }
//    
//    [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",Differentlevel] forKey:@"difficulty"];
//
//
//    
//}
//

//- (IBAction)starTapped:(UIButton *)sender {
//    
//    [MobClick event:@"chooseDifficulty"];
//
//    
//    if ([self.continueGame isHidden]) {
//        int starNumber = -1; //init with a invalid value.
//        
//        for (int i = 0; i<5; i++) {
//            if(sender == self.starButtons[i])
//            {
//                starNumber = i;
//            }
//            
//        }
//        
//        [self drawStars:starNumber];
//        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",starNumber*20] forKey:@"currentLevel"];
//        
//    }else
//    {
//        myAlertView *resetAlert = [[myAlertView alloc] initWithTitle:@"且慢!" message:@"变更难度将重置已猜歌曲的进度,请君三思。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        
//        resetAlert.chooseWhichButton = sender;
//        resetAlert.tag = 1;
//        
//        [resetAlert show];
//    }
//    
//    
//    
////    int starNumber = -1; //init with a invalid value.
////    
////    for (int i = 0; i<5; i++) {
////        if(sender == self.starButtons[i])
////        {
////            starNumber = i;
////        }
////
////    }
////    
////    [self drawStars:starNumber];
//
//}

-(void)resetPlist
{
    [self removePlistFromDocument:@"gameData"];
//    NSMutableArray *currentMusics = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"] mutableCopy];
//    [currentMusics removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] setObject:currentMusics forKey:@"currentMusics"];
    
    [self.begainGame setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
    [self.begainGame setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - self.continueGame.frame.size.width/2 , self.continueGame.frame.origin.y, self.continueGame.frame.size.width, self.continueGame.frame.size.height)];
//    
//    [self.ripple setFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//
//    //
//    [self.ripple2 setFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//    
//    [self.ripple3 setFrame: CGRectMake(self.begainGame.frame.origin.x+10, self.begainGame.frame.origin.y+10, self.begainGame.frame.size.width-20,self.begainGame.frame.size.height-20) ];
//
//
//    
//    
    
    [self.continueGame setHidden:YES];
    
    
    
    [self copyPlistToDocument:@"gameData"];

}

- (void)alertView:(myAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        if (alertView.tag == 1) {
            //reset plist
            [self resetPlist];
            
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",difficultyNow] forKey:@"difficulty"];
            
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",difficultyNow*20] forKey:@"currentLevel"];

        }
        if (alertView.tag == 2) {
            [self resetPlist];
//            [self drawStars:2];
            [self changeDifficultyTo:@"1"];
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",20] forKey:@"currentLevel"];

            
        }

        
    }
    if (buttonIndex == 0) {
        if (alertView.tag == 1) {
            [self changeDifficultyTo:[NSString stringWithFormat:@"%d",alertView.lastSegmentIndex]];
        }
    }
  
}


- (IBAction)continueTapped:(UIButton *)sender {
    
    [CommonUtility tapSound:@"newGame" withType:@"mp3"];

    self.gameData = [self readDataFromPlist:@"gameData"] ;

    NSString *currentLevel = [self.gameData objectForKey:@"currentLevel"];
    NSString *currentDifficulty = [self.gameData objectForKey:@"difficulty"];
    int levelNow = [currentLevel intValue] - [currentDifficulty intValue] * 20 ;

    
    gameViewController *myGameViewController = [[gameViewController alloc] initWithNibName:@"gameViewController" bundle:nil];
    myGameViewController.levelTitle = [NSString stringWithFormat:@"%d",levelNow];
    
//    NSMutableArray *currentMusics = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"];
    NSMutableArray *currentMusics = [self.gameData objectForKey:@"musicPlaying"];

    
    if (currentMusics && currentMusics.count > 0) {
        
        myGameViewController.musicsArray = currentMusics;
        
    }else
    {
        NSMutableArray *passMusics = [self configSongs];
        myGameViewController.musicsArray = passMusics;
        [self modifyPlist:@"gameData" withValue:passMusics forKey:@"musicPlaying"];

        
    }
    myGameViewController.delegate = self;
    myGameViewController.navigationItem.title = [NSString stringWithFormat:@"%d",levelNow];
    myGameViewController.currentDifficulty = [self.gameData objectForKey:@"difficulty"];
    [self.navigationController pushViewController:myGameViewController animated:YES];

}


- (IBAction)beginTapped:(UIButton *)sender {
    
    [CommonUtility tapSound:@"newGame" withType:@"mp3"];

//    NSMutableArray *currentMusics = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"];
    self.gameData = [self readDataFromPlist:@"gameData"] ;

    NSMutableArray *currentMusics = [self.gameData objectForKey:@"musicPlaying"];

    if (currentMusics && currentMusics.count > 0) // renew game
    {
       
        [MobClick event:@"restart"];

        
        myAlertView *resetAlert = [[myAlertView alloc] initWithTitle:@"且慢!" message:@"变更难度将重置已猜歌曲的进度,请君三思。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        resetAlert.chooseWhichButton = sender;
        resetAlert.tag = 2;
        [resetAlert show];

        
    }else// fresh new..
    {
        NSString *currentLevel = @"";
        NSString *currentDifficulty = @"";
        self.gameData = [self readDataFromPlist:@"gameData"] ;

        currentLevel = [self.gameData objectForKey:@"currentLevel"];
        currentDifficulty = [self.gameData objectForKey:@"difficulty"];
        int levelNow = [currentLevel intValue] - [currentDifficulty intValue] * 20 + 1;
        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",levelNow + [currentDifficulty intValue] * 20] forKey:@"currentLevel"];
        
        gameViewController *myGameViewController = [[gameViewController alloc] initWithNibName:@"gameViewController" bundle:nil];
        myGameViewController.levelTitle = @"PLAY1234";
        
        NSMutableArray *passMusics = [self configSongs];
        myGameViewController.musicsArray = passMusics;
        [self modifyPlist:@"gameData" withValue:passMusics forKey:@"musicPlaying"];

        myGameViewController.delegate = self;
        myGameViewController.navigationItem.title = [NSString stringWithFormat:@"%d",levelNow];
        myGameViewController.currentDifficulty = [self.gameData objectForKey:@"difficulty"];
        [self.navigationController pushViewController:myGameViewController animated:YES];

    }

}

- (IBAction)socialShare {
    
    [CommonUtility tapSound:@"click" withType:@"mp3"];
    [MobClick event:@"shareFromHome"];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54c46ea7fd98c5071d000668"
                                      shareText:@"我在玩魔音大师，还挺挑战的，朋友们也来试试!"
                                     shareImage:[UIImage imageNamed:@"iconNew.png"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                       delegate:(id)self];
    
    // music url
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:@"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8"];

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://itunes.apple.com/cn/app/mo-yin-da-shi-feng-kuang-cai-ge/id954971485?ls=1&mt=8";



    

}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (IBAction)commentOnStore {
    [CommonUtility tapSound:@"click" withType:@"mp3"];

    [MobClick event:@"comment"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];


}

- (IBAction)aboutUs:(id)sender {
    [MobClick event:@"aboutUs"];

}

-(void)removePlistFromDocument:(NSString *)plistname
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSError *error;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:folderPath] == YES)
    {
        
        
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }
    
}

-(void)copyPlistToDocument:(NSString *)plistname
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSLog(@"Source Path: %@\n Documents Path: %@ \n Folder Path: %@", sourcePath, documentsDirectory, folderPath);
    
    NSError *error;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];

    if([fileManager fileExistsAtPath:folderPath] == NO)
    {
       
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                toPath:folderPath
                                                 error:&error];
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }

}

-(NSMutableDictionary *)readDataFromPlist:(NSString *)plistname
{
    //read level data from plist
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSMutableDictionary *levelData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSLog(@"levelData%@",levelData);
    return levelData;
    
}

-(void)modifyPlist:(NSString *)plistname withValue:(id)value forKey:(NSString *)key
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath] == YES)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [infoDict setObject:value forKey:key];
            [infoDict writeToFile:plistPath atomically:NO];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
        }
    }
}

-(void)deleteSongsFromPlist:(NSString *)plistname withArrayNum:(int)arrayNum andElementNum:(int)elementNum
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath] == YES)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            NSArray *allUnfinishedSongs = [infoDict objectForKey:@"musicUnfinished"];
            [allUnfinishedSongs[arrayNum] removeObjectAtIndex:elementNum];
            [infoDict setObject:allUnfinishedSongs forKey:@"musicUnfinished"];
            [infoDict writeToFile:plistPath atomically:NO];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
        }
    }
}


- (IBAction)buyCoinsTapped:(id)sender {
    [CommonUtility tapSound:@"click" withType:@"mp3"];

    [MobClick event:@"bugCoinClick"];

    if (!self.buyCoinsView) {
        
        self.buyCoinsView = [[[NSBundle mainBundle] loadNibNamed:@"buyCoinsViewController" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:self.buyCoinsView];

    }

    
    UILabel *coinsLabel = (UILabel *)[self.buyCoinsView viewWithTag:2];
    [coinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
    self.myBuyController = [[buyCoinsViewController alloc] initWithCoinLabel:coinsLabel andParentController:self adnParentCoinButton:self.coinsShowing];
 
    [self.buyCoinsView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.myBuyController.closeDelegate =self;
    
    UIButton *closeBuyView = (UIButton *)[self.buyCoinsView viewWithTag:1];
    [closeBuyView addTarget:self action:@selector(closingBuy) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    self.itemsToBuy = (UITableView *)[self.buyCoinsView viewWithTag:10];

    
    self.itemsToBuy.delegate = self.myBuyController;
    self.itemsToBuy.dataSource = self.myBuyController;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.itemsToBuy addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self.myBuyController action:@selector(reloadwithRefreshControl:andTableView:) forControlEvents:UIControlEventValueChanged];
    [self.myBuyController reloadwithRefreshControl:self.refreshControl andTableView:self.itemsToBuy];
    [self.refreshControl beginRefreshing];
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyCoinsView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:nil];

    
    [self.itemsToBuy reloadData];
    
    
    
}

-(void)closingBuy
{
    [CommonUtility tapSound:@"Window_Disappear" withType:@"mp3"];
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyCoinsView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (IBAction)infoTap {
    [CommonUtility tapSound:@"click" withType:@"mp3"];

    
    if (!self.infoView) {
        
        self.infoView = [[[NSBundle mainBundle] loadNibNamed:@"infoView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:self.infoView];

    }
    [self.infoView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:0.99 options:0 animations:^{
        [self.infoView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:^(BOOL finished)
     {
         if (finished) {
         
         }
     }];
    
    if (IS_IPHONE_4_OR_LESS) {
     
        
        [self performSelector:@selector(sizeForIPhone4) withObject:nil afterDelay:0.2];
    }
  
    
    
}

-(void)sizeForIPhone4
{
    
    UIView *rectview = [self.infoView viewWithTag:333];
    CGRect aframe = rectview.frame;
    aframe.size.height += 78;
    [rectview setFrame:aframe];
    
    UIView *wordView = [self.infoView viewWithTag:555];
    CGRect bframe = wordView.frame;
    bframe.origin.y += 80;
    [wordView setFrame:bframe];
}
- (IBAction)closeInfoBtn {
    
    [CommonUtility tapSound:@"Window_Disappear" withType:@"mp3"];

    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:0.4 options:0 animations:^{
        [self.infoView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];
}

- (IBAction)feedBack {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker.view setFrame:CGRectMake(0,20 , 320, self.view.frame.size.height-20)];
    picker.mailComposeDelegate = self;
    
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"sheepcao1986@163.com"];
    
    
    [picker setToRecipients:toRecipients];
    //
    //    // Attach an image to the email
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
    //    NSData *myData = [NSData dataWithContentsOfFile:path];
    //    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
    
    // Fill out the email body text
    NSString *emailBody= @"";
    if ([CommonUtility isSystemLangChinese]) {
        [picker setSubject:@"意见反馈-魔音大师"];
//        emailBody = @"亲爱的BabyMatch用户，\n只要拍下宝宝的绘画作品投稿，您宝宝的大作就有机会成为新的游戏关卡！只需三步哦！\n1、宝宝绘画——围绕着某一个特定主题宝宝进行绘画，可以画在纸上或者平板电脑上\n2、家长拍照——用像素较高的手机或相机拍下您宝宝的绘画作品，如果在平板上绘画直接截屏或保存图片\n3、签名发送——邮件标题或正文写清宝宝名字，宝宝年龄，以及绘画主题，我们会把这些信息清晰的附在图片之中。\n\n我们将会选出适合猜图、图片清晰的作品作为新游戏的素材！\n宝宝也可以是APP设计师！快快投稿吧！\n\n投稿标题示例：\n张小宝，5岁，小鸟在唱歌\n(注：手机用户直接双击邮件正文选择添加图片。)";
    }else
    {
        
        [picker setSubject:@"Feed back - mixMusic Guess"];
//        emailBody = @"Dear user,\nJust take a photo of your baby’s painting, and your sweetheart’s masterpiece will likely become the material of our new game level.Only three steps are needed. Simple and easy!\nStep 1: baby draw – your baby can draw whatever he/she like on certain theme, either on a piece of paper or iPad.\nStep 2: parents shoot – please take a photo of your baby’s painting if it’s been drawn on a piece of paper, or just screenshot and save the painting on the iPad.\nStep 3: Sign & Send – please write your baby’s name, age and painting theme in the title of subscription email so that we can make a footnote on your baby’s work.\n\nThen we’ll carefully select suitable and clear paintings, and use them in our new materials of game levels.\nEvery baby is a genius in designing!\n\nExample for subscription email title:\nDaniel Cooper, 5 years old, a singing bird \n(PS: mobile users can add a picture directly by double-click the email message body.)";
    }
    
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)alertWithTitle: (NSString *)_title_ msg: (NSString *)msg

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                          
                                                    message:msg
                          
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    NSString *title = @"Mail";
    
    NSString *msg;
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            msg = @"Mail canceled";//@"邮件发送取消";
            
            break;
            
        case MFMailComposeResultSaved:
            
            msg = @"Mail saved";//@"邮件保存成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultSent:
            
            msg = @"Mail sent";//@"邮件发送成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultFailed:
            
            msg = @"Mail failed";//@"邮件发送失败";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        default:
            
            msg = @"Mail not sent";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
    }
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark Daily reward
- (void)dailyReward
{
    
    //eric:set last day
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/DD"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    //set locale
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLang];
    [dateFormat setLocale:locale];
    
    NSString *today = [dateFormat stringFromDate:[NSDate date]];
    NSLog(@"day is :%@",today);
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastDailyReword"]) {
        
        [self giveReward:today];
        
    }else if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"lastDailyReword"] isEqualToString:today])
    {
        [self giveReward:today];
    }
        
    
}

-(void)giveReward:(NSString *)day
{
    [[NSUserDefaults standardUserDefaults] setObject:day forKey:@"lastDailyReword"];
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 1;
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 300, 211)];
    UIImageView *imageInTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 211)];
    
    [tmpCustomView addSubview:imageInTag];
    [tmpCustomView sendSubviewToBack:imageInTag];
    imageInTag.image = [UIImage imageNamed:@"background"];
    
    UIButton *getCoins = [[UIButton alloc] initWithFrame:CGRectMake(tmpCustomView.frame.size.width/2 -35, tmpCustomView.frame.size.height-50, 70, 40)];
    [getCoins setTitle:@"领取" forState:UIControlStateNormal];
    [getCoins addTarget:self action:@selector(getCoinsTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [tmpCustomView addSubview:getCoins];
    
    [alert setContainerView:tmpCustomView];
    self.dailyRewardAlert = alert;
    [alert show];
    
    
}

-(void)getCoinsTapped
{
    [CommonUtility coinsChange:80];
    [self.coinsShowing setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
    [self.dailyRewardAlert close];
}
//-(IBAction)segmentAction:(UISegmentedControl *)Seg{
//    NSInteger Index = Seg.selectedSegmentIndex;
////    NSLog(@"Seg.selectedSegmentIndex:%d",Index);
//    
//    [MobClick event:@"chooseDifficulty"];
//    int lastSeg = [[self.gameData objectForKey:@"difficulty"] intValue];
//
//    if ([self.continueGame isHidden]) {
// 
//        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%ld",(long)Index] forKey:@"difficulty"];
//        
//        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%ld",Index*20] forKey:@"currentLevel"];
//    }else
//    {
//        myAlertView *resetAlert = [[myAlertView alloc] initWithTitle:@"且慢!" message:@"变更难度将重置已猜歌曲的进度,请君三思。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
//        
//        resetAlert.lastSegmentIndex = lastSeg;
//        resetAlert.tag = 1;
//        
//        [resetAlert show];
//    }
//    
//}

#pragma mark button flash

-(void)buttonFlash
{
//    [self shimmerRegisterButton:self.difficultySegment];
}

-(void)shimmerRegisterButton:(UIView *)registerButtonView {
    registerButtonView.userInteractionEnabled=YES;
    
    
    UIImageView *sheenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, 0, 86, 35)];
    [sheenImageView setImage:[UIImage imageNamed:@"glow.png"]];
    [sheenImageView setAlpha:0.0];
    [registerButtonView addSubview:sheenImageView];
    [registerButtonView setNeedsDisplay];
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [sheenImageView setAlpha:1.0];
        [sheenImageView setFrame:CGRectMake(220, 0, 86, 35)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            [sheenImageView setFrame:CGRectMake(registerBtn.frame.size.width, 0, 86, 46)];
            [sheenImageView setAlpha:0.0];
        } completion:nil];
    }];
    
}



- (void)difficultyChanged:(UIButton *)sender {
    
    [CommonUtility tapSound:@"difficulty" withType:@"mp3"];
    
    NSLog(@"%ld",(long)sender.tag);
    
    NSInteger Index = sender.tag - 1 ;
    [MobClick event:@"chooseDifficulty"];
    
    
    [self changeDifficultyTo:[NSString stringWithFormat:@"%ld",(long)Index]];

    int lastSeg = [[self.gameData objectForKey:@"difficulty"] intValue];
    
    if ([self.continueGame isHidden]) {
        
        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%ld",(long)Index] forKey:@"difficulty"];
        
        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%ld",Index*20] forKey:@"currentLevel"];
    }else
    {
        myAlertView *resetAlert = [[myAlertView alloc] initWithTitle:@"且慢!" message:@"变更难度将重置已猜歌曲的进度,请君三思。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
        
        resetAlert.lastSegmentIndex = lastSeg;
        resetAlert.tag = 1;
        
        [resetAlert show];
    }


}

#pragma mark big advertisement
//
//-(void)dealloc
//{
//    _dmInterstitial.delegate = nil; // please set delegete = nil first
//}
- (NSString *)publisherId
{
    return  @"b33a25dc"; //@"your_own_app_id";
}

- (NSString*) appSpec
{
    //注意：该计费名为测试用途，不会产生计费，请测试广告展示无误以后，替换为您的应用计费名，然后提交AppStore.
    return @"b33a25dc";
}
- (void)bigADshow
{
    // 在需要呈现插屏广告前，先通过isReady方法检查广告是否就绪
    // before present advertisement view please check if isReady
    NSLog(@"bigADshow!!");
    if (self.interstitialView.isReady)
    {
       
        [self.interstitialView presentFromRootViewController:self];
        

        
    }
    else
    {
        // 如果还没有ready，可以再调用loadAd
        // if !ready load again
       
        [self.interstitialView load];
        if (timer != nil)
        {
            
            
            [timer invalidate];
            
            
            timer = nil;
            
            
        }
        
        
        
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(bigADshow) userInfo:nil repeats:NO];
    }
}


-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    
    NSLog(@"delegate: will display ad");
    
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{
    NSLog(@"delegate: failedDisplayAd %d", reason);
}
-(NSArray*) keywords{
    NSArray* keywords = [NSArray arrayWithObjects:@"猜歌",@"混音",@"音乐",@"歌曲",@"听觉",@"耳力",@"song",@"歌手",@"唱歌", nil];
    return keywords;
}

-(NSArray*) userHobbies{
    NSArray* hobbies = [NSArray arrayWithObjects:@"唱歌",@"音乐", nil];
    return hobbies;
}
/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial
{
    NSLog(@"[ Interstitial] success to load ad.");
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial
{
    NSLog(@"［Interstitial] fail to load ad");

}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial
{
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial
{
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason
{
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial
{
    if (timer != nil)
            {
                [timer invalidate];
                timer = nil;
        
            }
        
        
        
            timer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(bigADshow) userInfo:nil repeats:NO];
        
           // 插屏广告关闭后，加载一条新广告用于下次呈现
            //prepair for the next advertisement view
            [self.interstitialView load];
}

//
//- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] success to load ad.");
//}
//
//// 当插屏广告加载失败后，回调该方法
//// This method will be used after failed
//- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err
//{
//
//    
//    NSLog(@"[Domob Interstitial] fail to load ad. %@", err);
//}
//
//// 当插屏广告要被呈现出来前，回调该方法
//// This method will be used before being presented
//- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] will present.");
//}
//
//// 当插屏广告被关闭后，回调该方法
//// This method will be used after Interstitial view  has been closed
//- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] did dismiss.");
//    if (timer != nil)
//    {
//        [timer invalidate];
//        timer = nil;
//        
//    }
//    
//    
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(bigADshow) userInfo:nil repeats:NO];
//    
//    // 插屏广告关闭后，加载一条新广告用于下次呈现
//    //prepair for the next advertisement view
//    [_dmInterstitial loadAd];
//}
//
//// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
//// When will be showing a Modal View, call this method. Such as open built-in browser
//- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] will present modal view.");
//}
//
//// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
//// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
//- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] did dismiss modal view.");
//}
//
//// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
//// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
//- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial
//{
//    NSLog(@"[Domob Interstitial] will enter background.");
//}


#pragma mark music note animation
-(void)dropDown
{

    
    for (int i = 0; i<8; i++) {
        
        double size = [self randomSize];
        CGRect aframe = CGRectMake([self randomXfrom:40*i toEnd:40+40*i], -50, size, size);
        [self setupAnimationNote:self.musicNotes[i] imageName:[NSString stringWithFormat:@"note%d",i] ImageFrame:aframe];
        
    }

    [self.view sendSubviewToBack:self.backgroundImg];

    
    

}

-(double)randomXfrom:(int)startX toEnd:(int)endX
{
    unsigned int randomNumber = startX + arc4random()%(endX - startX);
    return (double)randomNumber;

}
-(double)randomY
{
    unsigned int randomNumber = 20 + arc4random()%120;
    return (double)randomNumber;
    
}
-(double)randomSize
{
    unsigned int randomNumber = 20 + arc4random()%30;
    return (double)randomNumber;
    
}
-(int)randomSpeed
{
    unsigned int randomNumber = 20 + arc4random()%100;
    return randomNumber;
}

-(void)setupAnimationNote:(UIImageView *)NoteImageView imageName:(NSString *)ImgName ImageFrame:(CGRect)imgFrame
{
    NoteImageView = [[UIImageView alloc] initWithFrame:imgFrame];
    [NoteImageView setImage:[UIImage imageNamed:ImgName]];
    NoteImageView.alpha = 0;
    [self.view addSubview:NoteImageView];
    [self.view sendSubviewToBack:NoteImageView];
    
    fallAnimation *myFall = [[fallAnimation alloc] initWithView:NoteImageView];
    

    [myFall startDisplayLink];
//    [myFall performSelector:@selector(startDisplayLink) withObject:nil afterDelay:0.05];
    
}


@end

