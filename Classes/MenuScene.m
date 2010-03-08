//
//  MenuScene.m
//  SimpleGame
//
//  Created by Shariq Mobin on 5/24/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h" 
#import "chipmunk.h"
#import "EndGameScene.h"
#import "HelpScene.h"
#import "AboutScene.h"
#import "Constants.h"
#import "DifficultyScene.h"
#import "LevelSelectScene.h"

#include "math.h"


NSString *startLevel;

@implementation MenuScene
- (id) init {
    self = [super init];
	startLevel = @"level1";
    if (self != nil) {
        Sprite * bg = [Sprite spriteWithFile:@"Start.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
        [self addChild:[MenuLayer node] z:1];		
    }
    return self;
}
@end

@implementation MenuLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [MenuItemFont setFontSize:30];
        [MenuItemFont setFontName:@"Helvetica"];
		
		
        MenuItem *start = [MenuItemFont itemFromString:@"Start Game"
												target:self
											  selector:@selector(startGame:)];
		MenuItem *levelSelect = [MenuItemFont itemFromString:@"Select Level"
												target:self
											  selector:@selector(selectLevel:)];
		MenuItem *about = [MenuItemFont itemFromString:@"About"
											   target:self
											 selector:@selector(about:)];
        MenuItem *help = [MenuItemFont itemFromString:@"Controls"
											   target:self
											 selector:@selector(help:)];
        Menu *menu = [Menu menuWithItems:start, levelSelect, about, help, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

-(void)startGame: (id)sender {
//	GameScene * gs = [GameScene node];
//  [[Director sharedDirector] replaceScene:gs]; 
	DifficultyScene * ds = [DifficultyScene node];
	[[Director sharedDirector] replaceScene:ds];
}

-(void)selectLevel: (id) sender {
	LevelSelectScene * ds = [LevelSelectScene node];
	[[Director sharedDirector] replaceScene:ds];
}

-(void)help: (id)sender {
	HelpScene * hs = [HelpScene node];
    [[Director sharedDirector] replaceScene:hs]; 
}

-(void)about: (id)sender {
	AboutScene * as = [AboutScene node];
    [[Director sharedDirector] replaceScene:as]; 
}

@end
