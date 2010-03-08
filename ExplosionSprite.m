//
//  ExplosionSprite.m
//  UnPhysical
//
//  Created by Shariq Mobin on 10/21/09.
//  Copyright 2009 UC Berkelely. All rights reserved.
//

#import "ExplosionSprite.h"


@implementation ExplosionSprite

@synthesize animate;

-(id) init
{
	self = [super init];
	
	if (self)
	{
		//init the counter that will be incremented to tell what frame of the animation we are on
		frameCount = 0;
		
		//For some reason if you don't start the sprite with an image you can't display the frames of an animation.
		//So we start it out with the first frame of our animation
		[self initWithFile:@"exp1.png"];
		
		//create an Animation object to hold the frame for the walk cycle
		self.animate = [[Animation alloc] initWithName:@"animate" delay:0];

		
		//Add each frame to the animation
		[animate addFrameWithFilename:@"exp1.png"];
		[animate addFrameWithFilename:@"exp2.png"];
		[animate addFrameWithFilename:@"exp3.png"];

		
		
		//Add the animation to the sprite so it can access it's frames
		[self addAnimation:animate];
		
		//Set the anchor point of this sprite to the lower left. Makes positioning easier
		[self setTransformAnchor:CGPointMake(0.0, 0.0)];
		
		//Create a tick method to be called at the specified interval
		[self schedule: @selector(tick:) interval:0.05];
	}
	
	return self;
}

-(void) tick: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 2) frameCount = 0;
	//Set the display frame to the frame in the walk animation at the frameCount index

	[self setDisplayFrame:@"animate" index:frameCount];
	//Increment the frameCount for the next time this method is called
	frameCount++;
}

@end
