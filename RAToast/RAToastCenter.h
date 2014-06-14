//
//  RAToastCenter.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAToastOperation;

@interface RAToastCenter : NSObject

+ (instancetype)defaultCenter;

- (void)deviceOrientationDidChange:(id)sender;

- (void)addToast:(RAToastOperation *)toast;

@end