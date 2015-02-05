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

@property (nonatomic, strong) UIView *animatingView;
@property (nonatomic, strong) UIImageView *musicNote;
@property CGFloat topCon;
@property CGFloat frameBottom;
@property (nonatomic, strong) CADisplayLink *displayLink;



-(id)initWithView:(UIView *)animatingView;
- (void)startDisplayLink ;
@end
