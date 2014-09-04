//
//  RAToastView.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAToast.h"
#import "RAToastAnimationDelegate.h"

/// The margin between the screen edges and the toast view.
extern const NSInteger RAToastViewMargin;

/// The animation duration for displaying and hiding the toast view.
extern const RAToastDuration RAToastAnimationDuration;

/// The animation delay for displaying and hiding the toast view.
extern const RAToastDuration RAToastAnimationDelay;

/**
 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@interface RAToastView : UIView <RAToastAnimationDelegate> {
@protected
	BOOL _enableTapUserInteraction;
	BOOL _enableSwipeUserInteraction;

	void (^_preShowAnimationStateBlock)(RAToastView *view);

	void (^_showAnimationStateBlock)(RAToastView *view);

	void (^_postShowAnimationStateBlock)(RAToastView *view);

	void (^_preHideAnimationStateBlock)(RAToastView *view);

	void (^_hideAnimationStateBlock)(RAToastView *view);

	void (^_postHideAnimationStateBlock)(RAToastView *view);
}

/// Reference to the toast initializer.
@property (readonly) RAToast *toast;

/// Available screen space including the view margin.
@property (nonatomic, readonly) CGSize availableSize;

/// The actual size of the toast, re-calculated on each call.
@property (nonatomic, readonly) CGSize size;

#pragma mark - Initialization

/**
 Initialize the view with the toast.

 @param toast Toast to be used with the view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (instancetype)initWithToast:(RAToast *)toast;

/// Disabled, use `initWithToast:`.
- (id)init __unavailable;

/// Disabled, use `initWithToast:`.
- (id)initWithFrame:(CGRect)frame __unavailable;

/// Disabled, use `initWithToast:`.
- (id)initWithCoder:(NSCoder *)aDecoder __unavailable;

#pragma mark - Layout

/**
 Configure the toast view and setup the gesture recognizers.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)setupView;

/**
 Calculate the size and position of the toast view.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
- (void)updateView;

#pragma mark - Animation

/**
 Hide the toast view with animation state.

 @param animation Animation state to be used to hide the toast.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 Triggers both the pre/post hide state, if the view reponds to the selectors.
 */
- (void)performHideWithAnimation:(void (^)(void))animation;

#pragma mark -- Block

- (void)setPreShowAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)preShowAnimationStateBlock;

- (void)setShowAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)showAnimationStateBlock;

- (void)setPostShowAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)postShowAnimationStateBlock;

- (void)setPreHideAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)preHideAnimationStateBlock;

- (void)setHideAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)hideAnimationStateBlock;

- (void)setPostHideAnimationStateBlock:(RAToastAnimationStateBlock)block;

- (RAToastAnimationStateBlock)postHideAnimationStateBlock;

#pragma mark - User interaction

/// Enable or disable the tap user interaction on the toast.
@property (getter = isTapUserInteractionEnabled) BOOL enableTapUserInteraction;

/// Enable or disable the swipe user interaction on the toast.
@property (getter = isSwipeUserInteractionEnabled) BOOL enableSwipeUserInteraction;

@end