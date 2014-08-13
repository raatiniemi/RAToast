//
//  RAToastViewDefault.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-08-11.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastViewDefault.h"

@interface RAToastViewDefault () {
@private
	UILabel *_textLabel;
}

@property UILabel *textLabel;

@end

@implementation RAToastViewDefault

@synthesize textLabel = _textLabel;

- (void)setupView
{
	[super setupView];

	[self setTextLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
	[[self textLabel] setBackgroundColor:[UIColor clearColor]];
	[[self textLabel] setTextColor:[UIColor whiteColor]];
	[[self textLabel] setFont:[UIFont systemFontOfSize:14.0]];
	[[self textLabel] setNumberOfLines:0];
	[[self textLabel] setText:@"Demo sample text"];
	// [[self textLabel] setText:[[self toast] text]];

	[self addSubview:[self textLabel]];
}

- (CGSize)size
{
	// Setup the padding for each side within the toast view. From the outer
	// edge of the background view to the text label edge, X and Y points.
	CGPoint point = CGPointMake(15.0, 5.0);

	// Calculate the total horizontal and vertical padding.
	CGFloat horizontal = round(point.x * 2.0);
	CGFloat vertical = round(point.y * 2.0);

	// Retrieve the available screen size.
	CGSize available = [self availableSize];

	// Calculate the largest width and height for the text label.
	CGFloat width = round(available.width - horizontal);
	CGFloat height = round(available.height - vertical);

	// Attempt to retrieve a suitable size depending on the text label content.
	CGSize size = [[self textLabel] sizeThatFits:CGSizeMake(width, height)];

	// The size retrieved from the `sizeThatFits:`-method might be larger than
	// the maximum width and height. If it this is the case we have to fallback
	// to the maximum width and height.
	width = MIN(size.width, width);
	height = MIN(size.height, height);

	// Set the new frame dimensions for the text label, including the margin.
	[[self textLabel] setFrame:CGRectMake(point.x, point.y, width, height)];

	// Calculate the width and height for the background view, which is
	// basically the width and height from the text label plus the total
	// horizontal and vertical padding.
	width = round(width + horizontal);
	height = round(height + vertical);

	return CGSizeMake(width, height);
}

@end