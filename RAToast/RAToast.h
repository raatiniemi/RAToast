//
//  RAToast.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RAToastControllerDelegate.h"

@class RAToastView;

/// Available toast gravity options, e.g. position on the screen.
typedef NS_OPTIONS(short int, RAToastGravity) {
	/// Position the toast against the top of the screen.
	RAToastGravityTop = 1 << 0,

	/// Position the toast against the bottom of the screen.
	RAToastGravityBottom = 1 << 1,

	/// Position the toast against the right side of the screen.
	RAToastGravityRight = 1 << 2,

	/// Position the toast against the left side of the screen.
	RAToastGravityLeft = 1 << 3
};

/// Type for the toast duration in seconds.
typedef NSTimeInterval RAToastDuration;

/// Short duration (1 second) for displaying a toast.
extern const RAToastDuration RAToastDurationShort;

/// Normal duration (2 seconds) for displaying a toast.
extern const RAToastDuration RAToastDurationNormal;

/// Long duration (3 seconds) for displaying a toast.
extern const RAToastDuration RAToastDurationLong;

/**
 Handles the toast configuration and relay actions.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToast : NSObject {
@protected
	NSString *_text;
	NSTimeInterval _duration;
	RAToastGravity _gravity;

	RAToastView *_view;
}

/// Text to be displayed with the toast.
@property (readonly) NSString *text;

/// Duration in seconds to display the toast.
@property RAToastDuration duration;

/// Gravity to be used with the toast, i.e. position.
@property RAToastGravity gravity;

/// View to be used with the toast.
@property RAToastView *view;

#pragma mark - Initialization

/**
 The `init`-method have been disabled, either of the `makeText:duration:` or
 `makeText:` methods should be used.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (id)init __unavailable;

/**
 Make toast with text and duration.

 @param text Text to display with the toast.
 @param duration Duration to show the toast.

 @return Initialized toast ready to be displayed.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
+ (instancetype)makeText:(NSString *)text duration:(RAToastDuration)duration;

/**
 Make toast with text.

 @param text Text to display with the toast.

 @return Initialized toast ready to be displayed.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 The `makeText:`-method will forward the call to the `makeText:duration:`-method
 with the default toast duration.
 */
+ (instancetype)makeText:(NSString *)text;

#pragma mark - Show

/**
 Display the toast at the given position.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)show;

@end