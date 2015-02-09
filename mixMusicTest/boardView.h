//
//  boardView.h
//  mixMusicTest
//
//  Created by Eric Cao on 12/29/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface boardView : UIView

@property (nonatomic,strong) NSString *songName;
@property int songNumber;
@property bool hasDeleted;
@property bool hasPlayedSingleSong;


-(void)setupBoard;
@end
