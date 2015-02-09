//
//  CommonUtility.m
//  ActiveWorld
//
//  Created by Eric Cao on 10/30/14.
//  Copyright (c) 2014 Eric Cao/Mady Kou. All rights reserved.
//


#import "CommonUtility.h"

@implementation CommonUtility

@synthesize myAudioPlayer;

+(CommonUtility *)sharedCommonUtility
{
    static CommonUtility *singleton;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        singleton = [[CommonUtility alloc]init];
    });
    return singleton;
}

+ (BOOL)isSystemLangChinese
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    
    if([currentLang compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLang compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }else
    {
        return NO;
    }
}

+(void)tapSound
{
    SystemSoundID soundTap;
    
    CFBundleRef CNbundle=CFBundleGetMainBundle();
    
    CFURLRef soundfileurl=CFBundleCopyResourceURL(CNbundle,(__bridge CFStringRef)@"tapSound",CFSTR("wav"),NULL);
    //创建system sound 对象
    AudioServicesCreateSystemSoundID(soundfileurl, &soundTap);
    AudioServicesPlaySystemSound(soundTap);
}

+(BOOL)isSystemVersionLessThan7{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    } else {
        return NO;
    }
}

+(void)tapSound:(NSString *)name withType:(NSString *)type
{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    [CommonUtility sharedCommonUtility].myAudioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [CommonUtility sharedCommonUtility].myAudioPlayer.volume = 1.0f;
    [[CommonUtility sharedCommonUtility].myAudioPlayer play];
    
}

+ (BOOL)myContainsStringFrom:(NSString*)str for:(NSString*)other {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}

#pragma mark favoritesMethod
+ (void)addToFavoratesWith:(int)level and:(NSString *)levelName By:(UIButton *)button
{
    
    NSString *levelNum = [NSString stringWithFormat:@"%d",level];
    
    NSDictionary *oneFavor = [[NSDictionary alloc] initWithObjectsAndKeys:levelNum,@"levelNumber",levelName,@"levelName", nil];
    NSLog(@"onfavor:%@",oneFavor);
    
    NSMutableArray *favor = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveWorldFavorites"]];
    if(!favor)
    {
        favor = [[NSMutableArray alloc] init];
    }
    [favor addObject:oneFavor];
    NSArray *sortedFavor = [favor sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2){
        
        return [[p1 objectForKey:@"levelNumber" ] compare:[p2 objectForKey:@"levelNumber" ] options:NSNumericSearch];
        
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:sortedFavor forKey:@"ActiveWorldFavorites"];
    
    [button setImage:[UIImage imageNamed:@"icon_follow"] forState:UIControlStateNormal];
    
}
+ (void)removeFavoratesWith:(int)level By:(UIButton *)button
{
    NSString *levelNum = [NSString stringWithFormat:@"%d",level];
    
    NSMutableArray *favor = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveWorldFavorites"]];
    
    for (NSDictionary * onefavor in favor) {
        if ([[onefavor objectForKey:@"levelNumber"] isEqualToString:levelNum]) {
            [favor removeObject:onefavor];
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:favor forKey:@"ActiveWorldFavorites"];
    
    [button setImage:[UIImage imageNamed:@"icon_unfollow"] forState:UIControlStateNormal];
}
+ (void)removeFavoritesOnCell:(NSInteger)row
{
    NSMutableArray *favor = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveWorldFavorites"]];
    [favor removeObjectAtIndex:row];
    
    [[NSUserDefaults standardUserDefaults] setObject:favor forKey:@"ActiveWorldFavorites"];
}

+ (BOOL)checkFavoritesWithCurrentLevel:(int)levelNow
{
    NSString *levelInString = [NSString stringWithFormat:@"%d",levelNow];
    
    NSMutableArray *favor = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveWorldFavorites"]];
    for (NSDictionary *oneFavor in favor) {
        if ([[oneFavor objectForKey:@"levelNumber"] isEqualToString:levelInString]) {
            return YES;
        }
    }
    return  NO;
}


+ (void)coinsChange:(int)coinAmount
{

    NSString *currentCoinsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"coinsAmount"];
    int currentCoins = [currentCoinsString intValue];
    
    int afterCalculate = currentCoins + coinAmount;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",afterCalculate] forKey:@"coinsAmount"];
    
}

+ (int)fetchCoinAmount
{
    NSString *currentCoinsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"coinsAmount"];
    int currentCoins = [currentCoinsString intValue];
    return currentCoins;
}

+ (void)dailyRewardWithButton:(UIButton *)button
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

        [[CommonUtility sharedCommonUtility] giveReward:today andButton:button];
    
    }
    
}

-(void)giveReward:(NSString *)day andButton:(UIButton *)getCoins
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
    
    getCoins = [[UIButton alloc] initWithFrame:CGRectMake(tmpCustomView.frame.size.width/2 -35, tmpCustomView.frame.size.height-50, 70, 40)];
    [getCoins setTitle:@"领取" forState:UIControlStateNormal];
    [getCoins addTarget:self action:@selector(getCoinsTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [tmpCustomView addSubview:getCoins];
   
    [alert setContainerView:tmpCustomView];
    [alert show];
    
    
}

-(void)getCoinsTapped
{
    [CommonUtility coinsChange:1000];
    
}

@end
