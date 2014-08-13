//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

#import "RAToast.h"

const NSInteger RAToastViewMargin = 10.0;

@interface RAToastView () {
@private
	RAToast *_toast;
}

@property RAToast *toast;

@end

@implementation RAToastView

@synthesize toast = _toast;

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
}

- (void)updateView
{
	CGSize screen = [self availableSize];

	CGSize size = [self size];
	CGFloat x, y;

	// TODO: Check if the status bar should be included in the calculations.
	// I.e. via the controller delegate, related to the edgeRect.

	if ( screen.width < size.width ) {
		x = RAToastViewMargin;
	} else {
		x = round(((screen.width - size.width) + RAToastViewMargin) / 2.0);
	}

	if ( screen.height < size.height || [[self toast] gravity] & RAToastGravityTop ) {
		y = RAToastViewMargin;
	} else {
		y = round(screen.height - size.height);
	}

	[self setFrame:CGRectMake(x, y, size.width, size.height)];
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

@end