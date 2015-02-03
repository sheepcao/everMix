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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics: UIBarMetricsDefault];

    [self.navigationController setNavigationBarHidden:NO];
    
    self.coinShow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.coinShow setFrame:CGRectMake(self.navigationController.view.frame.size.width - 95, 3, 92, 34)];
    [self.coinShow setTitleEdgeInsets:UIEdgeInsetsMake(0.0,30.0, 0.0, 0.0)];
    [self.coinShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.coinShow.titleLabel.textAlignment = NSTextAlignmentLeft ;
    


    NSString *currentCoins = [NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]];
    [self.coinShow setTitle:currentCoins forState:UIControlStateNormal];
    

    UIImageView *coinImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 30, self.coinShow.frame.size.height)];
    [coinImage setImage:[UIImage imageNamed:@"money-128"]];
    [self.coinShow addSubview:coinImage];
    
    [self.coinShow addTarget:self action:@selector(buyCoinsAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.coinShow];
    self.navigationItem.rightBarButtonItem = barButton;


    
//    [self.view addSubview:self.coinShow];
//    [self.view bringSubviewToFront:self.coinShow];
    
//    [self.navigationController.view addSubview:self.coinShow];
    
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
    
    NSString *currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];
    
    //统计用户游戏难度
    switch ([currentDifficulty intValue]) {
        case 0:
            [MobClick event:@"playDifficulty1"];
            break;
        case 1:
            [MobClick event:@"playDifficulty2"];

            break;
        case 2:
            [MobClick event:@"playDifficulty3"];

            break;
        case 3:
            [MobClick event:@"playDifficulty4"];

            break;
        case 4:
            [MobClick event:@"playDifficulty5"];

            break;
            
        default:
            break;
    }

//AD...
    
    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJxqiIuN5cJKR8fX" placementId:@"16TLej7oApZ2kNUO7NRnvYss" autorefresh:YES];
    _dmAdView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - FLEXIBLE_SIZE.height-44, FLEXIBLE_SIZE.width,FLEXIBLE_SIZE.height);
    _dmAdView.delegate = self;
    [_dmAdView setKeywords:@"音乐"];
    _dmAdView.rootViewController = self; // 设置 RootViewController
    [self.view addSubview:_dmAdView]; // 将广告视图添加到⽗视图中

    [_dmAdView loadAd];
    
    [self.view bringSubviewToFront:self.playConsoleView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"gamePage"];
    

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 设置广告视图的位置

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop10secondMusics) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop13secondMusics) object:nil];
    [self stopMusics];
    isplayed =false;


}


-(void)buyCoinsAction
{
    [MobClick event:@"bugCoinClick"];
    
    if (!self.buyCoinsView) {
        
        self.buyCoinsView = [[[NSBundle mainBundle] loadNibNamed:@"buyCoinsViewController" owner:self options:nil] objectAtIndex:0];
    }
    
    
    UILabel *coinsLabel = (UILabel *)[self.buyCoinsView viewWithTag:2];
    [coinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
    self.myBuyController = [[buyCoinsViewController alloc] initWithCoinLabel:coinsLabel andParentController:self adnParentCoinButton:self.coinShow];
    
    [self.buyCoinsView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.buyCoinsView];
    
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
    
    [UIView animateWithDuration:0.65 delay:0.05 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyCoinsView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    

}

-(void)closingBuy
{
    [UIView animateWithDuration:0.65 delay:0.05 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyCoinsView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];
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
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,self.downPartView.frame.size.height - 50)];
        self.choicesBoardView.songName = @"";
        [self.choicesBoardView setupBoard];
        [self.view addSubview:self.choicesBoardView];
        
        
        //下滑回收
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        
        [self.choicesBoardView addGestureRecognizer:recognizer];

    }
    //only support less than 7 letters.
    NSLog(@"center:%f",self.choicesBoardView.center.x);
    CGFloat firstAnswerSquare_X = (self.choicesBoardView.center.x - (40+2) *songName.length/2);//considering the distance between two squares . distance = 2.
    UIImage *buttonBackImage = [UIImage imageNamed:@"answerBack7"];
    for (int i = 0; i<songName.length; i++) {
         UIButton *answerButton = (UIButton *)[self.choicesBoardView viewWithTag:1];
        
        AnswerButton *myAnswerBtn = [[AnswerButton alloc] initWithFrame:CGRectMake(firstAnswerSquare_X+1 + i*(2+40), answerButton.frame.origin.y - 75, 38, 38)];
        
        [myAnswerBtn addTarget:self action:@selector(answerTapped:) forControlEvents:UIControlEventTouchUpInside];
        myAnswerBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];        [myAnswerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    [self.deleteButton setEnabled:YES];
    [self.playSingleButton setEnabled:YES];
    [self.showAnswerButton setEnabled:YES];

    
    [UIView animateWithDuration:0.9 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.89 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,self.downPartView.frame.origin.y, self.downPartView.frame.size.width,self.downPartView.frame.size.height - 50)];
    } completion:nil];
    
    //init this song's answer pick count.
    self.choicesBoardView.songName = songName;
    self.choicesBoardView.songNumber = diskNumber;

    answerPickedCount = 0;
    
