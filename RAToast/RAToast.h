//
//  RAToast.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 RAToast *toast = [RAToast makeText:@""];
 [toast setGravity:RAToastGravityBottom];
 [toast setDuration: ...];
 [toast setDelay: ...];
 [toast show];

 The RAToast uses internally NSOperation (RAToastOperation) and NSOperationQueue
 (RAToastOperationQueue) to handle the message queue.

 When the user taps and holds on a toast, the operation should pause. If the
 user either swipes to the toast to either of the sides or simply taps and
 releases the toast should disapear (i.e. the user have acknowledge the toast
 and want to dismiss it).

 Custom views should be supported, e.g. views with icons, buttons, etc. As the
 "Undo" toast in Gmail on Android (when removing mail). However, this should be
 an upcoming feature, not really necessary at this point.

 Default supplied views should only be with square and slightly rounded cornes.
 
 TODO: Add support for custom animations, preAnimation: postAnimation:
 */

@class RAToastView;

typedef NS_ENUM(short int, RAToastGravity) {
	RAToastGravityTop,
	RAToastGravityCenter,
	RAToastGravityBottom
};

extern NSTimeInterval RAToastTimeIntervalDuration;

@interface RAToast : NSObject

@property (readonly) RAToastView *view;

@property NSTimeInterval duration;

@property (nonatomic, readonly) NSString *text;

+ (instancetype)makeText:(NSString *)text;

- (instancetype)initWithView:(RAToastView *)view;

- (void)show;

@end