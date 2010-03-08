//
//  Helpers.m
//  Fate
//
//  Created by Shariq Mobin on 5/25/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "Helpers.h"
#import "ExplosionSprite.h"
#include <math.h>

@implementation Helpers

//@synthesize popSound;

void createItem(cpVect pos);

extern int getPoints(cpCircleShape *a);

extern cpSpace* space;
extern cpBody *staticBody;
extern GameScene *scene;
extern Sprite *getReady;
extern cpShape *deadShape;
extern int livesleft;
extern GameLayer *gameLayer;
extern int HitsToWin;
extern long pauseTime;
extern long explosionTime;
extern int score;
extern Sprite *explosion;
extern UIWindow *window;
extern UILabel *scoreLabel;
extern UILabel *livesLabel;
extern bool levelOver;
cpShape *laserShape;
cpShape *laserShape2;
cpShape *userShape;
cpShape *headShape;
BOOL fireTwice;
extern Shield shield;
SystemSoundID popSound;

void initSound() {
	NSString *popPath = [[NSBundle mainBundle] pathForResource:@"popSound" ofType:@"caf"];
	CFURLRef popURL = (CFURLRef) [NSURL fileURLWithPath:popPath];
	AudioServicesCreateSystemSoundID(popURL, &popSound);
}

void makeBall(float x, float y, float vx, float vy, float r, NSString *c){
	
	Sprite *ball;
	cpBody *body;
	if (r <= XS_RADIUS){
		ball = [Sprite spriteWithFile:[c stringByAppendingString: @"_xsball.png"]];
		body = cpBodyNew(XS_BALL_MASS, INFINITY);
	}
	else if (r <= S_RADIUS) {
		ball = [Sprite spriteWithFile:[c stringByAppendingString: @"_sball.png"]];
		body = cpBodyNew(S_BALL_MASS, INFINITY);
	}
	else if (r <= M_RADIUS) {
		ball = [Sprite spriteWithFile:[c stringByAppendingString: @"_mball.png"]];
		body = cpBodyNew(M_BALL_MASS, INFINITY);
	}
	else if (r <= L_RADIUS) {
		ball = [Sprite spriteWithFile:[c stringByAppendingString: @"_lball.png"]];
		body = cpBodyNew(L_BALL_MASS, INFINITY);
	}
	else {
		ball = [Sprite spriteWithFile:[c stringByAppendingString: @"_xlball.png"]];
		body = cpBodyNew(XL_BALL_MASS, INFINITY);
	}
	
	body->p = cpv(x,y);
	body->v = cpv(vx, vy);
	
	// and a shape to represent its collision box
	cpShape* shape = cpCircleShapeNew(body, r, cpvzero);
	shape->e = ELASTICITY; shape->u = FRICTION;
	shape->group = BALL_GROUP;
	shape->collision_type = BALL_CT;
	
	if ([c isEqualToString:  @"LBLUE"]) {
		body->data = @"LBLUE";
		cpBodyApplyForce(body, cpv(0, body->m*GRAVITY), cpvzero); //-200 = gravity
	}
	else if ([c isEqualToString: @"RED"])
		body->data = @"RED";
	else if ([c isEqualToString: @"GREEN"])
		body->data = @"GREEN";
	else if ([c isEqualToString: @"ORANGE"]) {
		body->data = @"ORANGE";
		cpBodyApplyForce(body, cpv(0, body->m*GRAVITY), cpvzero); //-200 = gravity
	}
	else if ([c isEqualToString: @"PURPLE"]) {
		body->data = @"PURPLE";
		cpBodyApplyForce(body, cpv(-body->m*GRAVITY, 0), cpvzero); //-200 = gravity
	}
	else if ([c isEqualToString: @"YELLOW"])
		body->data = @"YELLOW";
	
	shape->data = ball; // store the image with the shape
	[gameLayer addChild:ball z:2];
	
	cpSpaceAddShape(space, shape);
	cpSpaceAddBody(space, body);
}


