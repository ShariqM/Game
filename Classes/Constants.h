//
//  Constants.h
//  Fate
//
//  Created by Shariq Mobin on 5/27/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//

extern NSString * const MySecondConstant;


extern int const margin;
extern int const HUD_SIZE;

extern float const BALL_MASS;

extern float const XS_BALL_MASS;
extern float const S_BALL_MASS;
extern float const M_BALL_MASS;
extern float const L_BALL_MASS;
extern float const XL_BALL_MASS;

extern int const XS_RADIUS;
extern int const S_RADIUS;
extern int const M_RADIUS;
extern int const L_RADIUS;
extern int const XL_RADIUS;

extern int XS_HEIGHT;
extern int S_HEIGHT;
extern int M_HEIGHT;
extern int L_HEIGHT;
extern int XL_HEIGHT;
extern int const normHelp;

extern int const BALL_VX;
extern int const BALL_VY;

extern float const ELASTICITY;
extern float const FRICTION;

extern int const BALL_GROUP;
extern int const USER_GROUP;
extern int const LASER_GROUP;
extern int const ITEM_GROUP;

extern int const LASER_VY;
extern float const LASER_MASS;
extern float const LASER_WIDTH;
extern float const LASER_HEIGHT;

extern float const USER_HEIGHT;
extern float const USER_HEAD_RADIUS;
extern int const USER_BODY_HEIGHT;
extern int const USER_HEAD_HEIGHT;
extern float const USER_WIDTH;
extern float const USER_MASS;

extern float const ITEM_RADIUS;

extern int const ITEM_MASS;

extern float const DELTA;

extern float const GRAVITY;

extern float const DELTA_POS;

extern int const LASER_CT; // CT = Collision Type
extern int const BALL_CT;
extern int const USER_CT;
extern int const WALL_CT;
extern int const ITEM_CT;

extern int const STEP_KILL_DELAY;

extern int const NEWBALL_VY;

extern int const kAccelerometerFrequency;
extern float const kFilteringFactor;

extern float const MIN_ACCEL_Y;
extern float const MIN_ACCEL_X;

extern float const LASER_JOINT_FACTOR;

extern float const PLAYER_SPEED;
extern int const accelUpdateInt;

extern int const readyDelay;
extern float const unPauseDelay;
extern double const explosionDelay;

extern int LIVES;

extern int const LASER_DELTA;

extern int const capePIXEL;

extern float const PURPLE_HEIGHT_RATIO;

typedef enum Shield{
	FULL = 1,
	LOSING = 0,
	NONE = -FULL,
	DEAD = 2,
} Shield;