//
//  fallAnimation.m
//  mixMusicTest
//
//  Created by Eric Cao on 2/5/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "fallAnimation.h"

@implementation fallAnimation


-(id)initWithView:(UIView *)aView
{
    self = [super init];
    if (self != nil) {
        
        self.animatingView = aView;

        
    }
    return self;
}
- (void)startDisplayLink {
    self.topCon = 0;
    self.frameBottom = 30;
    self.animatingView.alpha = 0;

    first = YES;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}


- (void)stopDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self performSelector:@selector(startDisplayLink) withObject:nil afterDelay:0.2];
    
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    //    static BOOL first = YES;
    static double startTime = 0;
    
    if (first) {
        startTime = displayLink.timestamp;
    }
    first = NO;
    double T = (double)displayLink.timestamp - startTime;
    
    //    NSLog(@"TTTTT:%f",T);
    self.topCon = ((30 * T * T)/2);
    //    NSLog(@"topCon:%f",self.topCon);
    if (self.topCon + self.frameBottom > 320) {
        [self stopDisplayLink];
    }else if (self.topCon + self.frameBottom < 320 && self.topCon + self.frameBottom > 30)
    {
        self.animatingView.alpha = 0.4 - (self.topCon + self.frameBottom-30)/500;
        CGRect aframe = CGRectMake(self.animatingView.frame.origin.x, self.topCon+self.frameBottom, self.animatingView.frame.size.width, self.animatingView.frame.size.height) ;
        aframe.origin.y += self.topCon;
        [self.animatingView setFrame:aframe];
    }else
    {
        self.animatingView.alpha =0.4 *(self.topCon + self.frameBottom)/30;
        CGRect aframe = CGRectMake(self.animatingView.frame.origin.x, self.topCon+self.frameBottom, self.animatingView.frame.size.width, self.animatingView.frame.size.height) ;
        aframe.origin.y += self.topCon;
        [self.animatingView setFrame:aframe];
    }
}
@end
