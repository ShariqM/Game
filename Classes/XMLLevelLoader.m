//
//  XMLLevelLoader.m
//  Fate
//
//  Created by Shariq Mobin on 6/4/09.
//  Copyright 2009 UC Berkeley. All rights reserved.
//


#import "XMLLevelLoader.h"
#import "chipmunk.h"
#import "Constants.h"

extern void makeBall(float x, float y, float vx, float vy, float r, NSString *c);
extern void makeUser(int x, int y);
extern void makeStaticBox(float x, float y, float width, float height);
extern int HitsToWin;


@class GameLayer;

@implementation XMLLevelLoader

-(void) setGame: (GameLayer *) newGame{
	game = newGame;
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error {	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	
	NSError *parseError = [parser parserError];
	if (parseError && error) {
		*error = parseError;
	}
	
	[parser release];
}

int getHits(float radius) {
	if (radius == XS_RADIUS) // 1 hit kill
		return 1;
	else if (radius == S_RADIUS) // 1 hit kill
		return 3;
	else if (radius == M_RADIUS) // 
		return 7;
	else if (radius == L_RADIUS) // 
		return 15;
	else if (radius == XL_RADIUS) // 15 hit kill
		return 31;
	else
		return -9999;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString:@"ball"]) {
		float x = [[attributeDict valueForKey:@"x"] floatValue];
		float y = [[attributeDict valueForKey:@"y"] floatValue];
		float vx = [[attributeDict valueForKey:@"vx"] floatValue];
		float vy = [[attributeDict valueForKey:@"vy"] floatValue];
		NSString * rs = [attributeDict valueForKey:@"r"];
		NSString *c = [attributeDict valueForKey:@"c"]; // color
		float r;
		if ([rs isEqualToString:  @"xs"])
			r = XS_RADIUS;
		else if ([rs isEqualToString:  @"s"])
			r = S_RADIUS;
		else if ([rs isEqualToString:  @"m"])
			r = M_RADIUS;
		else if ([rs isEqualToString:  @"l"])
			r = L_RADIUS;
		else if ([rs isEqualToString:  @"xl"])
			r = XL_RADIUS;
		else {
			NSLog(@"ERROR:--------Unknown radius provided by xml level");
			r = 1029;
		}
		HitsToWin += getHits(r);
		makeBall(x, y, vx, vy, r, c);
	
	} else if([elementName isEqualToString:@"background"]) {
		NSString * url = [attributeDict valueForKey:@"url"];

		NSString * fileURL = [attributeDict valueForKey:@"file"];
		if(fileURL != nil){
			// TODO Later if wanted
		}
	}else if([elementName isEqualToString:@"next"]) {
		NSString *level = [attributeDict valueForKey:@"level"];
		// TODO
		[game setNextLevel: level];
		NSLog(@"XML says nextLevel = ");
		NSLog(level);
		NSLog(@"\n");
		
	}else if ([elementName isEqualToString:@"fate"]) {
		NSString *level = [attributeDict valueForKey:@"map"];
		[game setCurrLevel: level];
	}else if ([elementName isEqualToString:@"wall"]) {
		float x = [[attributeDict valueForKey:@"x"] floatValue];
		float y = [[attributeDict valueForKey:@"y"] floatValue];
		float w = [[attributeDict valueForKey:@"w"] floatValue];
		float h = [[attributeDict valueForKey:@"h"] floatValue];
		makeStaticBox(x, y, w, h);

		Sprite *wall = [Sprite spriteWithFile:@"wall.png"];
		[wall setPosition:ccp(x+w/2, y+h/2-USER_HEIGHT)];
		[game addChild:wall z:3];
		
	}else if ([elementName isEqualToString:@"user"]) {
		int x = [[attributeDict valueForKey:@"x"] intValue];
		int y = [[attributeDict valueForKey:@"y"] intValue];
		makeUser(x,y);
		
	}
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	NSLog(@"Error on XML Parse: %@", [parseError localizedDescription] );
}

@end