//    NSLog(@"buttonText:%@",sender.titleLabel.text);
//    NSLog(@"buttonNum:%@",[self.diskButtons[diskNumber] titleLabel].text);

    
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    //如果往下滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        //先加载数据，再加载动画特效
        
        [self returnChoicesBoard:nil];
        
    }
    
}

-(void)answerTapped:(AnswerButton *)sender
{
//    NSLog(@"tag:%ld",sender.tag);
    
    if  (sender.titleLabel.text && ![sender.titleLabel.text isEqualToString:@" "])
    {
        [sender setTitle:@" " forState:UIControlStateNormal];
        UIButton *isFromButton = (UIButton *)[self.choicesBoardView viewWithTag:sender.isFromTag];
        [isFromButton setHidden:NO];
        answerPickedCount --;
    }
    
    if([sender.titleLabel.textColor isEqual:[UIColor redColor]])
    {
            for (UIButton *subview in [self.choicesBoardView subviews]) {
                if ([subview isKindOfClass:[AnswerButton class]]) {
                    
                    [subview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        
    }
  

    
}



- (IBAction)choicesTaped:(UIButton *)sender {
    
    NSMutableArray *decisions = [[NSMutableArray alloc] init];
    
    for (UIButton *subview in [self.choicesBoardView subviews]) {
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
            [MobClick event:@"rightAnswer"];

            [self.diskButtons[self.choicesBoardView.songNumber] setHidden:YES];
            UILabel *songResult = [[UILabel alloc] initWithFrame:[(UIButton *)self.diskButtons[self.choicesBoardView.songNumber] frame] ];
            songResult.text = songNameGuessed;
            songResult.font = [UIFont fontWithName:@"Oriya Sangam MN" size:18];
            songResult.numberOfLines = 2;
            songResult.textAlignment = NSTextAlignmentCenter;
            
            [self.downPartView addSubview:songResult];
            [self.musicsPlayArray removeObject:songNameGuessed];
            [self returnChoicesBoard:nil];

            if (self.musicsPlayArray.count == 0) {

                
                [self modifyPlist:@"gameData" withValue:self.musicsPlayArray forKey:@"musicPlaying"];
                
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
            [MobClick event:@"wrongAnswer"];

            for (UIButton *subview in [self.choicesBoardView subviews]) {
                if ([subview isKindOfClass:[AnswerButton class]]) {
                    
                    //1
                    [UIView transitionWithView:subview duration:0.18 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [subview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    } completion:^(BOOL finished) {
                        
                        //2
                        [UIView transitionWithView:subview duration:0.18 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        } completion:^(BOOL finished) {
                            
                            //3
                            [UIView transitionWithView:subview duration:0.18 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                [subview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            } completion:^(BOOL finished) {
                                
                                //4
                                [UIView transitionWithView:subview duration:0.18 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                } completion:^(BOOL finished) {
                                    
                                    //5
                                    [UIView transitionWithView:subview duration:0.18 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                        [subview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                    } completion:^(BOOL finished) {
                                        
                                    }];
                                    
                                    
                                }];
                                
                                
                            }];
                            
                            
                        }];
                        
                        
                    }];
                }
            }
//            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"再试一次" message:@"答错啦，大侠重头来过吧" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新来过", nil];
//            failAlert.tag = 1;
//            [failAlert show];
        }
    }
    
    
}

-(BOOL)checkCoins:(int)price
{
    if ([CommonUtility fetchCoinAmount] < price) {
       
        UIAlertView *coinsShort = [[UIAlertView alloc] initWithTitle:@"没钱啦" message:@"金币不够啦,买点继续玩呀。" delegate:self cancelButtonTitle:@"暂不购买" otherButtonTitles:@"去看看", nil];
        [coinsShort show];
        
        return NO;
    }else
    {
        return YES;
    }
}

- (IBAction)deleteSomeWords {
    
    if ([self checkCoins:DELETE_PRICE])
    {
        
        UIAlertView *deleteWordsAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认花掉%d个金币去掉5个错误选项?",DELETE_PRICE] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [deleteWordsAlert show];
        deleteWordsAlert.tag = 10;
        
        
    }
}

-(void)stopSingleMusic
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop10secondMusics) object:nil];

    
    for (AVAudioPlayer *audio in self.myAudioArray) {
        if ([audio isPlaying]) {
            [audio stop];
            
        }
    }
}

