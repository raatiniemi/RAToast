//
//  RAToastOperation.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastOperation.h"

#import "RAToast.h"
#import "RAToastView.h"

#define kStatusKeyReady @"isReady"
#define kStatusKeyExecuting @"isExecuting"
#define kStatusKeyFinished @"isFinished"

/**
 Executes the `RAToast` within the queue, relays the animation to the view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastOperation () {
@private
	RAToast *_toast;
	RAToastOperationStatus _status;
}

/// Toast used with the operation.
@property RAToast *toast;

/// Status for the toast operation.
@property RAToastOperationStatus status;

@end

@implementation RAToastOperation

@synthesize toast = _toast;

@synthesize status = _status;

#pragma mark - Initialization

- (instancetype)initWithToast:(RAToast *)toast
{
	if ( self = [super init] ) {
		// Verify that the given instance is valid.
		if ( toast && [toast isKindOfClass:[RAToast class]] ) {
			[self setToast:toast];

			// The toast have been set and everything seems fine, change status.
			[self willChangeValueForKey:kStatusKeyReady];
			[self setStatus:RAToastOperationStatusReady];
			[self didChangeValueForKey:kStatusKeyReady];
		} else {
			// TODO: Handle invalid toast instance.
		}
	}

	return self;
}

#pragma mark - NSOperation

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
	// Toast is about to start executing, change status.
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
				// Toast have finished, change status.
				[self willChangeValueForKey:kStatusKeyFinished];
				[self setStatus:RAToastOperationStatusFinished];
				[self didChangeValueForKey:kStatusKeyFinished];

				// Remove the view from the window. If the view is not removed
				// the views will keep stacking with each toast.
				[view removeFromSuperview];
			}];
		}];
	});
}

@end