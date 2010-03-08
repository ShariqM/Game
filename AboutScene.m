//
//  AboutScene.m
//  Fate
//
//  Created by Shariq Mobin on 7/13/09.
//  Copyright 2009 UC Berkelely. All rights reserved.
//

#import "AboutScene.h"
#import "MenuScene.h"

@implementation AboutScene
- (id) init {
    self = [super init];
    if (self != nil) {
	    Sprite * bg = [Sprite spriteWithFile:@"About.png"];
        [bg setPosition:ccp(240, 160)];
		[self addChild:bg z:0];
        [self addChild:[AboutLayer node] z:1];
    }
    return self;
}
@end

@implementation AboutLayer
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
