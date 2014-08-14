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

	RAToast *toast = [RAToast makeText:@"Top left"];
	[toast setGravity:RAToastGravityTop|RAToastGravityLeft];
	[toast show];

	toast = [RAToast makeText:@"Top center"];
	[toast setGravity:RAToastGravityTop];
	[toast show];

	toast = [RAToast makeText:@"Top right"];
	[toast setGravity:RAToastGravityTop|RAToastGravityRight];
	[toast show];

	toast = [RAToast makeText:@"Bottom left"];
	[toast setGravity:RAToastGravityBottom|RAToastGravityLeft];
	[toast show];

	toast = [RAToast makeText:@"Bottom center"];
	[toast show];

	toast = [RAToast makeText:@"Bottom right"];
	[toast setGravity:RAToastGravityBottom|RAToastGravityRight];
	[toast show];
}

@end