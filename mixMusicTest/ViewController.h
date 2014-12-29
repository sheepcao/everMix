//
//  ViewController.h
//  mixMusicTest
//
//  Created by Eric Cao on 12/9/14.
//  Copyright (c) 2014 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameViewController.h"

@interface ViewController : UIViewController<prepareSongsDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;

- (IBAction)starTapped:(UIButton *)sender;

- (IBAction)beginTapped:(UIButton *)sender;
@property (strong,nonatomic) NSMutableDictionary *gameData;
//@property (strong,nonatomic) NSMutableArray *musicToNextView;
@end
