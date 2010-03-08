	//
//  DebugRenderer.m
//  Fate
//
//  Created by Shariq Mobin on 5/26/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

#import "chipmunk.h"
#import "Primitives.h"
#import "GameScene.h"
#import "cocos2d.h"
#import "Constants.h"
#import "OpenGL_Internal.h"
#import "Constants.h"
#import "GameLayer.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>


extern GameScene *scene;
extern cpSpace *space;
extern void  createPlayer();
extern void killShape(cpShape *a);
extern int getPoints(cpCircleShape *a);
extern int getHits(float radius);
extern int HitsToWin;
extern long timeLaunch;
extern GameLayer *gameLayer;
cpShape *deadShape;
extern cpShape *laserShape;
extern cpShape *laserShape2;
extern cpShape *userShape;
extern void postStepRemove(cpSpace *space, cpShape *shape, void *unused);
extern int score;
BOOL levelOver;


void drawCircleShape(cpShape *shape) {
	cpBody *body = shape->body;
	Sprite *ball = shape->data;
	cpCircleShape *circle = (cpCircleShape *)shape;
	cpVect c = cpvadd(body->p, cpvrotate(circle->c, body->rot));
	int radius = circle->r;
	CGPoint center = CGPointMake(c.x, c.y);
	if (c.y < HUD_SIZE) { // in case ball glitches and falls below ground
		c.y = HUD_SIZE+radius;
	}
	

	int sign = body->v.x/(abs(body->v.x));
	NSString * color = body->data;
	if (color != NULL && ![[(NSString *)shape->body->data substringToIndex:1] isEqualToString:@"i"]) // if a circle not a head or item then its a ball
		levelOver = FALSE;
		
	if ([color isEqualToString:  @"LBLUE"]) {
		if (radius == XS_RADIUS && c.y <= HUD_SIZE+XS_RADIUS+DELTA) // && body->v.y < 0 ? 
			body->v = cpv(sign*BALL_VX, sqrt(-2.0*GRAVITY*(XS_HEIGHT - XS_RADIUS - HUD_SIZE)));
		else if (radius == S_RADIUS && c.y <= HUD_SIZE+S_RADIUS+DELTA) // && body->v.y < 0 ? 
			body->v = cpv(sign*BALL_VX, sqrt(-2.0*GRAVITY*(S_HEIGHT - S_RADIUS - HUD_SIZE)));
		else if (radius == M_RADIUS && c.y <= HUD_SIZE+M_RADIUS+DELTA) // && body->v.y < 0 ?
			body->v = cpv(sign*BALL_VX,sqrt(-2.0*GRAVITY*(M_HEIGHT - M_RADIUS - HUD_SIZE)));
		else if (radius == L_RADIUS && c.y <= HUD_SIZE+L_RADIUS+DELTA) // && body->v.y < 0 ?
			body->v = cpv(sign*BALL_VX, sqrt(-2.0*GRAVITY*(L_HEIGHT - L_RADIUS - HUD_SIZE)));
		else if (radius == XL_RADIUS && c.y <= HUD_SIZE+XL_RADIUS+DELTA) // && body->v.y < 0 ?
			body->v = cpv(sign*BALL_VX, sqrt(-2.0*GRAVITY*(XL_HEIGHT - XL_RADIUS - HUD_SIZE)));
	}
	else if ([color isEqualToString:  @"GREEN"]) {
		int random = rand()%100;
		float mag = sqrt(pow(body->v.x, 2) + pow(body->v.y, 2));
		if (random >= 99) {

			int deg = rand()%360;
			float rad = deg*2*M_PI/180;
			body->v.x = mag*sin(rad);
			body->v.y = mag*cos(2*M_PI-rad);
		}
	}
	else if ([color isEqualToString:  @"PURPLE"]) {
		float deltaF = PURPLE_HEIGHT_RATIO*DELTA*1.5;
		if (radius == XS_RADIUS && c.x >= 480-(XS_RADIUS+deltaF)) // && body->v.y < 0 ? 
			body->v = cpv(-sqrt(-2.0*PURPLE_HEIGHT_RATIO*GRAVITY*(XS_HEIGHT - XS_RADIUS - HUD_SIZE)), body->v.y );
		else if (radius == S_RADIUS && c.x >= 480-(S_RADIUS+deltaF)) // && body->v.y < 0 ? 
			body->v = cpv(-sqrt(-2.0*PURPLE_HEIGHT_RATIO*GRAVITY*(S_HEIGHT - S_RADIUS - HUD_SIZE)), body->v.y );
		else if (radius == M_RADIUS && c.x >= 480-(M_RADIUS+deltaF)) // && body->v.y < 0 ?
			body->v = cpv(-sqrt(-2.0*PURPLE_HEIGHT_RATIO*GRAVITY*(M_HEIGHT - M_RADIUS - HUD_SIZE)), body->v.y );
		else if (radius == L_RADIUS && c.x >= 480-(L_RADIUS+deltaF)) // && body->v.y < 0 ?
			body->v = cpv(-sqrt(-2.0*PURPLE_HEIGHT_RATIO*GRAVITY*(L_HEIGHT - L_RADIUS - HUD_SIZE)), body->v.y );
		else if (radius == XL_RADIUS &&  c.x >= 480-(XL_RADIUS+deltaF)) // && body->v.y < 0 ?
			body->v = cpv(-sqrt(-2.0*PURPLE_HEIGHT_RATIO*GRAVITY*(XL_HEIGHT - XL_RADIUS - HUD_SIZE)), body->v.y );
	}
		
		
	ball.position = ccp(c.x, c.y);
	drawCircle(center, circle->r, body->a, 50, TRUE);
}