-(void)stop10secondMusics
{
    [self.playSingleButton setEnabled:YES];
    [self stopSingleMusic];

}

- (IBAction)playSingleSong {
    
    if ([self checkCoins:SINGLE_SONG_PRICE]){
        
        UIAlertView *playSingleAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认花掉%d个金币进行单曲播放?",SINGLE_SONG_PRICE] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [playSingleAlert show];
        playSingleAlert.tag = 11;
       
    }

}

- (IBAction)showFullAnswer {
    
    if ([self checkCoins:SHOW_ANSWER_PRICE]){
        
        UIAlertView *playSingleAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认花掉%d个金币购买此单曲完整答案?",SHOW_ANSWER_PRICE] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [playSingleAlert show];
        playSingleAlert.tag = 12;
        
    }
}

- (IBAction)shareButton:(UIButton *)sender {
    
    [MobClick event:@"shareFromGame"];

    [UMSocialSnsService presentSnsIconSheetView:self
                        appKey:@"54c46ea7fd98c5071d000668"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:(id)self];
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
- (IBAction)refreshMusics:(UIButton *)sender {//delete one song
    [MobClick event:@"bombOne"];

    
    if(self.musicsPlayArray.count <= 1)
    {
        UIAlertView *noDeleteAlert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"就剩一首了，再删就没得玩啦" delegate:nil cancelButtonTitle:@"继续猜" otherButtonTitles:nil, nil];
        [noDeleteAlert show];
        return;
    }
    
    if ([self checkCoins:BOMB_SONG_PRICE]){
        
        UIAlertView *playSingleAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认花掉%d个金币去除一首混播歌曲?",BOMB_SONG_PRICE] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [playSingleAlert show];
        playSingleAlert.tag = 13;
        
    }
    
//    int diskNumber = -1;
//    
//    for(int i = (int)(self.diskButtons.count -1) ; i >= 0 ; i-- )
//    {
//        if (![self.diskButtons[i] isHidden]) {
//            diskNumber = i;
//            
//            UILabel *ignoreLabel = [[UILabel alloc] initWithFrame:[self.diskButtons[i] frame]];
//            [ignoreLabel setText:@"无视"];
//            [self. downPartView addSubview:ignoreLabel];
//            [self.diskButtons[i] setHidden:YES];
//            
//            break;
//        }
//    }
//    NSString *songName = self.musicsArray[diskNumber];
//    
//    [self.musicsArray removeObject:songName];
//    [self.musicsPlayArray removeObject:songName];
//
//
//    
//    self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;
//    
//    NSMutableArray *currentMusics = [self.gameDataForSingleLevel objectForKey:@"musicPlaying"];
//    [currentMusics removeObject:songName];
//    [self modifyPlist:@"gameData" withValue:currentMusics forKey:@"musicPlaying"];
    
    
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
            
            self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;
            NSString *currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];
            
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",[currentDifficulty intValue]+1] forKey:@"difficulty"];
            [self nextLevel];
        }
        
        if (alertView.tag == 10)//删除错误选项
        {
            [MobClick event:@"deleteChoice"];

            NSString *songName = self.choicesBoardView.songName;
            int i = 0;
            while (i<5) {
                
                unsigned int randomNumber = 1+ arc4random()%21;  //1~21
                UIButton *answerButton = (UIButton *)[self.choicesBoardView viewWithTag:randomNumber];
                if ([CommonUtility myContainsStringFrom:songName for:answerButton.titleLabel.text] || answerButton.isHidden) {
                    continue;
                }else
                {
                    [answerButton setHidden:YES];
                    i++;
                }
                
            }
            
            [self.deleteButton setEnabled:NO];
            [CommonUtility coinsChange:-DELETE_PRICE];

        }
        
        if (alertView.tag == 11)//单曲播放

        {
            [MobClick event:@"playSingleSone"];

            
            NSString *songName = self.choicesBoardView.songName;
            
            [self.myAudioArray removeAllObjects];
            [self tapSound:songName withType:@"m4a"];
            [self.playSingleButton setEnabled:NO];
            [self performSelector:@selector(stop10secondMusics) withObject:nil afterDelay:10.0f];
            
            [CommonUtility coinsChange:-SINGLE_SONG_PRICE];

        }
        
        if (alertView.tag == 12)//公布答案
        {
            [MobClick event:@"showAnswer"];

            NSString *songName = self.choicesBoardView.songName;
            for (int i = 0; i < [songName length]; i++) {
               AnswerButton *myAnswerbtn =(AnswerButton *)[self.choicesBoardView viewWithTag:(100+i)];
                [myAnswerbtn setTitle:[songName substringWithRange:NSMakeRange(i, 1)] forState:UIControlStateNormal];
                
            }
            
            
            [self.diskButtons[self.choicesBoardView.songNumber] setHidden:YES];
            UILabel *songResult = [[UILabel alloc] initWithFrame:[(UIButton *)self.diskButtons[self.choicesBoardView.songNumber] frame] ];
            songResult.text = songName;
            songResult.font = [UIFont fontWithName:@"Oriya Sangam MN" size:16];
            songResult.numberOfLines = 2;
            [self.downPartView addSubview:songResult];
            [self.musicsPlayArray removeObject:songName];
            
            
            [self.showAnswerButton setEnabled:NO];
            
            [CommonUtility coinsChange:-SHOW_ANSWER_PRICE];

        }
        
        if (alertView.tag == 13)//去除一首混播歌曲
        {
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
            
            
            
            self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;
            
            NSMutableArray *currentMusics = [self.gameDataForSingleLevel objectForKey:@"musicPlaying"];
            [currentMusics removeObject:songName];
            [self modifyPlist:@"gameData" withValue:currentMusics forKey:@"musicPlaying"];
            
            [CommonUtility coinsChange:-BOMB_SONG_PRICE];

        }
    }
}


