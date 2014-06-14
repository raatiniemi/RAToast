//
//  RAToastCenter.m
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastCenter.h"
#import "RAToastOperation.h"

static RAToastCenter *_defaultCenter;

@interface RAToastCenter () {
@private
	NSOperationQueue *_queue;
}

@property NSOperationQueue *queue;

@end

@implementation RAToastCenter

@synthesize queue = _queue;

+ (instancetype)defaultCenter
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_defaultCenter = [[RAToastCenter alloc] init];
	});

	return _defaultCenter;
}

- (id)init
{
	if ( self = [super init] ) {
		[self setQueue:[[NSOperationQueue alloc] init]];
		[[self queue] setMaxConcurrentOperationCount:1];

		// TODO: Hook up notification for device orientation did change.
	}

	return self;
}

- (void)deviceOrientationDidChange:(id)sender
{
	if ( [[self queue] operationCount] > 0 ) {
		// TODO: Update the toast view for the first operation.
	}
}

- (void)addToast:(RAToastOperation *)toast
{
	[[self queue] addOperation:toast];
}

@end