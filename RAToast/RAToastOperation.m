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
#import "RAToastControllerDelegate.h"

/// Operation status key for ready to execute.
static NSString *operationStatusKeyReady = @"isReady";

/// Operation status key for executing.
static NSString *operationStatusKeyExecuting = @"isExecuting";

/// Operation status key for finished executing.
static NSString *operationStatusKeyFinished = @"isFinished";

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
@property (readwrite) RAToast *toast;

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
			[self willChangeValueForKey:operationStatusKeyReady];
			[self setStatus:RAToastOperationStatusReady];
			[self didChangeValueForKey:operationStatusKeyReady];
		} else {
			// Invalid instance of `RAToast` have been supplied.
			[NSException raise:NSInvalidArgumentException
						format:@"Invalid instance of `RAToast` have been supplied"];
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
	[self willChangeValueForKey:operationStatusKeyExecuting];
	[self setStatus:RAToastOperationStatusExecuting];
	[self didChangeValueForKey:operationStatusKeyExecuting];

	dispatch_sync(dispatch_get_main_queue(), ^{
		RAToastView *view = [[self toast] view];
		[view updateView];

		// Retrieve the toast controller and add the toast view.
		UIViewController *controller = [[self toast] getController];
		[[controller view] addSubview:view];
		[[controller view] bringSubviewToFront:view];

		// TODO: Document...
		[view animateWithCompletion:^(BOOL finished) {
			if ( finished ) {
				// Toast have finished, change status.
				[self willChangeValueForKey:operationStatusKeyFinished];
				[self setStatus:RAToastOperationStatusFinished];
				[self didChangeValueForKey:operationStatusKeyFinished];

				// Remove the view from the window. If the view is not removed
				// the views will keep stacking with each toast.
				[view removeFromSuperview];
			}
		}];
	});
}

@end