- (IBAction)returnChoicesBoard:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
        [self.choicesBoardView setFrame:CGRectMake(self.downPartView.frame.origin.x,[UIScreen mainScreen].bounds.size.height , self.downPartView.frame.size.width,self.downPartView.frame.size.height - 50)];
    } completion:^(BOOL finished){
    
        if (finished) {
            
            [self stopSingleMusic];
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
    [UIView animateWithDuration: 0.015f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         destRotateView.transform = CGAffineTransformRotate(destRotateView.transform, M_PI/128 );
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
    [self.playBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];

    
    [self enableButtons];
}

-(void)enableButtons
{
    for (int i=0;i<self.diskButtons.count;i++) {
        
        UIButton *button = self.diskButtons[i];
        
        [UIView animateWithDuration: 0.03f
                              delay: 0.0f
                            options: 0
                         animations: ^{
                             button.transform = CGAffineTransformRotate(button.transform, -((totalRotateTimes)%256 ) *( M_PI/128));
                         }
                         completion:nil];
        
        if (![button isHidden]) {
            [button setEnabled:YES];
            [button setTitle:[NSString stringWithFormat:@"%lu字歌",(unsigned long)[self.musicsArray[i] length]] forState:UIControlStateNormal];

        }
    }
    totalRotateTimes = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playBtn:(id)sender {
   
    
    [MobClick event:@"playTap"];
    [self.playBtn setTitle:self.levelTitle forState:UIControlStateNormal];
    if (isplayed) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop13secondMusics) object:nil];
        
        [self stopMusics];
        
        isplayed =false;
    }else
    {
        [self initMusics];
        isplayed = true;
        
        [self performSelector:@selector(stop13secondMusics) withObject:nil afterDelay:13.0f];
    }
//    [self performSelector:@selector(PlayStart) withObject:nil afterDelay:0.5f];


}


