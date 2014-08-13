//
//  RAToastCenter.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastCenter.h"

#import "RAToastOperation.h"
#import "RAToast.h"
#import "RAToastView.h"

/**
 Instance for the default toast center.

 @note
 Automatically instansiated the first time the `defaultCenter`-method is called.
 */
static RAToastCenter *_defaultCenter;

/**
 Handles the queuing for the toast operations.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastCenter () {
@private
	NSOperationQueue *_queue;
}

/// Queue for the toast center, manages the queuing of toast messages.
@property NSOperationQueue *queue;

@end

@implementation RAToastCenter

@synthesize queue = _queue;

#pragma mark - Initialization

+ (instancetype)defaultCenter
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_defaultCenter = [[RAToastCenter alloc] init];
	});

	return _defaultCenter;
}

- (id)init
{
	if ( self = [super init] ) {
		// Initialize the operation queue.
		[self setQueue:[[NSOperationQueue alloc] init]];

		// Only one toast can be visible at any given time. With multiple toast we can
		// easily clutter the GUI, especially if the toasts uses different gravities.
		[[self queue] setMaxConcurrentOperationCount:1];

		// Hook up the device orientation change notification. The notification first have
		// to be removed since we don't want the notifications to stack with each center.
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
													 name:UIDeviceOrientationDidChangeNotification object:nil];
	}

	return self;
}

#pragma mark - Queue

- (void)addToast:(RAToastOperation *)toast
{
	[[self queue] addOperation:toast];
}

#pragma mark - Orientation

- (void)deviceOrientationDidChange:(id)sender
{
	// Check that we have toast operations available, no need to relay the
	// orientation change if no operations are active.
	if ( [[self queue] operationCount] > 0 ) {
		// Retrieve the first operation, i.e. the one that is active now.
		RAToastOperation *operation = [[[self queue] operations] firstObject];
		if ( operation ) {
			if ( [operation isKindOfClass:[RAToastOperation class]] ) {
				RAToast *toast = [operation toast];
				if ( toast ) {
					[[toast view] updateView];
				} else {
					// TODO: Error log, toast is not available.
				}
			} else {
				// TODO: Error log, operation is not correct type.
			}
		} else {
			// TODO: Information log, operation is not available.
		}
	} else {
		// TODO: Information log, operation is not available.
	}
}

@end