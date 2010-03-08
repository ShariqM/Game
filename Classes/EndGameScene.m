//
//  EndGameScene.m
//  Fate
//
//  Created by Shariq Mobin on 5/31/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "EndGameScene.h"
#import "GameScene.h"
#import "Gamelayer.h"
#import "MenuScene.h"

extern GameScene *scene;
extern GameLayer *game;
extern UIWindow *window;
extern UILabel *scoreLabel;
extern UILabel *levelLabel;
extern UILabel *livesLabel;
extern UILabel *pauseLabel;
extern NSString *currLevel;

@implementation EndGameScene
- (id) init {
    self = [super init];
    if (self != nil) {
		//currLevel = @"level1";
		
		[scoreLabel removeFromSuperview];
		[levelLabel removeFromSuperview];
		[pauseLabel removeFromSuperview];
		[livesLabel removeFromSuperview];
		
	    Sprite * bg = [Sprite spriteWithFile:@"Lose.png"];
        [bg setPosition:ccp(240, 160)];
		[self addChild:bg z:0];
        [self addChild:[EndGameLayer node] z:1];
    }
    return self;
}
@end

@implementation EndGameLayer
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

