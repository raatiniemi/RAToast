//
//  RAToastView.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastView.h"

@interface RAToastView () {
@private
	RAToastGravity _gravity;

	UILabel *_textLabel;
}

@property RAToastGravity gravity;

@property UILabel *textLabel;

@end

@implementation RAToastView

@synthesize gravity = _gravity;

- (instancetype)initWithGravity:(RAToastGravity)gravity
{
	if ( self = [super initWithFrame:CGRectZero] ) {
		[self setGravity:gravity];

		[self setupBackgroundView];
		[self setupTextLabel];
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithGravity:RAToastGravityBottom];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	return [self initWithGravity:RAToastGravityBottom];
}

- (id)init
{
	return [self initWithGravity:RAToastGravityBottom];
}

- (void)setupBackgroundView
{
	[self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
	[self setClipsToBounds:YES];
}

- (void)setupTextLabel
{
	[self setTextLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
	[[self textLabel] setBackgroundColor:[UIColor clearColor]];
	[[self textLabel] setTextColor:[UIColor whiteColor]];
	[[self textLabel] setFont:[UIFont systemFontOfSize:14.0]];
	[[self textLabel] setTextAlignment:NSTextAlignmentCenter];
	[[self textLabel] setNumberOfLines:0];

	[self addSubview:[self textLabel]];
}

- (void)updateView
{
	[self setFrame:[[UIScreen mainScreen] bounds]];
	[[self textLabel] setFrame:[self bounds]];
}

- (void)setText:(NSString *)text
{
	[[self textLabel] setText:text];
}

- (NSString *)text
{
	return [[self textLabel] text];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
	[self animateWithDuration:1.0 delay:duration options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

+ (void)animateWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
	[self animateWithDuration:0.0 animations:animations completion:completion];
}

@end