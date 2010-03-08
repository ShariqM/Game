//
//  GameLayer.h
//  Fate
//
//  Created by Shariq Mobin on 5/25/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XMLLevelLoader.h"

@interface GameLayer : Layer { 
	XMLLevelLoader *levelLoader;
	NSString *nextLevel;
	NSString *currLevel;
	NSURL *currentLevelURL;
}

@property (nonatomic, retain) NSString *nextLevel;
@property (nonatomic, retain) NSString *currLevel;
@property (nonatomic, retain) NSURL* currentLevelURL;

-(void) gotoNextLevel;
-(void) step: (ccTime) dt;
-(void) loadLevelAtURL:(NSURL*) url;
@end
