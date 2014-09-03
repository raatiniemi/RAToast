//
//  RAToastAnimationDelegate.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-08-30.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Block definition for the animation completion handler.
typedef void(^RAToastAnimationCompletion)(BOOL finished);

/// Block definition for the animation state block callback.
typedef void(^RAToastAnimationStateBlock)(void);

/// Selector for the `preShowAnimationState`-method.
#define kRAToastPreShowAnimationStateSelector @selector(preShowAnimationState)

/// Selector for the `showAnimationState`-method.
#define kRAToastShowAnimationStateSelector @selector(showAnimationState)

/// Selector for the `postShowAnimationState`-method.
#define kRAToastPostShowAnimationStateSelector @selector(postShowAnimationState)

/// Selector for the `preHideAnimationState`-method.
#define kRAToastPreHideAnimationStateSelector @selector(preHideAnimationState)

/// Selector for the `hideAnimationState`-method.
#define kRAToastHideAnimationStateSelector @selector(hideAnimationState)

/// Selector for the `postHideAnimationState`-method.
#define kRAToastPostHideAnimationStateSelector @selector(postHideAnimationState)

/**
 Delegate for performing animation on toast views.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@protocol RAToastAnimationDelegate <NSObject>

@required

/**
 Animate the toast view with completion handler.

 @param completion Completion handler for the toast view animation.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 The completion handler is delegated from the `RAToastOperation` and handles the
 operation status change when the toast is finished. If the completion handler
 is not called the operation will not finish and will block additional toast.
 */
- (void)animateWithCompletion:(void (^)(BOOL finished))completion;

#pragma mark - Animation state

#pragma mark -- Show

/**
 Configure the pre-show animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)preShowAnimationState;

/**
 Configure the show animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)showAnimationState;

@optional

/**
 Configure the post-show animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)postShowAnimationState;

#pragma mark -- Hide

/**
 Configure the pre-hide animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)preHideAnimationState;

@required

/**
 Configure the hide animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)hideAnimationState;

@optional

/**
 Configure the post-hide animation state.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)postHideAnimationState;

@end