//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

const NSInteger RAToastViewMargin = 10.0;

const RAToastDuration RAToastAnimationDuration = 0.8;

const RAToastDuration RAToastAnimationDelay = 0.0;

/**
 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView () {
@private
	RAToast *_toast;

	NSTimer *_hideTimer;

	/// Toast animation completion handler.
	RAToastAnimationCompletion _completion;
}

@property (readwrite) RAToast *toast;

/// Timer for hiding the toast after the duration have expired.
@property NSTimer *hideTimer;

#pragma mark - Animation

/**
 Initialize the default hide animation state after the toast duration have expired.

 @param timer Timer that triggered the hide.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)handleHideAnimationWithTimer:(NSTimer *)timer;

#pragma mark - User interaction

/**
 Handles when the toast have been tapped, provided that tap is enabled.

 @param recognizer Activated gesture recognizer.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 The animation for hiding the toast view when it has been tapped is always fade out.
 */
- (void)handleToastTap:(UITapGestureRecognizer *)recognizer;

/**
 Handles when the toast have been horizontal swiped, provided that swipe is enabled.

 @param recognizer Activated gesture recognizer.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 The animation for hiding the toast view when it has been swiped is always to
 position the view outside the screen in the direction it was swiped.
 */
- (void)handleToastSwipe:(UISwipeGestureRecognizer *)recognizer;

@end

@implementation RAToastView

@synthesize toast = _toast;

@synthesize hideTimer = _hideTimer;

@synthesize enableTapUserInteraction = _enableTapUserInteraction;

@synthesize enableSwipeUserInteraction = _enableSwipeUserInteraction;

#pragma mark - Initialization

- (instancetype)initWithToast:(RAToast *)toast
{
	if ( self = [super initWithFrame:CGRectZero] ) {
		[self setToast:toast];

		// Enable both tap and swipe user interactions by default.
		[self setEnableTapUserInteraction:YES];
		[self setEnableSwipeUserInteraction:YES];

		// Initialize the view configuration.
		[self setupView];
	}

	return self;
}

#pragma mark - Layout

- (void)setupView
{
	[self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
	[self setClipsToBounds:YES];

	[[self layer] setCornerRadius:18.0];

	// Check if the `tap` user interaction has been enabled. We should only
	// hook up the gesture recognizer if it has been enabled.
	if ( [self isTapUserInteractionEnabled] ) {
		// Setup the tap gesture recogniser.
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTap:)];
		[self addGestureRecognizer:tap];
	}

	// Check if the `swipe` user interaction has been enabled. We should only
	// hook up the gesture recognizer if it has been enabled.
	if ( [self isSwipeUserInteractionEnabled] ) {
		UISwipeGestureRecognizer *swipe;

		// Setup the swipe to the right gesture recognizer.
		swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastSwipe:)];
		[swipe setDirection:UISwipeGestureRecognizerDirectionRight];
		[self addGestureRecognizer:swipe];

		// Setup the swipe to the left gesture recognizer.
		swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastSwipe:)];
		[swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
		[self addGestureRecognizer:swipe];
	}
}

- (void)updateView
{
	// Retrieve the available screen size.
	CGSize screen = [self availableSize];

	// Retrieve the calculated size for the toast view.
	CGSize size = [self size];

	// The default X and Y position of the toast view.
	// This includes views aligned to the top and/or the left. And, if the toast
	// text expand to cover the entire screen.
	CGPoint position = CGPointMake(RAToastViewMargin, RAToastViewMargin);

	// TODO: Better handling of the fallback gravities.
	// The default gravity should always be bottom, even if only the right and
	// left gravity have been defined. The top and center (vertical) have to be
	// explicitly specified.

	// We only need to adjust the X-position if the screen width is lower than
	// that of the toast, and the toast gravity do not include left alignment.
	if ( screen.width > size.width && !( [[self toast] gravity] & RAToastGravityLeft ) ) {
		// The initial value for the X-position is aligned to the left.
		if ( [[self toast] gravity] & RAToastGravityRight ) {
			// Since the available screen size already subtract the
			// `RAToastViewMargin` nothing else needs to be done here.
			position.x = round(screen.width - size.width);
		} else {
			// If neither right or left gravity have been applied the position
			// of the toast view should be centered.
			position.x = round(((screen.width - size.width) + RAToastViewMargin) / 2.0);
		}
	}

	if ( screen.height > size.height && !( [[self toast] gravity] & RAToastGravityTop ) ) {
		position.y = round(screen.height - size.height);
	} else {
		// TODO: Check if the status bar should be included in the calculations.
		// I.e. via the controller delegate, related to the edgeRect.
	}

	[self setFrame:CGRectMake(position.x, position.y, size.width, size.height)];
}

- (CGSize)availableSize
{
	// Retrieve the available screen size.
	CGRect screen = [[UIScreen mainScreen] bounds];
	CGFloat width, height;

	// Depending on which way the screen is orientated we have to map the
	// width and height accordingly.
	switch ( [[UIDevice currentDevice] orientation] ) {
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			width = screen.size.height;
			height = screen.size.width;
			break;
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
		default:
			width = screen.size.width;
			height = screen.size.height;
			break;
	}

	// Subtract the view margin from the available size.
	width -= RAToastViewMargin;
	height -= RAToastViewMargin;

	return CGSizeMake(width, height);
}

