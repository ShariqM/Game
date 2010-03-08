//
//  GameLayer.m
//  Fate
//
//  Created by Shariq Mobin on 5/25/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "GameLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "Constants.h"
#import "GameScene.h"
#import "EndGameScene.h"
#import "WinGameScene.h"
#import "UserSprite.h"
#include "math.h"


extern void drawObject(void *ptr, void *unused);
extern void makeStaticBox(float x, float y, float width, float height);
extern void createPlayer();
extern int hit(cpArbiter *arb, cpSpace *space, void *unused);
extern int killUser(cpArbiter *arb, cpSpace *space, void *unused);
extern int getItem(cpArbiter *arb, cpSpace *space, void *unused);
extern int hitWall(cpArbiter *arb, cpSpace *space, void *unused);
extern void splitBall(cpShape *a);
extern void killShape(cpShape *a);
extern void Laser();
extern void makeUser();
extern void makeBall(float x, float y, float vx, float vy, float r);
extern int getHits(float radius);
extern void initSound();
int getPoints(cpCircleShape *a);
void resume();
void pauseGame();
int xxx(cpArbiter *arb, cpSpace *space, void *unused);
int itemWall(cpArbiter *arb, cpSpace *space, void *unused);

int getSize(float radius);
void winGame();

extern UIWindow *window;
extern GameScene *scene;
extern cpShape *laserShape;
extern cpShape *laserShape2;
extern cpShape *deadShape;
extern cpShape *userShape;
extern cpShape *headShape;
extern int livesleft;
extern BOOL fireTwice;
extern BOOL levelOver;
extern enum Shield shield;
GameLayer *gameLayer;
cpSpace *space;
cpBody *staticBody;
Sprite *getReady;
UIAccelerationValue accelX, accelY, accelZ;
UILabel *scoreLabel;
UILabel *levelLabel;
UILabel *pauseLabel;
UILabel *livesLabel;
int timeLaunch;
int HitsToWin;
BOOL firstRun;
BOOL isPaused;
long pauseTime;
long explosionTime;
int score;
int level;
int pauseDelay;
int fireDelay;
Sprite *explosion;
extern NSString * startLevel;


@implementation GameLayer
@synthesize nextLevel;
@synthesize currLevel;
@synthesize currentLevelURL;

-(id) init {
	if (self != nil) {
		[super init];
		gameLayer = self;
		HitsToWin = 0;
		timeLaunch = 1;
		firstRun = true;
		fireTwice = false;
		isTouchEnabled = YES;
		isAccelerometerEnabled = YES;
		accelX = accelY = accelZ = 0;
		pauseDelay = readyDelay;
		fireDelay = 0;
		shield = NONE;
		explosion = [Sprite spriteWithFile:@"explosion.png"];
		cpInitChipmunk();
		initSound();
		
		// XML Load
		NSBundle*	bundle = [NSBundle mainBundle];
		[self loadLevelAtURL:[NSURL fileURLWithPath: [bundle pathForResource:startLevel ofType:@"xml"]]];
		[self schedule: @selector(step:)];
		levelOver = FALSE;
		
	}
	return self;		
}


-(void) dealloc {
	[super dealloc];
}

- (void)changeDirection:(NSTimer *)theTimer {
	dir = [[[theTimer userInfo] objectForKey:@"1"] intValue];
}	
- (void)pollLevelOver:(NSTimer *)theTimer {
	if(levelOver && !isPaused) {
		[self gotoNextLevel];
	}else {
		[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pollLevelOver:) userInfo:nil repeats:NO];
		levelOver = TRUE;
	}
}
-(void) explosionDone:(NSTimer *)theTimer {	
	Sprite *exp = [theTimer userInfo];
	[gameLayer removeChild:exp cleanup:TRUE];
}
- (void)loseInvinc:(NSTimer *)theTimer {
	shield = DEAD;
}	
-(void) step: (ccTime) delta {	
	scoreLabel.text = [NSString stringWithFormat:@"%d", score];

	int steps = 2;
	cpFloat dt = delta/(cpFloat)steps;
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
		if (deadShape != NULL) {
			if (userShape == deadShape || headShape == deadShape) { // You died
				[gameLayer loadLevelAtURL:currentLevelURL];
				i = steps;
			}
		}
		
	}
} 

-(void) changeDir:(int) intent {
	if (dir == 2) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[[NSNumber numberWithInt:intent] stringValue] forKey:@"1"];
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeDirection:) userInfo:dict repeats:NO];
		[dict release];
	}
	else
		dir = intent;
}

