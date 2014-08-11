//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

#import "RAToast.h"

const NSInteger RAToastViewMargin = 20.0;

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
	NSLog(@"%@", NSStringFromCGSize([self availableSize]));
	NSLog(@"%@", NSStringFromCGSize([self size]));
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