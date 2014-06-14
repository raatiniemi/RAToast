//
//  RAViewController.m
//  RAToastSample
//
//  Created by Tobias Raatiniemi on 2014-06-13.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAViewController.h"
#import "RAToast.h"

@implementation RAViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[self view] setBackgroundColor:[UIColor whiteColor]];

	[[RAToast makeText:@"Toast text 1"] show];
	[[RAToast makeText:@"Toast text 2"] show];
	[[RAToast makeText:@"Toast text 3"] show];
}

@end