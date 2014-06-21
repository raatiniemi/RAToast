//
//  RAToastCenter.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAToastOperation;

/**
 Handles the queuing for the toast operations.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastCenter : NSObject

#pragma mark - Initialization

/**
 Retrieves the default toast center.

 @return Default toast center.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
+ (instancetype)defaultCenter;

#pragma mark - Queue

/**
 Add a toast to the queue.

 @param toast Toast that'll be added to the queue.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)addToast:(RAToastOperation *)toast;

#pragma mark - Orientation

/**
 Handles the device orientation changes.

 @param sender Object that sent the device orientation change notification.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 The orientation change have to be relayed from the `RAToastCenter` down to the
 active toast view. Hooking up the notification from within the `RAToastView`
 would cause one of two issues. When toast operations are being stacked, the
 notifications would wither stack aswell, or (if removed) only send the
 notification to the last operation in the stack.
 */
- (void)deviceOrientationDidChange:(id)sender;

@end