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

static UIViewController *_controller;

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

#pragma mark - Show

- (void)show
{
	// TODO: Relay the toast recognizer configuration (enable/disable) to the view.

	// If no view have been defined we have to initialize the default view.
	if ( ![self view] ) {
		// Initialize the view with the toast.
		[self setView:[[RAToastViewDefault alloc] initWithToast:self]];
	}

	// Add the toast operation to the toast queue.
	[[RAToastCenter defaultCenter] addToast:[self operation]];
}

#pragma mark - Delegate

+ (void)setDelegate:(UIViewController *)viewController
{
	// TODO: Implement the `seDelegate:`-method.
	RAToastLogWarning(@"`%s` have yet to be fully implemented", __PRETTY_FUNCTION__);
}

#pragma mark - Controller

- (UIViewController *)getController
{

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		UIViewController *controller = rootViewController;

		// There're scenarios where you'd want to use another view controller
		// than the application root view controller.
		if ( [rootViewController conformsToProtocol:@protocol(RAToastControllerDelegate)] ) {
			if ( [rootViewController respondsToSelector:@selector(getToastController)] ) {
				// Attempt to retrieve the controller delegate, if none is found
				// revert to the root view controller.
				controller = [rootViewController performSelector:@selector(getToastController)];
				if ( !controller ) {
					controller = rootViewController;
				}
			}
		}
		_controller = controller;
	});

	return _controller;
}

@end