void makeStaticBox(float x, float y, float width, float height){
	cpShape * shape;
	shape = cpSegmentShapeNew(staticBody, cpv(x,y), cpv(x+width, y), 0.0f);
	shape->e = ELASTICITY; shape->u = FRICTION;
	shape->group = LASER_GROUP;
	shape->collision_type = WALL_CT;
	shape->data = @"bottom"; // bottom side for future reference
	cpSpaceAddShape(space, shape);
	
	shape = cpSegmentShapeNew(staticBody, cpv(x+width, y), cpv(x+width, y+height ), 0.0f);
	shape->e = ELASTICITY; shape->u = FRICTION;
	shape->group = USER_GROUP;
	shape->collision_type = WALL_CT;
	shape->data = @"right"; // right side for future reference
	cpSpaceAddStaticShape(space, shape);
	
	shape = cpSegmentShapeNew(staticBody, cpv(x+width, y+height), cpv(x, y+height ), 0.0f);
	shape->e = ELASTICITY; shape->u = FRICTION;
	shape->collision_type = WALL_CT;
	shape->data = @"top"; // top side for future reference
	cpSpaceAddStaticShape(space, shape);
	
	shape = cpSegmentShapeNew(staticBody, cpv(x, y+height ), cpv(x, y), 0.0f);
	shape->e = ELASTICITY; shape->u = FRICTION;
	shape->group = USER_GROUP;
	shape->collision_type = WALL_CT;
	shape->data = @"left"; // left side for future reference
	cpSpaceAddStaticShape(space, shape);
}

void Laser(int i) {
	int num = 4;
	CGSize s = [[Director sharedDirector] winSize];
	float laser_len = s.height - HUD_SIZE - USER_HEIGHT - margin;
	
	cpVect verts[] = {
		cpv(-LASER_WIDTH/2, 0),
		cpv(-LASER_WIDTH/2, laser_len),
		cpv(LASER_WIDTH/2, laser_len),
		cpv(LASER_WIDTH/2, 0),
	};	

	float velY, posY;
	cpBody *laser;
	laser = cpBodyNew(LASER_MASS, INFINITY);
	velY = sqrt(-2*GRAVITY*(s.height)); 
	posY = USER_HEIGHT - laser_len;
	laser->p = cpv(userShape->body->p.x, posY);
	laser->v = cpv(0, velY);
	cpSpaceAddBody(space, laser);
	
	cpShape *lShape = cpPolyShapeNew(laser, num, verts, cpvzero);
	lShape->e = 0.0; 
	lShape->u = 0.0;
	lShape->group = LASER_GROUP;
	lShape->collision_type = LASER_CT;
	
	lShape->data = [Sprite spriteWithFile:@"laser.png"];
	[gameLayer addChild:lShape->data z:1]; // z:1
	if (i == 1)
		laserShape = lShape;
	else {
		laserShape2 = lShape;
	}
	
	cpSpaceAddShape(space,lShape);
}

void makeUser(int x, int y) {
	int num = 4;
	float hitBoxWidth = USER_WIDTH-6;
	float hitBoxHeight = USER_BODY_HEIGHT-2;
	cpVect verts[] = {
		cpv(-hitBoxWidth/2, 0),
		cpv(-hitBoxWidth/2, hitBoxHeight),
		cpv(hitBoxWidth/2, hitBoxHeight),
		cpv(hitBoxWidth/2, 0)
	};	
	
	cpBody *userBody;
	userBody = cpBodyNew(USER_MASS, INFINITY);
	cpVect pos = cpv(x,y+HUD_SIZE);
	userBody->p = pos;
	cpSpaceAddBody(space, userBody);
	
	// Player Body
	userShape = cpPolyShapeNew(userBody, num, verts, cpvzero);
	userShape->e = 0.0; 
	userShape->u = 0.0;
	userShape->group = LASER_GROUP;
	userShape->collision_type = USER_CT;
	userShape->sensor = TRUE;
	UserSprite *userSprite = [UserSprite node];
	userShape->data = userSprite;
	
	// Player head
	cpBody *userHead = cpBodyNew(USER_MASS, INFINITY);
	cpSpaceAddBody(space, userHead);
	cpVect offset = cpv(0, USER_BODY_HEIGHT+USER_HEAD_RADIUS);
	userHead->p = cpvadd(userBody->p, offset);
	headShape = cpCircleShapeNew(userHead, USER_HEAD_RADIUS, cpvzero);
	headShape->group = USER_GROUP;
	headShape->sensor = TRUE;
	headShape->collision_type = USER_CT;
	
	[gameLayer addChild:userSprite z:2];
	
	cpSpaceAddShape(space, userShape);
	cpSpaceAddShape(space, headShape);
}
void killShape(cpShape *a) {
	if (a == laserShape)
		laserShape = NULL;
	else if (a == laserShape2)
		laserShape2 = NULL;
	if (a != NULL) {
		cpBody *body = a->body;
		[gameLayer removeChild:a->data cleanup:YES];
		cpSpaceRemoveShape(space, a);
		cpSpaceRemoveBody(space,body);
		cpShapeFree(a);
		cpBodyFree(body);  
	}
}

