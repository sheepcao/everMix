//
//  ViewController.m
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import "gameViewController.h"

@interface gameViewController ()<UIAlertViewDelegate>

@property (nonatomic ,strong) NSMutableArray *ignoreArray;

@end

bool isplayed;
BOOL animating;
int totalRotateTimes;
int answerPickedCount;
@implementation gameViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];

    self.ignoreArray = [[NSMutableArray alloc] init];
    
    self.diskButtonFrameArray = [[NSMutableArray alloc] init];
    
    self.musicsPlayArray = [NSMutableArray arrayWithArray:self.musicsArray];
    self.myAudioArray = [NSMutableArray new];
    self.singleMusicsViewArray = [NSMutableArray new];

    isplayed =false;
    
    [self setupButtonsView];

    [self diskHideToTop];
    [self diskPopUp];
    self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;

    
    [self.view bringSubviewToFront:self.playConsoleView];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop10secondMusics) object:nil];
    [self stopMusics];
    isplayed =false;


}


-(void)setupButtonsView
{
    CGFloat distance = 33;
    
    UIButton *cd1Btn = [[UIButton alloc] initWithFrame:CGRectMake(50, distance, CD_SZIE, CD_SZIE)];
    UIButton *cd2Btn = [[UIButton alloc] initWithFrame:CGRectMake(190, distance, CD_SZIE, CD_SZIE)];
    UIButton *cd3Btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 2*distance+CD_SZIE, CD_SZIE, CD_SZIE)];
    UIButton *cd4Btn = [[UIButton alloc] initWithFrame:CGRectMake(190, 2*distance+CD_SZIE, CD_SZIE, CD_SZIE)];
    UIButton *cd5Btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 3*distance+2*CD_SZIE, CD_SZIE, CD_SZIE)];
    
    [cd1Btn addTarget:self action:@selector(diskTap:) forControlEvents:UIControlEventTouchUpInside];
    [cd2Btn addTarget:self action:@selector(diskTap:) forControlEvents:UIControlEventTouchUpInside];
    [cd3Btn addTarget:self action:@selector(diskTap:) forControlEvents:UIControlEventTouchUpInside];
    [cd4Btn addTarget:self action:@selector(diskTap:) forControlEvents:UIControlEventTouchUpInside];
    [cd5Btn addTarget:self action:@selector(diskTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cd1Btn setImage:[UIImage imageNamed:@"cd1"] forState:UIControlStateDisabled];
    [cd2Btn setImage:[UIImage imageNamed:@"cd2"] forState:UIControlStateDisabled];
    [cd3Btn setImage:[UIImage imageNamed:@"cd3"] forState:UIControlStateDisabled];
    [cd4Btn setImage:[UIImage imageNamed:@"cd4"] forState:UIControlStateDisabled];
    [cd5Btn setImage:[UIImage imageNamed:@"cd5"] forState:UIControlStateDisabled];
    
    self.diskButtons = [NSArray arrayWithObjects:cd1Btn,cd2Btn,cd3Btn,cd4Btn,cd5Btn, nil];
    for (int i = 0; i<self.diskButtons.count; i++) {
        UIButton *button = self.diskButtons[i];
        [button setBackgroundImage:[UIImage imageNamed:@"cycle"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self.downPartView addSubview:cd1Btn];
    [self.downPartView addSubview:cd2Btn];
    [self.downPartView addSubview:cd3Btn];
    [self.downPartView addSubview:cd4Btn];
    [self.downPartView addSubview:cd5Btn];


}

- (void)diskTap:(UIButton *)sender {
//    sender.tag = 1;
    
    NSDictionary *allAnswers = [self.gameDataForSingleLevel objectForKey:@"choices"];

    int diskNumber = -1;
    
    for(int i = 0 ; i < self.diskButtons.count ; i++ )
    {
        if (sender == self.diskButtons[i]) {
            diskNumber = i;
        }
    }
    NSString *songName = self.musicsArray[diskNumber];
    NSString *songAnswer = [allAnswers objectForKey:songName];
    NSArray *songAnswerSingleLetter = [songAnswer componentsSeparatedByString:@","];
    NSLog(@"answer count:%ld",(unsigned long)songAnswerSingleLetter.count);
    NSLog(@"songName:%@",songName);

    
    if(!self.choicesBoardView)
    {
        self.choicesBoardView = [[[NSBundle mainBundle] loadNibNamed:@"choicesBoardView" owner:self options:nil] objectAtIndex:0];
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
        self.choicesBoardView.songName = @"";
        [self.view addSubview:self.choicesBoardView];

    }
    //only support less than 7 letters.
    NSLog(@"center:%f",self.choicesBoardView.center.x);
    CGFloat firstAnswerSquare_X = (self.choicesBoardView.center.x - (40+2) *songName.length/2);//considering the distance between two squares . distance = 2.
    UIImage *buttonBackImage = [UIImage imageNamed:@"Square"];
    for (int i = 0; i<songName.length; i++) {
         UIButton *answerButton = (UIButton *)[self.choicesBoardView viewWithTag:1];
        
        AnswerButton *myAnswerBtn = [[AnswerButton alloc] initWithFrame:CGRectMake(firstAnswerSquare_X+1 + i*(2+40), answerButton.frame.origin.y - 75, 40, 40)];
        
        [myAnswerBtn addTarget:self action:@selector(answerTapped:) forControlEvents:UIControlEventTouchUpInside];
        myAnswerBtn.titleLabel.font = [UIFont systemFontOfSize:21];
        [myAnswerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        myAnswerBtn.tag = i+100;
        myAnswerBtn.isFromTag = -1;
        [myAnswerBtn setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
        [self.choicesBoardView addSubview:myAnswerBtn];
    }
    
//    NSLog(@"sub:%@",[self.choicesBoardView subviews]);

    for (int i = 1; i < 22; i++) {
        UIButton *answerButton = (UIButton *)[self.choicesBoardView viewWithTag:i];
        [answerButton setHidden:NO];
        [answerButton setTitle:songAnswerSingleLetter[i-1] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.9 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.89 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,self.downPartView.frame.origin.y, self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    
    //init this song's answer pick count.
    self.choicesBoardView.songName = songName;
    self.choicesBoardView.songNumber = diskNumber;

    answerPickedCount = 0;
    
//    NSLog(@"buttonText:%@",sender.titleLabel.text);
//    NSLog(@"buttonNum:%@",[self.diskButtons[diskNumber] titleLabel].text);

    
}

-(void)answerTapped:(AnswerButton *)sender
{
    NSLog(@"tag:%ld",sender.tag);
    
    if  (sender.titleLabel.text && ![sender.titleLabel.text isEqualToString:@" "])
    {
        [sender setTitle:@" " forState:UIControlStateNormal];
        UIButton *isFromButton = (UIButton *)[self.choicesBoardView viewWithTag:sender.isFromTag];
        [isFromButton setHidden:NO];
        answerPickedCount --;
    }
    
  

    
}

- (IBAction)choicesTaped:(UIButton *)sender {
    
    NSMutableArray *decisions = [[NSMutableArray alloc] init];
    
    for (UIView *subview in [self.choicesBoardView subviews]) {
        if ([subview isKindOfClass:[AnswerButton class]]) {
            [decisions insertObject:subview atIndex:(subview.tag-100)];
        }
    }
    
    for (int i = 0;i<decisions.count;i++) {
        AnswerButton *answer = decisions[i];
        if (!answer.titleLabel.text || [answer.titleLabel.text isEqualToString:@" "]) {
                
            [answer setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            answer.isFromTag =(int)sender.tag;
            answerPickedCount ++;
            
            [sender setHidden:YES];
            break;
        }
        
    }
    if (answerPickedCount == decisions.count) {
        NSString *songNameGuessed = @"";
        for (int i = 0;i<decisions.count;i++) {
            AnswerButton *answer = decisions[i];
            songNameGuessed = [songNameGuessed stringByAppendingString:answer.titleLabel.text];
        }
        if ([songNameGuessed isEqualToString:self.choicesBoardView.songName]) {
            NSLog(@"you got it");
            [self.diskButtons[self.choicesBoardView.songNumber] setHidden:YES];
            UILabel *songResult = [[UILabel alloc] initWithFrame:[(UIButton *)self.diskButtons[self.choicesBoardView.songNumber] frame] ];
            songResult.text = songNameGuessed;
            [self.downPartView addSubview:songResult];
            [self.musicsPlayArray removeObject:songNameGuessed];
            [self returnChoicesBoard:nil];

            if (self.musicsPlayArray.count == 0) {
//                NSMutableArray *currentMusics = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"] mutableCopy];
//                [currentMusics removeAllObjects];
//                [[NSUserDefaults standardUserDefaults] setObject:currentMusics forKey:@"currentMusics"];
                
                [self modifyPlist:@"gameData" withValue:[NSMutableArray arrayWithObject:nil] forKey:@"musicPlaying"];
                
                int levelNow = [[self.gameDataForSingleLevel objectForKey:@"currentLevel"] intValue];
                if (levelNow == 100) {
                    
                    UIAlertView *finishLevelAlert = [[UIAlertView alloc] initWithTitle:@"赞" message:@"玩爆关啦！我们会尽快更新曲库，请大大持续关注！" delegate:self cancelButtonTitle:@"耐心期待" otherButtonTitles:nil, nil];
                    [finishLevelAlert show];
                    
                }else if (levelNow % 20 == 0) {
                    UIAlertView *finishLevelAlert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"该难度已被你玩爆，下面来点更刺激的！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"勇往直前", nil];
                    finishLevelAlert.tag = 2;
                    [finishLevelAlert show];
                }else
                {
                     [self nextLevel];
                }
                
               
            }
            
        }else
        {
            NSLog(@"you failed it.");
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"再试一次" message:@"答错啦，大侠重头来过吧" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新来过", nil];
            failAlert.tag = 1;
            [failAlert show];
        }
    }
    
    
}

- (IBAction)shareButton:(UIButton *)sender {
}

- (IBAction)refreshMusics:(UIButton *)sender {//delete one song
    
    if(self.musicsPlayArray.count <= 1)
    {
        UIAlertView *noDeleteAlert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"就剩一首了，再删就没得玩啦" delegate:nil cancelButtonTitle:@"继续猜" otherButtonTitles:nil, nil];
        [noDeleteAlert show];
        return;
    }
        
    
    int diskNumber = -1;
    
    for(int i = (int)(self.diskButtons.count -1) ; i >= 0 ; i-- )
    {
        if (![self.diskButtons[i] isHidden]) {
            diskNumber = i;
            
            UILabel *ignoreLabel = [[UILabel alloc] initWithFrame:[self.diskButtons[i] frame]];
            [ignoreLabel setText:@"无视"];
            [self. downPartView addSubview:ignoreLabel];
            [self.diskButtons[i] setHidden:YES];
            
            break;
        }
    }
    NSString *songName = self.musicsArray[diskNumber];
    
    [self.musicsArray removeObject:songName];
    [self.musicsPlayArray removeObject:songName];

//    NSMutableArray *currentMusics = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"] mutableCopy];
//    [currentMusics removeObject:songName];
//    [[NSUserDefaults standardUserDefaults] setObject:currentMusics forKey:@"currentMusics"];
    
    self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;
    
    NSMutableArray *currentMusics = [self.gameDataForSingleLevel objectForKey:@"musicPlaying"];
    [currentMusics removeObject:songName];
    [self modifyPlist:@"gameData" withValue:currentMusics forKey:@"musicPlaying"];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (alertView.tag == 1) {
            
            for (UIView *subview in [self.choicesBoardView subviews]) {
                if ([subview isKindOfClass:[AnswerButton class]]) {
                    [((AnswerButton *)subview) setTitle:@" " forState:UIControlStateNormal];
                    answerPickedCount = 0;
                }
                [subview setHidden:NO];
            }
        }
        
        if (alertView.tag == 2) {
            [self nextLevel];
        }
    }
}


- (IBAction)returnChoicesBoard:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,[UIScreen mainScreen].bounds.size.height)];
    } completion:^(BOOL finished){
    
        if (finished) {
            for (UIView *subview in [self.choicesBoardView subviews]) {
                if ([subview isKindOfClass:[AnswerButton class]]) {
                    [subview removeFromSuperview];
                }
            }
        }
    }];
    

    
}


