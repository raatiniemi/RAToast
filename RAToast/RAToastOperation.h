//
//  RAToastOperation.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAToast;

/// Available status codes for the toast operation status.
typedef NS_ENUM(short int, RAToastOperationStatus) {
	/// Default status when none have been assigned.
	RAToastOperationStatusNone,

	/// Toast operation is ready to be executed.
	RAToastOperationStatusReady,

	/// Toast operation is currently executing.
	RAToastOperationStatusExecuting,

	/// Toast operation have finished executing.
	RAToastOperationStatusFinished
};

/**
 Executes the `RAToast` within the queue, relays the animation to the view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastOperation : NSOperation

/// Toast used with the operation.
@property (readonly) RAToast *toast;

#pragma mark - Initialization

/**
 Initialize the operation with the toast.

 @param toast Toast to use with the operation.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithToast:(RAToast *)toast;

/// Disabled, use `initWithToast:`.
- (id)init __unavailable;

@end