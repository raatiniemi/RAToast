//
//  RAToast.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAToastView;

/// TODO: Replace with bit mask for better precision.
/// E.g. setGravity(RAToastGravityTop|RAToastGravityLeft).

/// Available toast gravity options, e.g. position.
typedef NS_ENUM(short int, RAToastGravity) {
	/// Position the toast against the top of the screen.
	RAToastGravityTop,

	/// Position the toast at the center of the screen.
	RAToastGravityCenter,

	/// Position the toast against the bottom of the screen.
	RAToastGravityBottom
};

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
@property NSTimeInterval duration;

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
+ (instancetype)makeText:(NSString *)text duration:(NSTimeInterval)duration;

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