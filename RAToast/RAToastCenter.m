//
//  RAToastCenter.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastCenter.h"
#import "RAToastOperation.h"

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

		// TODO: Hook up notification for device orientation did change.
	}

	return self;
}

#pragma mark - Queue

- (void)addToast:(RAToastOperation *)toast
{
	[[self queue] addOperation:toast];
}

#pragma mark - Observer

- (void)deviceOrientationDidChange:(id)sender
{
	if ( [[self queue] operationCount] > 0 ) {
		// TODO: Update the toast view for the first operation.
	}
}

@end