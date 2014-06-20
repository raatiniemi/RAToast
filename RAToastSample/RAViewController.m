//
//  RAViewController.m
//  RAToastSample
//
//  Created by Tobias Raatiniemi on 2014-06-13.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAViewController.h"

@implementation RAViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Adjust the background color, since the background color of the toast box
	// are semi-transparent black.
	[[self view] setBackgroundColor:[UIColor whiteColor]];

	// Display toast attached to the top of the screen.
	RAToast *top = [RAToast makeText:@"Top with long duration"];
	[top setDuration:RAToastDurationLong];
	[top setGravity:RAToastGravityTop];
	[top show];

	// Display toast at a centered position.
	RAToast *center = [RAToast makeText:@"Center with normal duration"];
	[center setGravity:RAToastGravityCenter];
	[center show];

	// Display toast attached to the bottom of the screen.
	[[RAToast makeText:@"Bottom with short duration"
			  duration:RAToastDurationShort] show];
}

@end