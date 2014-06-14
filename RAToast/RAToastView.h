//
//  RAToastView.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAToast.h"

@interface RAToastView : UIView

@property (nonatomic) NSString *text;

- (instancetype)initWithGravity:(RAToastGravity)gravity;

- (void)updateView;

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)animateWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end