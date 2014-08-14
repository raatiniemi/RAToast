//
//  RAToastView.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAToast.h"

/// The margin between the screen edges and the toast view.
extern const NSInteger RAToastViewMargin;

/**
 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView : UIView

/// Toast linked to the view.
@property (readonly) RAToast *toast;

/// The available size for the toast.
@property (nonatomic, readonly) CGSize availableSize;

/// The calculated size of the toast.
@property (nonatomic, readonly) CGSize size;

#pragma mark - Initialization

/**
 Initialize the view with the toast.

 @param toast Toast to be used with the view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithToast:(RAToast *)toast;

- (id)init __unavailable;

- (id)initWithFrame:(CGRect)frame __unavailable;

- (id)initWithCoder:(NSCoder *)aDecoder __unavailable;

#pragma mark - Layout

/**
 Configure the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)setupView;

/**
 Calculate the size and position of the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)updateView;

@end