float getNewRadius(float r) {
	if (r == S_RADIUS)
		return XS_RADIUS;
	else if (r == M_RADIUS)
		return S_RADIUS;
	else if (r == L_RADIUS)
		return M_RADIUS;
	else if (r == XL_RADIUS)
		return L_RADIUS;
	else
		return -100;
}
int getNewVelocity(float r) {
	if (r == S_RADIUS)
		return NEWBALL_VY;
	else if (r == M_RADIUS)
		return NEWBALL_VY;
	else if (r == L_RADIUS)
		return NEWBALL_VY;
	else if (r == XL_RADIUS)
		return NEWBALL_VY;
	else
		return -1333337;
}
void splitBall(cpShape *a) {
	
	cpFloat radius = ((cpCircleShape *)a)->r;
	cpVect pos = a->body->p;
	int sign;
	float newr;
	int newVel;
	NSString * color;
	if (radius > XS_RADIUS && radius != 11) { // 11 temp for head player
		newr = getNewRadius(radius);
		newVel = getNewVelocity(radius);
		color = a->body->data;
		for (int i = 0; i < 2; i++) {
			sign = (i*-2)+1; // +1 then -1
			if ([color isEqualToString:@"LBLUE"] || [color isEqualToString:@"ORANGE"] )
				makeBall(pos.x, pos.y, BALL_VX*sign, newVel, newr, color);
			else if ([color isEqualToString:@"PURPLE"])
				makeBall(pos.x, pos.y, -(i+1)*newVel, BALL_VX, newr, color);
			else if ([color isEqualToString:@"YELLOW"]) {
				makeBall(pos.x, pos.y, -a->body->v.x, a->body->v.y, newr, color);
				makeBall(pos.x, pos.y, a->body->v.x, -a->body->v.y, newr, color);
				i = 10; // break loop
			}
			else if ([color isEqualToString:@"GREEN"]) {
				float mag = sqrt(pow(a->body->v.x, 2) + pow(a->body->v.y, 2));
				int deg = rand()%360;
				float rad = deg*2*M_PI/180;
				makeBall(pos.x, pos.y, mag*sin(rad),  mag*cos(2*M_PI-rad), newr, color);
			}
		}
	}
}

void explosionCreate () {
	explosion = [Sprite spriteWithFile:@"explosion.png"];
	[gameLayer addChild:explosion];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:gameLayer selector:@selector(explosionDone:) userInfo:nil repeats:NO];
}

void postStepRemove(cpSpace *space, cpShape *shape, void *unused)
{
	if (shape == laserShape)
		laserShape = NULL;
	else if (shape == laserShape2)
		laserShape2 = NULL;

	[gameLayer removeChild:shape->data cleanup:YES];
	cpSpaceRemoveBody(space, shape->body);
	cpBodyFree(shape->body);
	
	cpSpaceRemoveShape(space, shape);
	cpShapeFree(shape);
}

