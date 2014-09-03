//
//  RAToast.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToast.h"
#import "RAToastCenter.h"
#import "RAToastOperation.h"
#import "RAToastView.h"
#import "RAToastViewDefault.h"

const RAToastDuration RAToastDurationShort = 1.0;
const RAToastDuration RAToastDurationNormal = 2.0;
const RAToastDuration RAToastDurationLong = 3.0;

static UIViewController *_delegate;

/**
 Handles the toast configuration and relay actions.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToast () {
@private
	RAToastOperation *_operation;
}

/// Operation to be used when queuing the toast.
@property RAToastOperation *operation;

/// Text to be displayed with the toast.
@property (readwrite) NSString *text;

#pragma mark - Initialization

/**
 Initialize the toast with the text.

 @param text Text to display with the toast.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithText:(NSString *)text;

@end

@implementation RAToast

@synthesize operation = _operation;

@synthesize text = _text;

@synthesize duration = _duration;

@synthesize gravity = _gravity;

#pragma mark - Initialization

- (instancetype)initWithText:(NSString *)text
{
	if ( self = [super init] ) {
		[self setText:text];

		// Initialize the operation with the toast.
		[self setOperation:[[RAToastOperation alloc] initWithToast:self]];
	}

	return self;
}

+ (instancetype)makeText:(NSString *)text duration:(RAToastDuration)duration
{
	RAToast *toast = [[self alloc] initWithText:text];
	[toast setDuration:duration];
	[toast setGravity:RAToastGravityBottom];

	return toast;
}

+ (instancetype)makeText:(NSString *)text
{
	return [self makeText:text duration:RAToastDurationNormal];
}

#pragma mark - View

- (void)setView:(RAToastView *)view
{
	// Verify that the view is an instance of `RAToastView`.
	if ( [view isKindOfClass:[RAToastView class]] ) {
		_view = view;
	} else {
		// Invalid view instance supplied.
		RAToastLogWarning(@"View supplied to `setView:` is not an instance of `RAToastView`");
	}
}

- (RAToastView *)view
{
	// If no view have been defined we have to initialize the default view.
	if ( !_view ) {
		// Initialize the view with the toast.
		_view = [[RAToastViewDefault alloc] initWithToast:self];
	}

	return _view;
}

#pragma mark - Show

- (void)show
{
	// Add the toast operation to the toast queue.
	[[RAToastCenter defaultCenter] addToast:[self operation]];
}

#pragma mark - Delegate

+ (void)setDelegate:(UIViewController *)viewController
{
	_delegate = viewController;
}

+ (UIViewController *)delegate
{
	// If no delegate controller have been set we should fallback to using the
	// root view controller, might as well set it as the delegate.
	if ( !_delegate ) {
		_delegate = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	}
	return _delegate;
}

@end