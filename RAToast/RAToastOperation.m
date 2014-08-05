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

/// Status key for ready.
#define kStatusKeyReady @"isReady"

/// Status key for executing.
#define kStatusKeyExecuting @"isExecuting"

/// Status key for finished.
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
			[self willChangeValueForKey:kStatusKeyReady];
			[self setStatus:RAToastOperationStatusReady];
			[self didChangeValueForKey:kStatusKeyReady];
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

		// Retrieve the root view controller.
		UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		UIViewController *controllerDelegate = rootViewController;

		// There are scenarios where you'd want to use another view controller rather than
		// the root view controller as the toast delegate. To do this the root view controller
		// have to conform to the `RAToastControllerDelegate`-protocol and respond to the
		// `getToastController`-selector, which in turn should provide the delegate controller.
		if ( [rootViewController conformsToProtocol:@protocol(RAToastControllerDelegate)] ) {
			if ( [rootViewController respondsToSelector:@selector(getToastController)] ) {
				// Attempt to retrieve the controller delegate, if none is found
				// revert to the root view controller.
				controllerDelegate = [rootViewController performSelector:@selector(getToastController)];
				if ( !controllerDelegate ) {
					controllerDelegate = rootViewController;
				}
			}
		}

		// Add the toast-view to the controller delegate.
		[[controllerDelegate view] addSubview:view];

		[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
			[view setAlpha:1.0];
		} completion:^(BOOL finished) {
			if ( finished ) {
				[UIView animateWithDuration:1.0 delay:[[self toast] duration] options:UIViewAnimationOptionBeginFromCurrentState animations:^{
					[view setAlpha:0.0];
				} completion:^(BOOL finished) {
					if ( finished ) {
						// Toast have finished, change status.
						[self willChangeValueForKey:kStatusKeyFinished];
						[self setStatus:RAToastOperationStatusFinished];
						[self didChangeValueForKey:kStatusKeyFinished];

						// Remove the view from the window. If the view is not removed
						// the views will keep stacking with each toast.
						[view removeFromSuperview];
					}
				}];
			}
		}];
	});
}

@end