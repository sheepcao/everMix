//
//  UIButton+customNav.m
//  Mixing Guess
//
//  Created by Eric Cao on 3/2/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "UIButton+customNav.h"
#import "globalVar.h"

@implementation UINavigationBar (customNav)
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize;
    if (IS_IPAD) {
        newSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,60);

    }else
    {
        newSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,44);
        
    }

    
    return newSize;
}
@end
