//
//  RAToastSample.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-13.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastSample.h"

@implementation RAToastSample

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	[[self window] setRootViewController:[[RAToastViewController alloc] init]];
	[[self window] makeKeyAndVisible];
}

@end