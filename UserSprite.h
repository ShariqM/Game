//
//  UserSprite.h
//  Fate
//
//  Created by Shariq Mobin on 6/25/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface UserSprite : Sprite {
	Animation *runLeftAnimation;
	Animation *runRightAnimation;
	Animation *fireAnimation;
	Animation *stillAnimation;
	
	Animation *runLeftAnimationFull;
	Animation *runRightAnimationFull;
	Animation *fireAnimationFull;
	Animation *stillAnimationFull;
	
	Animation *runLeftAnimationLosing;
	Animation *runRightAnimationLosing;
	Animation *fireAnimationLosing;
	Animation *stillAnimationLosing;
	
	int frameCount;
}
int dir;

@property (nonatomic, retain) Animation *runLeftAnimation;
@property (nonatomic, retain) Animation *runRightAnimation;
@property (nonatomic, retain) Animation *fireAnimation;
@property (nonatomic, retain) Animation *stillAnimation;

@property (nonatomic, retain) Animation *runLeftAnimationFull;
@property (nonatomic, retain) Animation *runRightAnimationFull;
@property (nonatomic, retain) Animation *fireAnimationFull;
@property (nonatomic, retain) Animation *stillAnimationFull;

@property (nonatomic, retain) Animation *runLeftAnimationLosing;
@property (nonatomic, retain) Animation *runRightAnimationLosing;
@property (nonatomic, retain) Animation *fireAnimationLosing;
@property (nonatomic, retain) Animation *stillAnimationLosing;


@end