#pragma mark disk animation

- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.01f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         destRotateView.transform = CGAffineTransformRotate(destRotateView.transform, M_PI/32 );
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (destRotateView == self.diskButtons[0]) {
                                 totalRotateTimes ++;
                             }

                             if (animating) {
                                 // if flag still set, keep spinning with constant speed

                                [self spinWithOptions:UIViewAnimationOptionTransitionNone :destRotateView];
                                 
                                 
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        for (UIButton * button in self.diskButtons) {
            if (button.tag == 0) {
                [button setEnabled:NO];
                [button setTitle:@" " forState:UIControlStateNormal];
                [self spinWithOptions: UIViewAnimationOptionTransitionNone:button];
                NSLog(@"frame:%f",button.frame.origin.x);
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
        
       
        
        [self.diskButtons[i] setTitle:@" " forState:UIControlStateNormal];
        
        
        
        UILabel *ignoreLabel = [[UILabel alloc] initWithFrame:[self.diskButtons[i] frame]];
        [ignoreLabel setText:@"无视"];
        [self.ignoreArray insertObject:ignoreLabel atIndex:i];
        [self. downPartView addSubview:ignoreLabel];
        [ignoreLabel setHidden:YES];
        
        if (i >= musicCount && i <= [self.currentDifficulty intValue]) {
        
            [ignoreLabel setHidden:NO];

        }
        
        
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
        

        if (self.ignoreArray.count > 0 && self.ignoreArray[i]!=nil) {

        [UIView animateWithDuration:0.65+i*0.12 delay:0.35 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:0 animations:^{
            [self.ignoreArray[i] setFrame:[[self.diskButtonFrameArray objectAtIndex:i] CGRectValue]];
            
            
        } completion:nil];
    }

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
    
    NSLog(@"folderPath:%@",folderPath);

    if (soundFilePath)
    {
        NSError *error;
        
        NSFileManager *fileManager =[NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:folderPath] == NO)
        {
            
           BOOL success = [[NSFileManager defaultManager] copyItemAtPath:soundFilePath
                                                    toPath:folderPath
                                                     error:&error];
//            NSLog(@"Error description-%@ \n", [error localizedDescription]);
//            NSLog(@"Error reason-%@", [error localizedFailureReason]);
            NSLog(@"succsee:%d",success);
        }
        
    }
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:folderPath ];
    
    NSError *error;
    AVAudioPlayer *myAudioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    NSLog(@"error:%@",[error localizedDescription]);
    myAudioPlayer.volume = 1.0f;

    NSLog(@"Audio:%@",myAudioPlayer);
    if (myAudioPlayer) {
        [self.myAudioArray addObject:myAudioPlayer];
        [myAudioPlayer play];
    }
  
    
}
-(void)stopMusics
{
    for (AVAudioPlayer *audio in self.myAudioArray) {
        if ([audio isPlaying]) {
            [audio stop];
            
        }
    }
    [self stopSpin];
    [self.deleteOneBtn setEnabled:YES];
    [self.shareBtn setEnabled:YES];
    
    [self performSelector:@selector(enableButtons) withObject:nil afterDelay:0.35];
}

