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

- (instancetype)initWithQueue:(NSOperationQueue *)queue
{
	if ( self = [super init] ) {
		[self setQueue:queue];

		// Hook up the device orientation change notification. The notification first have
		// to be removed since we don't want the notifications to stack with each center.
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
													 name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	return self;
}

- (id)init
{
	if ( self = [self initWithQueue:[[NSOperationQueue alloc] init]] ) {
		// Only one toast can be visible at any given time. With multiple toast we can
		// easily clutter the GUI, especially if the toasts uses different gravities.
		[[self queue] setMaxConcurrentOperationCount:1];
	}

	return self;
}

#pragma mark - Queue

- (void)addToast:(RAToastOperation *)toast
{
	// Verify that the toast operation is valid.
	if ( toast && [toast isKindOfClass:[RAToastOperation class]] ) {
		[[self queue] addOperation:toast];
	} else {
		// Invalid toast operation have been supplied.
		RAToastLogError(@"Invalid toast operation given to `%s`", __PRETTY_FUNCTION__);
	}
}

#pragma mark - Orientation

- (void)deviceOrientationDidChange:(id)sender
{
	// Check that we have toast operations available, no need to relay the
	// orientation change if no operations are active.
	if ( [[self queue] operationCount] > 0 ) {
		// Get the pointer for the method, performance improvement.
		SEL selector = @selector(isKindOfClass:);

		typedef BOOL (*isClass) (id, SEL, Class);
		isClass isKindOfClass = (isClass)[self methodForSelector:selector];

		// Retrieve the first operation, i.e. the one that is active now.
		RAToastOperation *operation = [[[self queue] operations] firstObject];
		if ( operation && isKindOfClass(operation, selector, [RAToastOperation class]) ) {
			// Verify that the toast is an actual `RAToast`-instance.
			RAToast *toast = [operation toast];
			if ( toast && isKindOfClass(toast, selector, [RAToast class]) ) {
				// Retrieve and validate the view. It has to be a sub-class of
				// `RAToastView` and respond to the `updateView`-selector.
				RAToastView *view = [toast view];
				if ( view && isKindOfClass(view, selector, [RAToastView class]) ) {
					if ( [view respondsToSelector:@selector(updateView)] ) {
						[view updateView];
					} else {
						RAToastLogError(@"View supplied by toast do not respond to `updateView`");
					}
				} else {
					RAToastLogError(@"Invalid view supplied by the toast");
				}
			} else {
				RAToastLogError(@"Toast operation returned invalid toast");
			}
		} else {
			RAToastLogError(@"Toast queue returned invalid toast operation");
		}
	} else {
		RAToastLogDebug(@"No active toast are available for `%s`", __PRETTY_FUNCTION__);
	}
}

@end