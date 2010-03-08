//
//  ExplosionSprite.h
//  UnPhysical
//
//  Created by Shariq Mobin on 10/21/09.
//  Copyright 2009 UC Berkelely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "chipmunk.h"


@interface ExplosionSprite : Sprite {
	Animation *animate;
	int frameCount;
}

@property (nonatomic, retain) Animation *animate;
@end
