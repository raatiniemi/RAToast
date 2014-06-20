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

@end