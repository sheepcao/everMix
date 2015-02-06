//
//  fallAnimation.h
//  mixMusicTest
//
//  Created by Eric Cao on 2/5/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface fallAnimation : NSObject
{
    bool first;
}

@property (nonatomic, strong) UIImageView *animatingView;
@property (nonatomic, strong) UIImageView *musicNote;
@property CGFloat topCon;
@property CGFloat frameBottom;
@property CGFloat olderFrameBottom;
@property int speed;
@property (nonatomic, strong) CADisplayLink *displayLink;



-(id)initWithView:(UIView *)animatingView;
- (void)startDisplayLink ;
- (void)startDisplayOnGame;
@end
