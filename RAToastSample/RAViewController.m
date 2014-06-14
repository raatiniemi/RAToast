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

	// Display three toast messages.
	// TODO: Add example with different duration and gravity.
	[[RAToast makeText:@"Toast #1"] show];
	[[RAToast makeText:@"Toast #2"] show];
	[[RAToast makeText:@"Toast #3"] show];
}

@end