-(void)initMusics
{
    [self.myAudioArray removeAllObjects];
    
    for (int i = 0; i< self.musicsPlayArray.count; i++) {
        [self tapSound:self.musicsPlayArray[i] withType:@"m4a"];
    }
    [self startSpin];
    [self.playBtn setImage:[UIImage imageNamed:@"停止"] forState:UIControlStateNormal];
    [self.deleteOneBtn setEnabled:NO];
    [self.shareBtn setEnabled:NO];

}
-(void)stop13secondMusics
{
    if (isplayed) {
        [self stopMusics];
        isplayed =false;
    }
}



-(void)nextLevel
{
    
    self.gameDataForSingleLevel = [self readDataFromPlist:@"gameData"] ;

    NSString *currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];

    int levelNow = [[self.gameDataForSingleLevel objectForKey:@"currentLevel"] intValue];
    [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",levelNow+1] forKey:@"currentLevel"];
    
    gameViewController *myGameViewController = [[gameViewController alloc] initWithNibName:@"gameViewController" bundle:nil];

    
    NSMutableArray *currentMusics = [self.gameDataForSingleLevel objectForKey:@"musicPlaying"];

    if (currentMusics && currentMusics.count > 0) {
        
        myGameViewController.musicsArray = currentMusics;
        
    }else
    {
        NSMutableArray *passMusics = [self.delegate configSongs];
        myGameViewController.musicsArray = passMusics;
        [self modifyPlist:@"gameData" withValue:passMusics forKey:@"musicPlaying"];

        
    }
    

    
    myGameViewController.delegate = self.delegate;
    myGameViewController.navigationItem.title = [NSString stringWithFormat:@"%d",(levelNow + 1 - [currentDifficulty intValue]*20)];
    myGameViewController.currentDifficulty = [self.gameDataForSingleLevel objectForKey:@"difficulty"];
    
    NSArray *arrayControllers = self.navigationController.viewControllers;
    NSMutableArray *arrayControllerNew = [NSMutableArray arrayWithArray:arrayControllers];
    [arrayControllerNew removeLastObject];
    [arrayControllerNew addObject:myGameViewController];
    [self.navigationController setViewControllers:arrayControllerNew animated:YES];
    
    [MobClick event:@"levelPass"];

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

#pragma mark AD..
- (void)viewDidUnload {
    [super viewDidUnload];
    [_dmAdView removeFromSuperview]; // 将⼲⼴广告试图从⽗父视图中移除
}
    //针对 Banner 的横竖屏⾃自适应⽅方法 //method For multible orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
duration:(NSTimeInterval)duration
{
   [_dmAdView orientationChanged];
}

- (void)dealloc
{
   
    _dmAdView.delegate = nil;
    
    _dmAdView.rootViewController = nil;
}


#pragma mark DMAdView delegate

// 成功加载广告后，回调该方法
// This method will be used after load successfully
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] success to load ad.");
}

// 加载广告失败后，回调该方法
// This method will be used after load failed
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    
    NSLog(@"[Domob Sample] fail to load ad. %@", error);
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器
// When will be showing a Modal View, this method will be called. Such as open built-in browser
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will enter background.");
}


@end
