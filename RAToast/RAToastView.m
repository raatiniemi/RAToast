//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

#import "RAToast.h"

/**
 Handles everything related to the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView () {
@private
	RAToast *_toast;

	UILabel *_textLabel;
}

@property RAToast *toast;

/// View for the toast text message.
@property UILabel *textLabel;

#pragma mark - Layout

/**
 Setup the background view, i.e. the toast container.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)setupBackgroundView;

/**
 Setup the text label, i.e. the view for displaying the actual toast message.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)setupTextLabel;

@end

@implementation RAToastView

@synthesize toast = _toast;

#pragma mark - Initialization

- (instancetype)initWithToast:(RAToast *)toast
{
	if ( self = [super initWithFrame:CGRectZero] ) {
		[self setToast:toast];

		// Configure the view and subviews.
		[self setupView];

		// Hook up the notification for device orientation changes.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}

	return self;
}

#pragma mark - Orientation

- (void)deviceOrientationDidChange:(id)sender
{
	// TODO: Handle the orientation correctly, with toast rotate, etc.
	[self updateView];
}

#pragma mark - Layout

- (void)setupView
{
	[self setupBackgroundView];
	[self setupTextLabel];
}

- (void)setupBackgroundView
{
	[self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
	[self setClipsToBounds:YES];
}

- (void)setupTextLabel
{
	[self setTextLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
	[[self textLabel] setBackgroundColor:[UIColor clearColor]];
	[[self textLabel] setTextColor:[UIColor whiteColor]];
	[[self textLabel] setFont:[UIFont systemFontOfSize:14.0]];
	[[self textLabel] setNumberOfLines:0];
	[[self textLabel] setText:[[self toast] text]];

	[self addSubview:[self textLabel]];
}

- (void)updateView
{
	// Retrieve the size of the application screen.
	CGRect screen = [[UIScreen mainScreen] bounds];

	// Define the X and Y position for the text box within the toast.
	// These variables are reused later for the X and Y position for the toast.
	CGFloat x = 10.0;
	CGFloat y = 5.0;

	// Calculate the horizontal and vertical space between the edge of the
	// background box and the text box.
	CGFloat horizontal = (x * 2.0);
	CGFloat vertical = (y * 2.0);

	// Calculate the max values for width and height. These values are
	// calculated with a max screen percentage coverage. The horizontal and
	// vertical space also have to be included within the calculations,
	// otherwise the box will not be correctly positioned.
	CGFloat maxWidth = round(screen.size.width - 20.0 - horizontal);
	CGFloat maxHeight = round(screen.size.height - 20.0 - vertical);

	// Calculate the appropriate width and height for the text box based on the
	// text content with the max width and height.
	CGSize size = [[self textLabel] sizeThatFits:CGSizeMake(maxWidth, maxHeight)];

	// Set the calculated position and size for the text box.
	CGRect text = CGRectMake(x, y, size.width, size.height);
	[[self textLabel] setFrame:text];

	// Calculate the new width and height for the actual view. These calculations have
	// to include the margin for the text (i.e. the x and y positions the UILabel).
	CGFloat width = (size.width + horizontal);
	CGFloat height = (size.height + vertical);

	// Set the calculated position and size for the toast.
	CGRect frame = CGRectMake(0.0, 0.0, width, height);
	[self setFrame:frame];

	// The toast should be centered around a specific point.
	// Calculate the center of the screen as the x position.
	CGPoint point = CGPointZero;
	point.x = round((screen.size.width / 2.0));

	// Based on the gravity, the Y position calculation is different.
	switch ( [[self toast] gravity] ) {
		case RAToastGravityTop:
		case RAToastGravityCenter:
			// TODO: Implement support for additional gravities.
			// To implement support for top and center gravity the toast have to
			// be aware of the surrounding views.
			// E.g. what type of `UIEdgeRect` is being used, does the view
			// controller have a `UINavigationController`.
			NSLog(@"Gravity have not yet been implemented, fallback to `RAToastGravityBottom`");
		case RAToastGravityBottom:
		default:
			point.y = round((screen.size.height - (height / 2.0) - horizontal));
			break;
	}

	// Set the center point for the view.
	[self setCenter:point];
}

@end