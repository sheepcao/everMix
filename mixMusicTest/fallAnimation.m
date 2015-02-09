//
//  fallAnimation.m
//  mixMusicTest
//
//  Created by Eric Cao on 2/5/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "fallAnimation.h"

@implementation fallAnimation


-(id)initWithView:(UIImageView *)aView
{
    self = [super init];
    if (self != nil) {
        
        self.animatingView = aView;
        

        
    }
    return self;
}


- (void)startDisplayLink {
    
    double delay = [self randomFirstDelay];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    [self.animatingView setFrame:CGRectMake(self.animatingView.frame.origin.x, 100, self.animatingView.frame.size.width,self.animatingView.frame.size.height)];
    self.animatingView.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(endDisplayLink) withObject:nil afterDelay:0.05+delay];
    
    
    
}

- (void)startDisplayLink2 {
    
    double duration = [self randomDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];

    [self.animatingView setFrame:CGRectMake(self.animatingView.frame.origin.x, [self randomBottomWithFirstEndY:370 andEndDistance:200], self.animatingView.frame.size.width,self.animatingView.frame.size.height)];
    self.animatingView.alpha = 0;

    [UIView commitAnimations];
    
    [self performSelector:@selector(endDisplayLink) withObject:nil afterDelay:0.05+duration];

    
    
}
-(void)endDisplayLink
{
    double size = [self randomSize];
    [self.animatingView setFrame:CGRectMake([self randomXfrom:((int)(self.animatingView.frame.origin.x/40))*40  toEnd:40+((int)(self.animatingView.frame.origin.x/40))*40], -50, size,size)];
    [self.animatingView setImage:[self randomImage]];
    self.animatingView.alpha =0.4;
     [self performSelector:@selector(startDisplayLink2) withObject:nil afterDelay:0.01];


}


- (void)startDisplayOnGame {
    
    double delay = [self randomFirstDelay];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    [self.animatingView setFrame:CGRectMake(self.animatingView.frame.origin.x, 100, self.animatingView.frame.size.width,self.animatingView.frame.size.height)];
    self.animatingView.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(endDisplayOnGame) withObject:nil afterDelay:0.05+delay];
    
}

-(void)endDisplayOnGame
{
    double size = [self randomSize];
    [self.animatingView setFrame:CGRectMake([self randomXfrom:((int)(self.animatingView.frame.origin.x/40))*40  toEnd:40+((int)(self.animatingView.frame.origin.x/40))*40], -50, size,size)];
    [self.animatingView setImage:[self randomImage]];
    self.animatingView.alpha =0.22;
    [self performSelector:@selector(startDisplayOnGame2) withObject:nil afterDelay:0.01];
    
    
}

- (void)startDisplayOnGame2 {
    
    double duration = [self randomDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    [self.animatingView setFrame:CGRectMake(self.animatingView.frame.origin.x, [self randomBottomWithFirstEndY:100 andEndDistance:175], self.animatingView.frame.size.width,self.animatingView.frame.size.height)];
    self.animatingView.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(endDisplayOnGame) withObject:nil afterDelay:0.05+duration];
    
    
    
}

//- (void)startDisplayLink {
//    
//    [UIView animateWithDuration:[self randomDuration] delay:0.01 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
//        double size = [self randomSize];
//
//        [self.animatingView setFrame:CGRectMake(self.animatingView.frame.origin.x, [self randomBottom], size,size)];
//        self.animatingView.alpha = 0;
//
//    } completion:^(BOOL finished){
//        if (finished) {
//            double size = [self randomSize];
//            
//            [self.animatingView setFrame:CGRectMake([self randomXfrom:((int)(self.animatingView.frame.origin.x/40))*40  toEnd:40+((int)(self.animatingView.frame.origin.x/40))*40], 0, size,size)];
//            
//            [self.animatingView setImage:[self randomImage]];
//            
//            self.animatingView.alpha = 0.4;
//            
//            [self startDisplayLink];
//        }
//
//    }];
//    
//    
//}
//

//- (void)startDisplayLink {
//    self.topCon = 0;
//    self.frameBottom = -10;
//    self.animatingView.alpha = 0;
//
//    first = YES;
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
//    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    
//    
//}

//
//- (void)stopDisplayLink {
//    [self.displayLink invalidate];
//    self.displayLink = nil;
//    
//    double size = [self randomSize];
//    CGRect aframe = CGRectMake([self randomXfrom:((int)(self.animatingView.frame.origin.x/40))*40  toEnd:40+((int)(self.animatingView.frame.origin.x/40))*40], 0, size, size);
//    [self.animatingView setFrame:aframe];
//    [self.animatingView setImage:[self randomImage]];
//    self.olderFrameBottom = self.animatingView.frame.size.height + self.animatingView.frame.origin.y;
//
//    self.speed = [self randomSpeed];
//    
////    [self startDisplayLink];
//    [self performSelector:@selector(startDisplayLink) withObject:nil afterDelay:0.5];
//    
//}
//
//- (void)handleDisplayLink:(CADisplayLink *)displayLink{
//    //    static BOOL first = YES;
//    static double startTime = 0;
//    
//    if (first) {
//        startTime = displayLink.timestamp;
//    }
//    first = NO;
//    double T = (double)displayLink.timestamp - startTime;
//    
//    self.topCon = ((self.speed * T * T)/2);
//    if (self.topCon + self.frameBottom > [UIScreen mainScreen].bounds.size.height) {
//        [self stopDisplayLink];
//    }else
//    {
//        self.animatingView.alpha = 0.4 - (self.topCon + self.frameBottom-0)/500;
//        CGRect aframe = CGRectMake(self.animatingView.frame.origin.x, self.topCon+self.frameBottom, self.animatingView.frame.size.width, self.animatingView.frame.size.height) ;
//        aframe.origin.y += self.topCon;
//        [self.animatingView setFrame:aframe];
//    }
//}


-(double)randomXfrom:(int)startX toEnd:(int)endX
{
    unsigned int randomNumber = startX + arc4random()%(endX - startX);
    return (double)randomNumber;
    
}
-(double)randomY
{
    unsigned int randomNumber = 20 + arc4random()%120;
    return (double)randomNumber;
    
}
-(double)randomSize
{
    unsigned int randomNumber = 10 + arc4random()%30;
    return (double)randomNumber;
    
}
-(int)randomSpeed
{
    unsigned int randomNumber = 20 + arc4random()%100;
    return randomNumber;
}
-(double)randomDuration
{
    double randomNumber = 4.75 + arc4random()%10;
    return randomNumber;
}
-(double)randomFirstDelay
{
    double randomNumber = arc4random()%6;
    return randomNumber;
}
-(double)randomDurationFirst
{
    double randomNumber = 0.5 + arc4random()%4;
    return randomNumber;
}

-(double)randomBottomWithFirstEndY:(int)firstEnd andEndDistance:(int)distance
{
    unsigned int randomNumber = firstEnd + arc4random()%distance;
    return (double)randomNumber;
    
}
-(UIImage *)randomImage
{
    unsigned int randomNumber = 0 + arc4random()%9;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"note%d",randomNumber]];
    return image;
}
@end
