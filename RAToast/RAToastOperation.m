//
//  RAToastOperation.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastOperation.h"

#define kStatusKeyReady @"isReady"
#define kStatusKeyExecuting @"isExecuting"
#define kStatusKeyFinished @"isFinished"

@interface RAToastOperation () {
@private
	RAToast *_toast;
	RAToastOperationStatus _status;
}

@property RAToast *toast;

@property RAToastOperationStatus status;

@end

@implementation RAToastOperation

@synthesize toast = _toast;

@synthesize status = _status;

- (instancetype)initWithToast:(RAToast *)toast
{
	// TODO: Handle if `toast` is `nil`.

	if ( self = [super init] ) {
		[self setToast:toast];

		[self willChangeValueForKey:kStatusKeyReady];
		[self setStatus:RAToastOperationStatusReady];
		[self didChangeValueForKey:kStatusKeyReady];
	}

	return self;
}

- (id)init
{
	return [self initWithToast:nil];
}

- (BOOL)isReady
{
	return [self status] == RAToastOperationStatusReady;
}

- (BOOL)isExecuting
{
	return [self status] == RAToastOperationStatusExecuting;
}

- (BOOL)isFinished
{
	return [self status] == RAToastOperationStatusFinished;
}

- (void)main
{
	[self willChangeValueForKey:kStatusKeyExecuting];
	[self setStatus:RAToastOperationStatusExecuting];
	[self didChangeValueForKey:kStatusKeyExecuting];

	dispatch_sync(dispatch_get_main_queue(), ^{
		RAToastView *view = [[self toast] view];
		[view updateView];
		[view setAlpha:0.0];

		// TODO: Migrate the animation to the view, with support for custom animations.
		// The animation have to be supplied with a callback-block that will
		// change the value of the operation status to finished, otherwise the
		// next operation won't execute.

		[[[UIApplication sharedApplication] keyWindow] addSubview:view];

		[RAToastView animateWithAnimations:^{
			[view setAlpha:1.0];
		} completion:^(BOOL finished) {
			[RAToastView animateWithDuration:[[self toast] duration] animations:^{
				[view setAlpha:0.0];
			} completion:^(BOOL finished) {
				[self willChangeValueForKey:kStatusKeyFinished];
				[self setStatus:RAToastOperationStatusFinished];
				[self didChangeValueForKey:kStatusKeyFinished];
			}];
		}];
	});
}

@end