- (CGSize)size
{
	return CGSizeZero;
}

#pragma mark - Animation

- (void)performHideWithAnimation:(void (^)(void))animation
{
	// Destroy the timer for hiding the toast. Prevents the hide animation from
	// being executed if the toast is dismissed with an user interaction.
	[[self hideTimer] invalidate];
	[self setHideTimer:nil];

	if ( [self preHideAnimationStateBlock] ) {
		[self preHideAnimationStateBlock]();
	} else {
		// If the view responds to the pre-hide animation state selector,
		// we have to execute the method.
		if ( [self respondsToSelector:kRAToastPreHideAnimationStateSelector] ) {
			[self performSelector:kRAToastPreHideAnimationStateSelector];
		}
	}

	[UIView animateWithDuration:RAToastAnimationDuration delay:RAToastAnimationDelay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		// Setup the animation state for hiding the view.
		animation();
	} completion:^(BOOL finished) {
		if ( [self postHideAnimationStateBlock] ) {
			[self postHideAnimationStateBlock]();
		} else {
			// If the view responds to the post-hide animation state selector,
			// we have to execute the method.
			if ( [self respondsToSelector:kRAToastPostHideAnimationStateSelector] ) {
				[self performSelector:kRAToastPostHideAnimationStateSelector];
			}
		}

		// Run the completion handler. This will tell the `RAToastOperation` that
		// the toast is finished, and the next one can begin.
		_completion(finished);
	}];
}

- (void)handleHideAnimationWithTimer:(NSTimer *)timer
{
	[self performHideWithAnimation:^{
		// Perform the default hide animation.
		if ( [self hideAnimationStateBlock] ) {
			[self hideAnimationStateBlock]();
		} else {
			[self hideAnimationState];
		}
	}];
}

#pragma mark - User interaction

- (void)handleToastTap:(UITapGestureRecognizer *)recognizer
{
	// Only handle the tap user interaction if it's enabled.
	if ( [self isTapUserInteractionEnabled] ) {
		[self performHideWithAnimation:^{
			// Toasts that are tapped should always just fade away.
			[self setAlpha:0.0];
		}];
	}
}

- (void)handleToastSwipe:(UISwipeGestureRecognizer *)recognizer
{
	// Only handle the swipe user interaction if it's enabled.
	if ( [self isSwipeUserInteractionEnabled] ) {
		[self performHideWithAnimation:^{
			// Depending on which one of the swipe gestures have been initialized
			// the position calculation will be different.
			//
			// Also, depending on which direction the user have swiped and what
			// horizontal gravity is being used, the animation speed will seem
			// different since the travel distance is different but the actual
			// duration is the same.
			CGRect frame = [self frame];
			if ( [recognizer direction] & UISwipeGestureRecognizerDirectionLeft ) {
				// The view should exit the screen to the left, e.g. just put the
				// view it's own negative width off the screen.
				frame.origin.x = -frame.size.width;
			} else {
				// The right direction is a bit trickier since we need to know the
				// entire screen width and toast width, including the margin.
				CGSize size = [self availableSize];
				frame.origin.x = size.width + frame.size.width + RAToastViewMargin;
			}
			// Setup the frame with the new horizontal position.
			[self setFrame:frame];
		}];
	}
}

#pragma mark - RAToastAnimationDelegate

- (void)animateWithCompletion:(RAToastAnimationCompletion)completion
{
	// Check that the completion handler have been supplied.
	if ( !completion ) {
		// TODO: Handle if no completion have been supplied.
		// Raise an exception? Or, something a bit more subtle.
	}

	// Assign the completion handler to the instance variable. The completion
	// handler may be used from several methods.
	_completion = completion;

	// Setup the pre-show animation state, e.g. from which state should the
	// toast be animated to be shown.
	if ( [self preShowAnimationStateBlock] ) {
		[self preShowAnimationStateBlock]();
	} else {
		[self preShowAnimationState];
	}

	[UIView animateWithDuration:RAToastAnimationDuration delay:RAToastAnimationDelay options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
		if ( [self showAnimationStateBlock] ) {
			[self showAnimationStateBlock]();
		} else {
			[self showAnimationState];
		}
	} completion:^(BOOL finished) {
		if ( finished ) {
			if ( [self postShowAnimationStateBlock] ) {
				[self postShowAnimationStateBlock]();
			} else {
				// If the view responds to the post-show animation state
				// selector, we have to execute the method.
				if ( [self respondsToSelector:kRAToastPostShowAnimationStateSelector] ) {
					[self performSelector:kRAToastPostShowAnimationStateSelector];
				}
			}

			// Setup the timer for hiding the toast after the duration has expired.
			[self setHideTimer:[NSTimer scheduledTimerWithTimeInterval:[[self toast] duration] target:self selector:@selector(handleHideAnimationWithTimer:) userInfo:nil repeats:NO]];
		}
	}];
}

#pragma mark -- Animation state

#pragma mark --- Show

- (void)preShowAnimationState
{
	[self setAlpha:0.0];
}

- (void)showAnimationState
{
	[self setAlpha:1.0];
}

#pragma mark -- Hide

- (void)hideAnimationState
{
	[self setAlpha:0.0];
}

@end