//
//  RAToastView.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAToast.h"

/**
 Handles everything related to the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView : UIView

/// Text to be displayed with the toast.
@property (nonatomic) NSString *text;

#pragma mark - Initialization

/**
 Initialize the toast view with the gravity, i.e. the position of the toast.

 @param gravity Gravity of the toast.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithGravity:(RAToastGravity)gravity;

#pragma mark - Layout

/**
 Calculates the position and the size of the related views.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)updateView;

#pragma mark - Animation

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)animateWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end