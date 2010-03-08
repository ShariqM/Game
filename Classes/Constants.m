//
//  Constants.m
//  Fate
//
//  Created by Shariq Mobin on 5/27/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//
#import "Constants.h";
NSString * const MySecondConstant = @"sup";

int const margin = 4;
int const HUD_SIZE = 12;

float const BALL_MASS = 0.01; 

float const XS_BALL_MASS = 2.68;
float const S_BALL_MASS = 21.45;
float const M_BALL_MASS = 214.94;
float const L_BALL_MASS = 1036.22;
float const XL_BALL_MASS = 3080.83;

int const XS_RADIUS = 4;
int const S_RADIUS = 8;
int const M_RADIUS = 14;
int const L_RADIUS = 26;
int const XL_RADIUS = 40;


int XS_HEIGHT = 50+12;
int S_HEIGHT = 70+12; // + HUD
int M_HEIGHT = 115+12;
int L_HEIGHT = 160+12;
int XL_HEIGHT = 220+12;
int const normHelp = 15;

int const BALL_VX = 50;
int const BALL_VY = 0;

float const ELASTICITY = 1.003; // 1.003 for 60fps
float const FRICTION = 0.0;

int const BALL_GROUP = 10;
int const USER_GROUP = 30;
int const LASER_GROUP = 20;
int const ITEM_GROUP = 10;
int const WALL_GROUP = 40;

int const LASER_VY = 50;
float const LASER_MASS = 100.0;
float const LASER_WIDTH = 3.0;
float const LASER_HEIGHT = 260;

float const USER_HEIGHT = 40.0;
float const USER_HEAD_RADIUS = 4.0;
int const USER_BODY_HEIGHT = 28;
int const USER_HEAD_HEIGHT = 12;
float const USER_WIDTH = 14.0; // was 14.0 // was 8.0
float const USER_MASS = 10.0;

float const ITEM_RADIUS = 8.0;
int const ITEM_MASS = 100;

float const DELTA = 4.5;

float const GRAVITY = -200; // -200 b4

float const DELTA_POS = 40.0;

int const LASER_CT = 40; // CT = Collision Type
int const BALL_CT = 50;
int const USER_CT = 60;
int const WALL_CT = 70;
int const ITEM_CT = 80;

int const STEP_KILL_DELAY = 0;

int const NEWBALL_VY = 145;


float const MIN_ACCEL_Y = 0.2;
float const MIN_ACCEL_X = -0.4;

float const LASER_JOINT_FACTOR = 12;

float const PLAYER_SPEED = 2.5;
int const accelUpdateInt = 30;


int LIVES = 15;

int const readyDelay = 2;
float const unPauseDelay = 0.0;
double const explosionDelay = 0.8;


int const capePIXEL = 5;

int const LASER_DELTA = 5;
						

int const kAccelerometerFrequency = 20; /// Hz
float const kFilteringFactor = 0.1; // Used to Isolate Gravity Comp.?

float const PURPLE_HEIGHT_RATIO = 1.8;







