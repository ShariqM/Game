//
//  MenuScene.h
//  SimpleGame
//
//  Created by Shariq Mobin on 5/24/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface MenuScene : Scene {}
@end

@interface MenuLayer : Layer {}
-(void)startGame: (id)sender;
-(void)help: (id)sender;
@end