-(void) loadLevelAtURL:(NSURL*) url {
	HitsToWin = 0;
	levelOver = FALSE;
	shield = NONE;
	scoreLabel.text = [NSString stringWithFormat:@"%d", score];
	livesLabel.text = [NSString stringWithFormat:@"Lives:%d", livesleft];
	//create a new world.
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableString *img;
	[self setCurrentLevelURL:url];
	if(!firstRun){
		// kill old chipmunk objects
		[self removeAllChildrenWithCleanup:TRUE];
		cpSpaceFreeChildren(space);
		cpSpaceFree(space);
		cpBodyFree(staticBody);
		laserShape = NULL;
		shield = NONE;
		laserShape2 = NULL;
		fireTwice = FALSE;
	}
	
	Sprite * hd = [Sprite spriteWithFile:@"HUD.png"];
	[hd setPosition:ccp(240,160)];
	[self addChild:hd z:2];
	
	firstRun = false;
	fireTwice= false;
	
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 60.0, 300);
	cpSpaceResizeActiveHash(space, 60.0, 300);
	space->gravity = cpv(0,0); // let balls control their own gravitational force  
	
	staticBody = cpBodyNew(INFINITY, INFINITY);  // Infinte Mass and Inertia it shouldnt move whatsoever
	
	levelLoader = [[XMLLevelLoader alloc] init];
	[levelLoader retain];
	[levelLoader setGame:self];
	NSError *parseError = nil;
	[levelLoader parseXMLFileAtURL:url parseError:&parseError];
	
	[levelLoader release];        
	[pool release];
	
    cpSpaceAddCollisionHandler(space, BALL_CT, LASER_CT, hit, nil, nil, nil, nil);
	
	cpSpaceAddCollisionHandler(space, BALL_CT, USER_CT, killUser, nil, nil, nil, nil);
	cpSpaceAddCollisionHandler(space, BALL_CT, WALL_CT, hitWall, nil, nil, nil, nil);
	cpSpaceAddCollisionHandler(space, ITEM_CT, USER_CT, getItem, nil, nil, nil, nil);
	cpSpaceAddCollisionHandler(space, ITEM_CT, WALL_CT, itemWall, nil, nil, nil, nil);
	
	
	CGSize s = [[Director sharedDirector] winSize];
	
	int dmargin = margin*2;
	makeStaticBox(margin, HUD_SIZE, s.width - dmargin, s.height - HUD_SIZE - margin);
	
	Sprite * bg = [Sprite spriteWithFile:@"level1.png"];
	[bg setPosition:ccp(240, 160)];
	[self addChild:bg z:0];
	
	// Allow user to prepare for the level
	pauseGame();
	[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pollLevelOver:) userInfo:nil repeats:NO];
}

int itemWall(cpArbiter *arb, cpSpace *space, void *unused)
{
	cpShape *a, *b; cpArbiterGetShapes(arb, &a, &b);
	if ([(NSString *)b->data isEqualToString: @"bottom"]){
		a->body->v = cpv(0,0);
		a->body->f = cpv(0,0);
	}
	return 0;
}
void pauseGame() {
	getReady = [Sprite spriteWithFile:@"ready.png"];
	[getReady setPosition:CGPointMake(240,160)];
	[gameLayer addChild:getReady z:3];
	
	isPaused = TRUE;
	[[Director sharedDirector] pause];
}
void resume() {
	isPaused = FALSE;
	[[Director sharedDirector] resume];
	[gameLayer removeChild:getReady cleanup:TRUE];
}

- (void) draw {  // update sprite positions
	cpSpaceHashEach(space->activeShapes, &drawObject, NULL);
	cpSpaceHashEach(space->staticShapes, &drawObject, NULL);  
}
 

void winGame() {
	WinGameScene * wgs = [WinGameScene node];
	[scene removeAllChildrenWithCleanup:FALSE];
	[[Director sharedDirector] replaceScene:wgs]; 
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{  
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	
	if (isPaused)
		resume();
	else if (location.x > 400 && location.y < HUD_SIZE) // if the user hit the pause button
		pauseGame();
	else if (laserShape == NULL) { // only allow 1 laser to exist at any time
		Laser(1);
		dir = 2;
	}
	else if (fireTwice && laserShape2 == NULL) {
		Laser(2);
		dir = 2;
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration { 	
	if (isPaused || userShape == NULL)
		return;
	cpVect pos = userShape->body->p;

	if (acceleration.y > MIN_ACCEL_Y && pos.x > margin+USER_WIDTH/2) {
		userShape->body->p =  cpv(pos.x-PLAYER_SPEED, pos.y);
		[self changeDir: 1];
	}
	else if (acceleration.y <  -MIN_ACCEL_Y && pos.x < 480-margin-USER_WIDTH/2) {
		userShape->body->p = cpv(pos.x+PLAYER_SPEED, pos.y);
		[self changeDir: 0];
	}
	else
		[self changeDir: 3];
	headShape->body->p = cpv(userShape->body->p.x, headShape->body->p.y); // make the head follows the body
} 
-(void) gotoNextLevel{
	levelOver = FALSE;
	if (nextLevel == nil)
		return;

	levelLabel.text = [nextLevel substringFromIndex:5];
	if ([nextLevel isEqualToString:  @"endGame"]) {
		winGame();
	}
	else {
		NSBundle*	bundle = [NSBundle mainBundle];
		[self loadLevelAtURL:[NSURL fileURLWithPath: [bundle pathForResource:nextLevel ofType:@"xml"]]];
	}
}

@end
