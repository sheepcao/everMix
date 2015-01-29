//
//  boardView.m
//  mixMusicTest
//
//  Created by Eric Cao on 12/29/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import "boardView.h"

@implementation boardView

-(id)init
{
    self = [super init];
    if (self != nil) {
    
        self.songName = @"";
        self.hasDeleted = NO;
        self.hasPlayedSingleSong = NO;
        
    }
    return self;
}

-(void)setupBoard
{
    self.songName = @"";
    self.hasDeleted = NO;
    self.hasPlayedSingleSong = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
