//
//  RAToastView.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAToast;

/**
 Handles everything related to the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView : UIView

#pragma mark - Initialization

/**
 Initialize the view with the toast.

 @param toast Toast to be used with the view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithToast:(RAToast *)toast;

- (id)initWithFrame:(CGRect)frame __unavailable;

- (id)initWithCoder:(NSCoder *)aDecoder __unavailable;

- (id)init __unavailable;

#pragma mark - Layout

/**
 Setup the view and subviews.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)setupView;

/**
 Calculates the position and the size of the related views.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)updateView;

@end