//
//  FateAppDelegate.m
//  Fate
//
//  Created by Shariq Mobin on 5/25/09.
//

#import "UnPhysicalAppDelegate.h"
#import "GameLayer.h"
#import "GameSCene.h"
#import "MenuScene.h"
#import "Constants.h"
@implementation UnPhysicalAppDelegate

UIAccelerometer *uam;

- (void)applicationDidFinishLaunching:(UIApplication *)app {    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
    [[Director sharedDirector] setLandscape: YES];
    [[Director sharedDirector] attachInWindow:window];
	[[Director sharedDirector] setDisplayFPS:NO];
	
    [window makeKeyAndVisible];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / accelUpdateInt)];
	MenuScene *ms = [MenuScene node];
	[[Director sharedDirector] runWithScene:ms];
	
	
}

@end

