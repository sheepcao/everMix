//
//  ViewController.m
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import "ViewController.h"
#import "myAlertView.h"
@interface ViewController ()
@property (nonatomic,strong)CustomIOS7AlertView *dailyRewardAlert;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dailyReward];


    // Do any additional setup after loading the view.
    [self copyPlistToDocument:@"gameData"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coinsAmount"] ==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",500] forKey:@"coinsAmount"];
    }

    [self.view sendSubviewToBack:self.backgroundImg];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    
    NSString *currentCoins = [NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]];
    
    [self.coinsShowing setTitle:currentCoins forState:UIControlStateNormal];

    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gameData = [self readDataFromPlist:@"gameData"] ;
    NSString *currentDifficulty = [self.gameData objectForKey:@"difficulty"];
    
    [self drawStars:[currentDifficulty intValue]];
    
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

-(void)drawStars:(int)Differentlevel
{
    for (int i = 0; i<5; i++) {
        if (i <= Differentlevel) {
            [(UIButton *)self.starButtons[i] setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
        }
        if (i>Differentlevel) {
            [(UIButton *)self.starButtons[i] setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }
    }
    
    [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",Differentlevel] forKey:@"difficulty"];


    
}


- (IBAction)starTapped:(UIButton *)sender {
    
    if ([self.continueGame isHidden]) {
        int starNumber = -1; //init with a invalid value.
        
        for (int i = 0; i<5; i++) {
            if(sender == self.starButtons[i])
            {
                starNumber = i;
            }
            
        }
        
        [self drawStars:starNumber];
        [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",starNumber*20] forKey:@"currentLevel"];
        
    }else
    {
        myAlertView *resetAlert = [[myAlertView alloc] initWithTitle:@"且慢!" message:@"变更难度将重置已猜歌曲的进度,请君三思。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        resetAlert.chooseWhichButton = sender;
        resetAlert.tag = 1;
        
        [resetAlert show];
    }
    
    
    
//    int starNumber = -1; //init with a invalid value.
//    
//    for (int i = 0; i<5; i++) {
//        if(sender == self.starButtons[i])
//        {
//            starNumber = i;
//        }
//
//    }
//    
//    [self drawStars:starNumber];

}

-(void)resetPlist
{
    [self removePlistFromDocument:@"gameData"];
//    NSMutableArray *currentMusics = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"] mutableCopy];
//    [currentMusics removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] setObject:currentMusics forKey:@"currentMusics"];
    
    [self.begainGame setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
    [self.begainGame setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - self.continueGame.frame.size.width/2 , self.continueGame.frame.origin.y, self.continueGame.frame.size.width, self.continueGame.frame.size.height)];
    [self.continueGame setHidden:YES];
    
    
    
    [self copyPlistToDocument:@"gameData"];

}

- (void)alertView:(myAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        if (alertView.tag == 1) {
            //reset plist
            
            [self resetPlist];
            int starNumber = -1; //init with a invalid value.
            
            for (int i = 0; i<5; i++) {
                if(alertView.chooseWhichButton == self.starButtons[i])
                {
                    starNumber = i;
                }
                
            }
            
            [self drawStars:starNumber];
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",starNumber*20] forKey:@"currentLevel"];

        }
        if (alertView.tag == 2) {
            [self resetPlist];
            [self drawStars:2];
            [self modifyPlist:@"gameData" withValue:[NSString stringWithFormat:@"%d",2*20] forKey:@"currentLevel"];

            
        }

        
    }
  
}


- (IBAction)continueTapped:(UIButton *)sender {
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
    

//    NSMutableArray *currentMusics = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMusics"];
    self.gameData = [self readDataFromPlist:@"gameData"] ;

    NSMutableArray *currentMusics = [self.gameData objectForKey:@"musicPlaying"];

    if (currentMusics && currentMusics.count > 0) // renew game
    {
       
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
//        [[NSUserDefaults standardUserDefaults] setObject:passMusics forKey:@"currentMusics"];
        [self modifyPlist:@"gameData" withValue:passMusics forKey:@"musicPlaying"];

        myGameViewController.delegate = self;
        myGameViewController.navigationItem.title = [NSString stringWithFormat:@"%d",levelNow];
        myGameViewController.currentDifficulty = [self.gameData objectForKey:@"difficulty"];
        [self.navigationController pushViewController:myGameViewController animated:YES];

    }

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

//    buyCoinsViewController *myBuyCoinsViewController = [[buyCoinsViewController alloc] initWithNibName:@"buyCoinsViewController" bundle:nil];
//    [self.navigationController pushViewController:myBuyCoinsViewController animated:YES];

    if (!self.buyCoinsView) {
        
        self.buyCoinsView = [[[NSBundle mainBundle] loadNibNamed:@"buyCoinsViewController" owner:self options:nil] objectAtIndex:0];
    }

    
    UILabel *coinsLabel = (UILabel *)[self.buyCoinsView viewWithTag:2];
    [coinsLabel setText:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
    self.myBuyController = [[buyCoinsViewController alloc] initWithCoinLabel:coinsLabel andParentController:self adnParentCoinButton:self.coinsShowing];
 
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
@end
