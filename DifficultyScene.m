//
//  DifficultyScene.m
//  UnPhysical
//
//  Created by Shariq Mobin on 1/12/10.
//  Copyright 2010 UC Berkelely. All rights reserved.
//

#import "DifficultyScene.h"
#import "GameScene.h" 
#import "chipmunk.h"
#import "EndGameScene.h"
#import "HelpScene.h"
#import "AboutScene.h"
#import "Constants.h"

#include "math.h"



@implementation DifficultyScene
- (id) init {
    self = [super init];
    if (self != nil) {
        Sprite * bg = [Sprite spriteWithFile:@"Black.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
        [self addChild:[DifficultyLayer node] z:1];		
    }
    return self;
}
@end

@implementation DifficultyLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [MenuItemFont setFontSize:40];
        [MenuItemFont setFontName:@"Helvetica"];
		
		
        MenuItem *norm = [MenuItemFont itemFromString:@"Normal"
												target:self
											  selector:@selector(normalGame:)];
		MenuItem *hard = [MenuItemFont itemFromString:@"Hard"
												target:self
											  selector:@selector(hardGame:)];
        Menu *menu = [Menu menuWithItems:norm, hard, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

-(void)normalGame: (id)sender {
	XS_HEIGHT += normHelp;
	S_HEIGHT += normHelp;
	GameScene * gs = [GameScene node];
    [[Director sharedDirector] replaceScene:gs];
}

-(void)hardGame: (id)sender {
	LIVES -= 5;
	GameScene * gs = [GameScene node];
    [[Director sharedDirector] replaceScene:gs];
}


@end
