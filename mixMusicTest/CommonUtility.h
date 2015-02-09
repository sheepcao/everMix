//
//  CommonUtility.h
//  ActiveWorld
//
//  Created by Eric Cao on 10/30/14.
//  Copyright (c) 2014 Eric Cao/Mady Kou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomIOS7AlertView.h"


@interface CommonUtility : NSObject
{
    AVAudioPlayer *myAudioPlayer;
}

@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;

+ (CommonUtility *)sharedCommonUtility;
+ (BOOL)isSystemLangChinese;
+ (void)tapSound;
+ (void)tapSound:(NSString *)name withType:(NSString *)type;
+ (BOOL)isSystemVersionLessThan7;
+ (BOOL)myContainsStringFrom:(NSString*)str for:(NSString*)other;
+ (BOOL)checkFavoritesWithCurrentLevel:(int)levelNow;
+ (void)addToFavoratesWith:(int)level and:(NSString *)levelName By:(UIButton *)button;
+ (void)removeFavoratesWith:(int)level By:(UIButton *)button;
+ (void)removeFavoritesOnCell:(NSInteger)row;

+ (void)coinsChange:(int)coinAmount;
+ (int)fetchCoinAmount;
+ (void)dailyRewardWithButton:(UIButton *)button;

@end
