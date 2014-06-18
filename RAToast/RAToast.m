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

NSTimeInterval RAToastTimeIntervalDuration = 2.0;

@interface RAToast () {
@private
	RAToastOperation *_operation;

	RAToastView *_view;

	NSTimeInterval _duration;
}

@property RAToastOperation *operation;

@property (readwrite) RAToastView *view;

@property (readwrite) NSString *text;

@end

@implementation RAToast

@synthesize operation = _operation;

@synthesize view = _view;

@synthesize duration = _duration;

+ (instancetype)makeText:(NSString *)text gravity:(RAToastGravity)gravity duration:(NSTimeInterval)duration
{
	RAToast *toast = [[RAToast alloc] init];
	[toast setText:text];
	// TODO: Handle gravity and duration.

	return toast;
}

+ (instancetype)makeText:(NSString *)text gravity:(RAToastGravity)gravity
{
	return [self makeText:text gravity:gravity duration:RAToastTimeIntervalDuration];
}

+ (instancetype)makeText:(NSString *)text duration:(NSTimeInterval)duration
{
	return [self makeText:text gravity:RAToastGravityBottom duration:duration];
}

+ (instancetype)makeText:(NSString *)text
{
	return [self makeText:text gravity:RAToastGravityBottom duration:RAToastTimeIntervalDuration];
}

- (instancetype)initWithView:(RAToastView *)view
{
	if ( self = [super init] ) {
		[self setView:view];

		[self setOperation:[[RAToastOperation alloc] initWithToast:self]];
	}

	return self;
}

- (id)init
{
	return self = [self initWithView:[[RAToastView alloc] init]];
}

- (void)setText:(NSString *)text
{
	[[self view] setText:text];
}

- (NSString *)text
{
	return [[self view] text];
}

- (void)show
{
	[[RAToastCenter defaultCenter] addToast:[self operation]];
}

@end