/* Laser hit ball */
int hit(cpArbiter *arb, cpSpace *space, void *unused)
{
	cpShape *a, *b; cpArbiterGetShapes(arb, &a, &b);
	score += getPoints((cpCircleShape *)a);

	AudioServicesPlaySystemSound(popSound);
	int rad = ((cpCircleShape *)a)->r;
	if (rad == XS_RADIUS) { // Different explosion for small radous
		explosion = [ExplosionSprite node];
		[explosion setPosition:CGPointMake(a->body->p.x-10, a->body->p.y-10)];
	}
	else {
		explosion = [Sprite spriteWithFile:@"explosion.png"];
		[explosion setPosition:CGPointMake(a->body->p.x, a->body->p.y)];
	}
	
	[gameLayer addChild:explosion];
	[NSTimer scheduledTimerWithTimeInterval:0.15 target:gameLayer selector:@selector(explosionDone:) userInfo:explosion repeats:NO];
	
	createItem(a->body->p);
	
	if (a->collision_type == BALL_CT) {
		splitBall(a);
		// Remove shape once gameStep is done (otherwise bugs occur)
		cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, a, NULL); 
		cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, b, NULL);
	}

	return 0;
}

void createItem(cpVect pos) {
	if (HitsToWin < 10)
		return;
	int n = 3*HitsToWin;
	int random = rand()%n;
	
	Sprite *itemSprite;
	cpBody *itemBody = cpBodyNew(ITEM_MASS, INFINITY);
	if (random == 99) {
		itemSprite = [Sprite spriteWithFile:@"lifeItem.png"];
		itemBody->data = @"ilife";
	}else if (shield == NONE && (random == 40 || random == 94)) {
		itemSprite = [Sprite spriteWithFile:@"shieldItem.png"];
		itemBody->data = @"ishield";
	}else if (random <= n/35 && !fireTwice) {
		itemSprite = [Sprite spriteWithFile:@"laserItem.png"];
		itemBody->data = @"ilasers";
	}else if (random <= n/10) {
		itemSprite = [Sprite spriteWithFile:@"coin1Item.png"];
		itemBody->data = @"icoin1";
	}else if (random <= n/8) {
		itemSprite = [Sprite spriteWithFile:@"coin2Item.png"];
		itemBody->data = @"icoin2";
	}
	else {
		return;
	}
	
	
	itemBody->p = cpv(pos.x, pos.y);
	itemBody->v = cpv(0,0);
	cpShape* item = cpCircleShapeNew(itemBody, ITEM_RADIUS, cpvzero);
	item->e = 0.0; item->u = 1.0;
	item->group = BALL_GROUP;
	item->collision_type = ITEM_CT;
	item->sensor = TRUE;
	
	item->data = itemSprite;
	[gameLayer addChild:itemSprite z:2];
	cpBodyApplyForce(itemBody, cpv(0, itemBody->m*GRAVITY), cpvzero); //-200 = gravity
	cpSpaceAddShape(space, item);
	cpSpaceAddBody(space, itemBody);
}

/* Ball hit user */
int killUser(cpArbiter *arb, cpSpace *space, void *unused)
{
	levelOver = FALSE;
	cpShape *a, *b; cpArbiterGetShapes(arb, &a, &b);
	// Shapes can only be deleted at certain points
	if (shield == FULL) {
		[NSTimer scheduledTimerWithTimeInterval:2 target:gameLayer selector:@selector(loseInvinc:) userInfo:nil repeats:NO];
		shield = LOSING;
	}
	else if (shield == NONE) {
		deadShape = b;
		livesleft--;
		if (livesleft <= 0) {
			[gameLayer removeAllChildrenWithCleanup:TRUE];
			cpSpaceFreeChildren(space);
			cpSpaceFree(space);
			cpBodyFree(staticBody);
			EndGameScene * egs = [EndGameScene node];
			[scene removeAllChildrenWithCleanup:FALSE];
			[[Director sharedDirector] replaceScene:egs]; 
		}	
		else {
			laserShape = NULL;
			laserShape2 = NULL;
			fireTwice = false;
		}
	}
	return 0;
}

