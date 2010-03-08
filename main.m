//
//  main.m
//  Fate
//
//  Created by Shariq Mobin on 5/25/09.
//  Copyright UC Berkeley 2009. All rights reserved.
//
#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil,
								   @"UnPhysicalAppDelegate");
	[pool release];
	return retVal;
}