void drawSegmentShape(cpShape *shape) {
	cpBody *body = shape->body;
	cpSegmentShape *seg = (cpSegmentShape *)shape;
	cpVect aa = cpvadd(body->p, cpvrotate(seg->a, body->rot));
	CGPoint a = CGPointMake(aa.x, aa.y);
	cpVect bb = cpvadd(body->p, cpvrotate(seg->b, body->rot));
	CGPoint b = CGPointMake(bb.x, bb.y);
	drawLine( a , b );
}

void drawPolyShape(cpShape *shape) {
	
	cpBody *body = shape->body;
	cpPolyShape *poly = (cpPolyShape *)shape;
	cpVect pos;
	cpVect c = cpvadd(body->p, cpvzero);
	
	if (shape == userShape) {
		[(Sprite *)shape->data setPosition:CGPointMake(shape->body->p.x-(USER_WIDTH/2),shape->body->p.y)];
   }
	else if (shape == laserShape) {
		pos = shape->body->p;
		[(Sprite *)laserShape->data setPosition:CGPointMake(c.x, c.y+(LASER_HEIGHT/2))];
	}
	else if (shape == laserShape2) {
		pos = shape->body->p;
		[(Sprite *)shape->data setPosition:CGPointMake(c.x, c.y+(LASER_HEIGHT/2))];
	}
	
	int num = poly->numVerts;
	cpVect *verts = poly->verts;
	
	float *vertices = malloc( sizeof(float)*2*poly->numVerts);
	if(!vertices)
		return;
	CGPoint *poli = malloc(sizeof(CGPoint)*poly->numVerts);

	for(int i=0; i<num; i++){
		cpVect v = cpvadd(body->p, cpvrotate(verts[i], body->rot));
		poli[i] = CGPointMake(v.x, v.y);
		vertices[i*2] = v.x;
		vertices[i*2+1] = v.y;
	}
	
	drawPoly( poli, poly->numVerts, TRUE);
	free(vertices);
}

void drawObject(void *ptr, void *unused) {
	cpShape *shape = (cpShape *)ptr;  
	
	switch(shape->klass->type){
		case CP_CIRCLE_SHAPE:
			drawCircleShape(shape);
			break;
		case CP_SEGMENT_SHAPE:
			drawSegmentShape(shape);
			break;
		case CP_POLY_SHAPE:
			drawPolyShape(shape);
			break;
		default:
			break;
	}
	cpVect pos = shape->body->p;
	if (shape == laserShape && pos.y >= USER_HEIGHT +HUD_SIZE) { // USER_HEIGHT+HUD_SIZE-margin+LASER_DELTA	
//		deadShape = shape; // kill laser obj
		cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, laserShape, NULL);

	}
	else if (shape == laserShape2 && pos.y >= USER_HEIGHT+HUD_SIZE) { // USER_HEIGHT+HUD_SIZE-margin+LASER_DELTA
	//	deadShape = shape; // kill laser obj
		cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, laserShape2, NULL);
	}

}

