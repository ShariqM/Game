//
//  EndGameScene.h
//  Fate
//
//  Created by Shariq Mobin on 5/31/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#import "WinGameScene.h"
#import "cocos2d.h"
#import "GameScene.h"
#import "Gamelayer.h"
#import "MenuScene.h"

extern GameScene *scene;
extern UILabel *scoreLabel;
extern UILabel *levelLabel;
extern UILabel *livesLabel;
extern UILabel *pauseLabel;
extern NSString *currLevel;

@implementation WinGameScene
- (id) init {
    self = [super init];
    if (self != nil) {
		
		//currLevel = @"level1";
		
		[scoreLabel removeFromSuperview];
		[levelLabel removeFromSuperview];
		[pauseLabel removeFromSuperview];
		[livesLabel removeFromSuperview];
	    Sprite * bg = [Sprite spriteWithFile:@"WinGame.png"];
        [bg setPosition:ccp(240, 160)];
		[self addChild:bg z:0];
        [self addChild:[WinGameLayer node] z:1];
    }
    return self;
}
@end

@implementation WinGameLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        isTouchEnabled = YES;
    }
    return self;
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[Director sharedDirector] replaceScene:[MenuScene node]];
}
@end