-(void)enableButtons
{
    for (int i=0;i<self.diskButtons.count;i++) {
        
        UIButton *button = self.diskButtons[i];
        
        [UIView animateWithDuration: 0.03f
                              delay: 0.0f
                            options: 0
                         animations: ^{
                             button.transform = CGAffineTransformRotate(button.transform, -(totalRotateTimes%64) *( M_PI/32));
                         }
                         completion:nil];
        
        if (![button isHidden]) {
            [button setEnabled:YES];
            [button setTitle:[NSString stringWithFormat:@"%lu字歌",[self.musicsArray[i] length]] forState:UIControlStateNormal];

        }
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
    
    for (int i = 0; i< self.musicsPlayArray.count; i++) {
        [self tapSound:self.musicsPlayArray[i] withType:@"m4a"];
    }
    [self startSpin];
    
    [self.deleteOneBtn setEnabled:NO];
    [self.shareBtn setEnabled:NO];

}
-(void)stop10secondMusics
{
    if (isplayed) {
        [self stopMusics];
        isplayed =false;
    }
}



-(void)nextLevel
{
    NSString *currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];

    int levelNow = [[self.gameDataForSingleLevel objectForKey:@"currentLevel"] intValue];
    [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",levelNow+1] forKey:@"currentLevel"];
    
    gameViewController *myGameViewController = [[gameViewController alloc] initWithNibName:@"gameViewController" bundle:nil];
//    myGameViewController.levelTitle = @"PLAY1234";
    
    
//    NSMutableArray *currentMusics = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"];
    
    self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;
    NSMutableArray *currentMusics = [self.gameDataForSingleLevel objectForKey:@"musicPlaying"];

    if (currentMusics && currentMusics.count > 0) {
        
        myGameViewController.musicsArray = currentMusics;
        
    }else
    {
        NSMutableArray *passMusics = [self.delegate configSongs];
        myGameViewController.musicsArray = passMusics;
        [self modifyPlist:@"gameData" withValue:passMusics forKey:@"musicPlaying"];

        
    }
    
//    NSMutableArray *passMusics = [self.delegate configSongs];
//    
//    myGameViewController.musicsArray = passMusics;
    
    myGameViewController.delegate = self.delegate;
    myGameViewController.navigationItem.title = [NSString stringWithFormat:@"%d",(levelNow + 1 - [currentDifficulty intValue]*20)];
    myGameViewController.currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];
    
    NSArray *arrayControllers = self.navigationController.viewControllers;
    NSMutableArray *arrayControllerNew = [NSMutableArray arrayWithArray:arrayControllers];
    [arrayControllerNew removeLastObject];
    [arrayControllerNew addObject:myGameViewController];
    [self.navigationController setViewControllers:arrayControllerNew animated:YES];
    
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

@end
