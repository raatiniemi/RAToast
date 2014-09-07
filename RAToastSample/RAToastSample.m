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
	RAToastViewController *tcv = [[RAToastViewController alloc] init];
	[tcv setTitle:NSLocalizedString(@"Toaster", nil)];

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tcv];

	[self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	[[self window] setRootViewController:nc];
	[[self window] makeKeyAndVisible];
}

@end