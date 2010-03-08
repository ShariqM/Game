//
//  LevelSelectScene.m
//  UnPhysical
//
//  Created by Shariq Mobin on 1/22/10.
//  Copyright 2010 UC Berkelely. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h" 
#import "chipmunk.h"
#import "EndGameScene.h"
#import "HelpScene.h"
#import "AboutScene.h"
#import "Constants.h"
#import "LevelSelectScene.h"
#import "DifficultyScene.h"

#include "math.h"

extern NSString * startLevel;
extern UILabel *levelLabel;

@implementation LevelSelectScene
- (id) init {
    self = [super init];
    if (self != nil) {
        Sprite * bg = [Sprite spriteWithFile:@"Black.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
        [self addChild:[LevelSelectLayer node] z:1];		
    }
    return self;
}
@end

@implementation LevelSelectLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [MenuItemFont setFontSize:30];
        [MenuItemFont setFontName:@"Helvetica"];
		
		MenuItem *one = [MenuItemFont itemFromString:@"01  " target:self selector:@selector(one:)];
		MenuItem *two = [MenuItemFont itemFromString:@"02  " target:self selector:@selector(two:)];
		MenuItem *three = [MenuItemFont itemFromString:@"03  " target:self selector:@selector(three:)];
/*		MenuItem *four = [MenuItemFont itemFromString:@"04  " target:self selector:@selector(four:)];
		MenuItem *five = [MenuItemFont itemFromString:@"05  " target:self selector:@selector(five:)];
		MenuItem *six = [MenuItemFont itemFromString:@"06  " target:self selector:@selector(six:)];
		MenuItem *seven = [MenuItemFont itemFromString:@"07  " target:self selector:@selector(seven:)];
		MenuItem *eight = [MenuItemFont itemFromString:@"08  " target:self selector:@selector(eight:)];
		MenuItem *nine = [MenuItemFont itemFromString:@"09  " target:self selector:@selector(nine:)];
		MenuItem *ten = [MenuItemFont itemFromString:@"10  " target:self selector:@selector(ten:)];
		MenuItem *eleven = [MenuItemFont itemFromString:@"11  " target:self selector:@selector(eleven:)];
		MenuItem *twelve = [MenuItemFont itemFromString:@"12  " target:self selector:@selector(twelve:)];
		*/
        Menu *menu = [Menu menuWithItems:one, two, three, nil];// four, five, six, seven, eight, nine, ten, eleven, twelve, nil];
		[menu alignItemsInRows:
		 [NSNumber numberWithUnsignedInt:3], // was 4
	//	 [NSNumber numberWithUnsignedInt:4],
	//	 [NSNumber numberWithUnsignedInt:4],
		 nil
		 ];
		
        [self addChild:menu];
    }
    return self;
}

void nextScene() {
//	levelLabel.text = [startLevel substringFromIndex:5];
	DifficultyScene * ds = [DifficultyScene node];
	[[Director sharedDirector] replaceScene:ds];
}

-(void)one: (id)sender{
	startLevel = @"level1";
	nextScene();
}
-(void)two: (id)sender{
	startLevel = @"level2";
	nextScene();
}
-(void)three: (id)sender {
	startLevel = @"level3";
	nextScene();
}
-(void)four: (id)sender {
	startLevel = @"level4";
	nextScene();
}
-(void)five: (id)sender {
	startLevel = @"level5";
	nextScene();
}
-(void)six: (id)sender {
	startLevel = @"level6";
	nextScene();
}
-(void)seven: (id)sender {
	startLevel = @"level7";
	nextScene();
}
-(void)eight: (id)sender {
	startLevel = @"level8";
	nextScene();
}
-(void)nine: (id)sender {
	startLevel = @"level9";
	nextScene();
}
-(void)ten: (id)sender {
	startLevel = @"level10";
	nextScene();
}
-(void)eleven: (id)sender {
	startLevel = @"level11";
	nextScene();
}
-(void)twelve: (id)sender {
	startLevel = @"level12";
	nextScene();
}





@end