//
//  UserSprite.m
//  Fate
//
//  Created by Shariq Mobin on 6/25/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "UserSprite.h"
#include "Constants.h"

@implementation UserSprite

@synthesize runRightAnimation;
@synthesize runLeftAnimation;
@synthesize fireAnimation;
@synthesize stillAnimation;

@synthesize runRightAnimationFull;
@synthesize runLeftAnimationFull;
@synthesize fireAnimationFull;
@synthesize stillAnimationFull;

@synthesize runRightAnimationLosing;
@synthesize runLeftAnimationLosing;
@synthesize fireAnimationLosing;
@synthesize stillAnimationLosing;

Shield shield;
- (void) dealloc
{
	[runLeftAnimation release];
	[runRightAnimation release];
	[fireAnimation release];
	[stillAnimation release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	shield = NONE;
	if (self)
	{
		dir = 2;
		//init the counter that will be incremented to tell what frame of the animation we are on
		frameCount = 0;
		
		[self initWithFile:@"backFate.png"];
		
		self.runLeftAnimation = [[Animation alloc] initWithName:@"runLeftAnimation" delay:0];
		self.runRightAnimation = [[Animation alloc] initWithName:@"runRightAnimation" delay:0];
		self.fireAnimation = [[Animation alloc] initWithName:@"fireAnimation" delay:0];
		self.stillAnimation = [[Animation alloc] initWithName:@"stillAnimation" delay:0];
		
		self.runLeftAnimationLosing = [[Animation alloc] initWithName:@"runLeftAnimationLosing" delay:0];
		self.runRightAnimationLosing = [[Animation alloc] initWithName:@"runRightAnimationLosing" delay:0];
		self.fireAnimationLosing = [[Animation alloc] initWithName:@"fireAnimationLosing" delay:0];
		self.stillAnimationLosing = [[Animation alloc] initWithName:@"stillAnimationLosing" delay:0];
		
		self.runLeftAnimationFull = [[Animation alloc] initWithName:@"runLeftAnimationFull" delay:0];
		self.runRightAnimationFull = [[Animation alloc] initWithName:@"runRightAnimationFull" delay:0];
		self.fireAnimationFull = [[Animation alloc] initWithName:@"fireAnimationFull" delay:0];
		self.stillAnimationFull = [[Animation alloc] initWithName:@"stillAnimationFull" delay:0];
		
		//Add each frame to the animation
		[runRightAnimation addFrameWithFilename:@"fateR1.png"];
		[runRightAnimation addFrameWithFilename:@"fateR2.png"];
		[runRightAnimation addFrameWithFilename:@"fateR3.png"];
		[runRightAnimation addFrameWithFilename:@"fateR4.png"];
		[runRightAnimation addFrameWithFilename:@"fateR5.png"];
		
		[runRightAnimationFull addFrameWithFilename:@"fateR1Shield.png"];
		[runRightAnimationFull addFrameWithFilename:@"fateR2Shield.png"];
		[runRightAnimationFull addFrameWithFilename:@"fateR3Shield.png"];
		[runRightAnimationFull addFrameWithFilename:@"fateR4Shield.png"];
		[runRightAnimationFull addFrameWithFilename:@"fateR5Shield.png"];
		
		[runRightAnimationLosing addFrameWithFilename:@"fateR1Shield.png"];
		[runRightAnimationLosing addFrameWithFilename:@"fateR2.png"];
		[runRightAnimationLosing addFrameWithFilename:@"fateR3Shield.png"];
		[runRightAnimationLosing addFrameWithFilename:@"fateR4.png"];
		[runRightAnimationLosing addFrameWithFilename:@"fateR5Shield.png"];
/*---------------------------------------------------------------------*/
		
		[runLeftAnimation addFrameWithFilename:@"fateL1.png"];
		[runLeftAnimation addFrameWithFilename:@"fateL2.png"];
		[runLeftAnimation addFrameWithFilename:@"fateL3.png"];
		[runLeftAnimation addFrameWithFilename:@"fateL4.png"];
		[runLeftAnimation addFrameWithFilename:@"fateL5.png"];
		
		[runLeftAnimationFull addFrameWithFilename:@"fateL1Shield.png"];
		[runLeftAnimationFull addFrameWithFilename:@"fateL2Shield.png"];
		[runLeftAnimationFull addFrameWithFilename:@"fateL3Shield.png"];
		[runLeftAnimationFull addFrameWithFilename:@"fateL4Shield.png"];
		[runLeftAnimationFull addFrameWithFilename:@"fateL5Shield.png"];
		
		[runLeftAnimationLosing addFrameWithFilename:@"fateL1.png"];
		[runLeftAnimationLosing addFrameWithFilename:@"fateL2Shield.png"];
		[runLeftAnimationLosing addFrameWithFilename:@"fateL3.png"];
		[runLeftAnimationLosing addFrameWithFilename:@"fateL4Shield.png"];
		[runLeftAnimationLosing addFrameWithFilename:@"fateL5.png"];
/*---------------------------------------------------------------------*/
		
		
		[fireAnimation addFrameWithFilename:@"fire.png"];
		[fireAnimationFull addFrameWithFilename:@"fireShield.png"];
		[fireAnimationLosing addFrameWithFilename:@"fire.png"];
		[fireAnimationLosing addFrameWithFilename:@"fireShield.png"];
		
		[stillAnimation addFrameWithFilename:@"backFate.png"];
		[stillAnimationFull addFrameWithFilename:@"backCloudShield.png"];
		[stillAnimationLosing addFrameWithFilename:@"backFate.png"];
		[stillAnimationLosing addFrameWithFilename:@"backCloudShield.png"];

		
		//Add the animation to the sprite so it can access it's frames
		[self addAnimation:runRightAnimation];
		[self addAnimation:runLeftAnimation];
		[self addAnimation:fireAnimation];
		[self addAnimation:stillAnimation];
		
		[self addAnimation:runRightAnimationFull];
		[self addAnimation:runLeftAnimationFull];
		[self addAnimation:fireAnimationFull];
		[self addAnimation:stillAnimationFull];
		
		[self addAnimation:runRightAnimationLosing];
		[self addAnimation:runLeftAnimationLosing];
		[self addAnimation:fireAnimationLosing];
		[self addAnimation:stillAnimationLosing];
		
		//Set the anchor point of this sprite to the lower left. Makes positioning easier
		[self setTransformAnchor:CGPointMake(0.0, 0.0)];
		
		//Create a tick method to be called at the specified interval
		[self schedule: @selector(tick:) interval:0.1];
	}
	
	return self;
}

-(void) tick: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 4) frameCount = 0;
	//Set the display frame to the frame in the walk animation at the frameCount index
	if (shield == NONE) {
		if (dir == 0)
			[self setDisplayFrame:@"runRightAnimation" index:frameCount];
		else if (dir == 1)
			[self setDisplayFrame:@"runLeftAnimation" index:frameCount];
		else if (dir == 2)
			[self setDisplayFrame:@"fireAnimation" index:0];
		else if (dir == 3)
			[self setDisplayFrame:@"stillAnimation" index:0];
	}
	else if (shield == FULL) {
		if (dir == 0)
			[self setDisplayFrame:@"runRightAnimationFull" index:frameCount];
		else if (dir == 1)
			[self setDisplayFrame:@"runLeftAnimationFull" index:frameCount];
		else if (dir == 2)
			[self setDisplayFrame:@"fireAnimationFull" index:0];
		else if (dir == 3)
			[self setDisplayFrame:@"stillAnimationFull" index:0];
	}
	else if (shield == LOSING) {
		if (dir == 0)
			[self setDisplayFrame:@"runRightAnimationLosing" index:frameCount];
		else if (dir == 1)
			[self setDisplayFrame:@"runLeftAnimationLosing" index:frameCount];
		else if (dir == 2)
			[self setDisplayFrame:@"fireAnimationLosing" index:(frameCount%2)];
		else if (dir == 3)
			[self setDisplayFrame:@"stillAnimationLosing" index:(frameCount%2)];
	}
	//Increment the frameCount for the next time this method is called
	frameCount++;
}

@end
