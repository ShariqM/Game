//
//  XMLLevelLoader.h
//  Fate
//
//  Created by Shariq Mobin on 6/4/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class GameLayer;

@interface XMLLevelLoader : NSObject {
	GameLayer * game;
}
- (void) parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error ;
- (void) setGame: (GameLayer *)game;
@end
