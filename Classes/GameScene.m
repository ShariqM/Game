//
//  GameScene.m
//  Fate
//
//  Created by Shariq Mobin on 5/31/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"


#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Constants.h"

@implementation GameScene


int livesleft;
int score;
extern UILabel *scoreLabel;
extern UILabel *levelLabel;
extern UILabel *livesLabel;
extern UILabel *pauseLabel;
extern UIWindow *window;
extern NSString *startLevel;
GameScene *scene;

- (id) init {
    self = [super init];
	scene = self;
    if (self != nil) {
		GameLayer *g = [GameLayer node];
		
		UIFont *font = [UIFont fontWithName:@"Verdana" size:14.0];
		// Create Score
		score = 0;
		CGRect cellRectangle = CGRectMake(-33,480-margin-160,80,12);
		scoreLabel = [[UILabel alloc] initWithFrame:cellRectangle];
		scoreLabel.textColor = [UIColor whiteColor];
		scoreLabel.font = font;
		scoreLabel.backgroundColor = [UIColor clearColor];
		[scoreLabel setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		[window addSubview:scoreLabel ];
		
		// Create Level #
		cellRectangle = CGRectMake(-3,240,20,12);
		levelLabel = [[UILabel alloc] initWithFrame:cellRectangle];
		levelLabel.textColor = [UIColor cyanColor];
		levelLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
		levelLabel.backgroundColor = [UIColor clearColor];
		[levelLabel setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		[window addSubview:levelLabel ];
		levelLabel.text = [startLevel substringFromIndex:5];
		
		// Create LivesLeft
		livesleft = LIVES;
		cellRectangle = CGRectMake(-23,26,60,12);
		livesLabel = [[UILabel alloc] initWithFrame:cellRectangle];
		livesLabel.textColor = [UIColor whiteColor];
		livesLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
		livesLabel.backgroundColor = [UIColor clearColor];
		[livesLabel setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		[window addSubview:livesLabel ];
		livesLabel.text = [NSString stringWithFormat:@"Lives:%d", livesleft];
		
		// Create PauseLabel
		cellRectangle = CGRectMake(-23,450,60,12);
		pauseLabel = [[UILabel alloc] initWithFrame:cellRectangle];
		pauseLabel.textColor = [UIColor whiteColor];
		pauseLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
		pauseLabel.backgroundColor = [UIColor clearColor];
		[pauseLabel setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		[window addSubview:pauseLabel];
		pauseLabel.text = @"Pause";
		
		[self addChild:g];
    }
    return self;
	 
}

@end