/* User has touched an item */
int getItem(cpArbiter *arb, cpSpace *space, void *unused)
{
	cpShape *a, *b; 
	cpArbiterGetShapes(arb, &a, &b);
	
	if ([(NSString *)a->body->data isEqualToString: @"icoin1"])
		score += 500;
	else if ([(NSString *)a->body->data isEqualToString: @"icoin2"])
		score += 1500;
	else if ([(NSString *)a->body->data isEqualToString: @"ilife"]) {
		livesleft++;
		[livesLabel removeFromSuperview];
		livesLabel.text = [NSString stringWithFormat:@"Lives:%d", livesleft];
		[window addSubview:livesLabel ];
	}
	else if ([(NSString *)a->body->data isEqualToString: @"ishield"])
		shield = FULL;
	else if ([(NSString *)a->body->data isEqualToString: @"ilasers"]) {
		fireTwice = TRUE;
	}
	cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, a, NULL);
	return 0;
}

/* Retrieve height based on radius */
int getHeight(float r) {
	if (r == XS_RADIUS)
		return XS_HEIGHT;
	else if (r == S_RADIUS)
		return S_HEIGHT;
	else if (r == M_RADIUS)
		return M_HEIGHT;
	else if (r == L_RADIUS)
		return L_HEIGHT;
	else if (r == XL_RADIUS)
		return XL_HEIGHT;
	else
		return 99999;
}

/* A ball hit the wall */
int hitWall(cpArbiter *arb, cpSpace *space, void *unused)
{
	cpShape *a, *b; cpArbiterGetShapes(arb, &a, &b);
	cpBody *body = a->body;
	NSString * color = body->data;
	int signVX = body->v.x/(abs(body->v.x));
	int signVY = body->v.y/(abs(body->v.y));
	
	cpFloat rad = ((cpCircleShape *)a)->r;
	NSString * loc = b->data;
	bool bot = [loc isEqualToString: @"bottom"];
	bool r = [loc isEqualToString: @"right"];
	bool t = [loc isEqualToString: @"top"];
	bool l = [loc isEqualToString: @"left"];
	if ([color isEqualToString:  @"ORANGE"]) { // Orange balls gravitate to wall most recently hit (fairly complicated)
		if (body->f.y < 0 && (l || r)) {// bouncing from bottom wall
			body->f = cpv(0,0);
			cpBodyApplyForce(body, cpv(signVX*-body->m*GRAVITY, 0), cpvzero);
			body->v = cpv(-signVX*sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)), BALL_VX);
		}
		else if (body->f.x > 0 && (t || bot)) {// bouncing from right wall
			body->f = cpv(0,0);
			cpBodyApplyForce(body, cpv(0, signVY*-body->m*GRAVITY), cpvzero);
			body->v = cpv(-BALL_VX,-signVY*sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)));
		}
		else if (body->f.y > 0 && (l || r)) { // bouncing from top wall
			body->f = cpv(0,0);
			cpBodyApplyForce(body, cpv(signVX*-body->m*GRAVITY, 0), cpvzero);
			body->v = cpv(-signVX*sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)), -BALL_VX);
		}
		else if (body->f.x < 0 && (t || bot)) { // bouncing from left wall
			body->f = cpv(0,0);
			int Fy = signVY*-body->m*GRAVITY;
			cpBodyApplyForce(body, cpv(0, Fy), cpvzero);
			body->v = cpv(BALL_VX,-signVY*sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)));
		}
		else {
			
			if (bot) {
				body->v = cpv(signVX*BALL_VX,sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)));
			}
			else if (r) {
				body->v = cpv(-sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)), signVY*BALL_VX);
			}
			else if (t) {
				body->v = cpv(signVX*BALL_VX,-sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)));
			}
			else if (l) {
				body->v = cpv(sqrt(-2.0*GRAVITY*(getHeight(rad) - rad - HUD_SIZE)), signVY*BALL_VX);
			}
			
		}
	}
	return 0;
}

/* get points for this particular ball*/
int getPoints(cpCircleShape *a) {
	if (a->r <= 5)
		return 100;
	else if (a->r <= 10)
		return 50;
	else if (a->r <= 20)
		return 25;
	else if (a->r <= 40)
		return 15;
	else
		return -99999999;
}
@end

	


