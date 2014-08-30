//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

const NSInteger RAToastViewMargin = 10.0;

/**
 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView () {
@private
	RAToast *_toast;

	NSTimer *_hideTimer;
}

/// Toast linked to the view.
@property (readwrite) RAToast *toast;

@property NSTimer *hideTimer;

#pragma mark - Animation

- (void)handleHideAnimationWithTimer:(NSTimer *)timer;

- (void)performHideAnimationWithCompletion:(void (^)(BOOL))completion;

@end

@implementation RAToastView

@synthesize toast = _toast;

@synthesize hideTimer = _hideTimer;

#pragma mark - Initialization

- (instancetype)initWithToast:(RAToast *)toast
{
	if ( self = [super initWithFrame:CGRectZero] ) {
		[self setToast:toast];

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

	UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastSwipe:)];
	[swipe setDirection:UISwipeGestureRecognizerDirectionRight];
	[self addGestureRecognizer:swipe];

	swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastSwipe:)];
	[swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self addGestureRecognizer:swipe];
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

- (void)handleHideAnimationWithTimer:(NSTimer *)timer
{
	// TODO: Verify that the userInfo is the completion block.
	if ( [timer userInfo] ) {
		[self performHideAnimationWithCompletion:[timer userInfo]];
	}
}

- (void)performHideAnimationWithCompletion:(void (^)(BOOL))completion
{
	if ( [self respondsToSelector:kRAToastPreHideAnimationStateSelector] ) {
		[self performSelector:kRAToastPreHideAnimationStateSelector];
	}

	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		[self hideAnimationState];
	} completion:^(BOOL finished) {
		if ( [self respondsToSelector:kRAToastPostHideAnimationStateSelector] ) {
			[self performSelector:kRAToastPostHideAnimationStateSelector];
		}

		completion(finished);
	}];
}

#pragma mark - User interaction

- (void)handleToastSwipe:(UISwipeGestureRecognizer *)recognizer
{
	[[self hideTimer] invalidate];
	[self setHideTimer:nil];

	if ( [self respondsToSelector:kRAToastPreHideAnimationStateSelector] ) {
		[self performSelector:kRAToastPreHideAnimationStateSelector];
	}

	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		CGRect frame = [self frame];
		if ( [recognizer direction] & UISwipeGestureRecognizerDirectionLeft ) {
			frame.origin.x = -frame.size.width;
		} else {
			CGSize size = [self availableSize];
			frame.origin.x = frame.size.width + size.width + RAToastViewMargin;
		}
		[self setFrame:frame];
	} completion:^(BOOL finished) {
		if ( [self respondsToSelector:kRAToastPostHideAnimationStateSelector] ) {
			[self performSelector:kRAToastPostHideAnimationStateSelector];
		}

		// TODO: Correct handle the `completion`.
		// completion(finished);
	}];
}

#pragma mark - RAToastAnimationDelegate

- (void)animateWithCompletion:(void (^)(BOOL))completion
{
	[self preShowAnimationState];

	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
		[self showAnimationState];
	} completion:^(BOOL finished) {
		if ( finished ) {
			if ( [self respondsToSelector:kRAToastPostShowAnimationStateSelector] ) {
				[self performSelector:kRAToastPostShowAnimationStateSelector];
			}

			[self setHideTimer:[NSTimer scheduledTimerWithTimeInterval:[[self toast] duration] target:self selector:@selector(handleHideAnimationWithTimer:) userInfo:completion repeats:NO]];
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