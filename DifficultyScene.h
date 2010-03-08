//
//  DifficultyScene.h
//  UnPhysical
//
//  Created by Shariq Mobin on 1/12/10.
//  Copyright 2010 UC Berkelely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface DifficultyScene : Scene {}
@end

@interface DifficultyLayer : Layer {}
-(void)normalGame: (id)sender;
-(void)hardGame: (id)sender;
@end
