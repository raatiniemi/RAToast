//
//  RAToastOperation.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-06-14.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RAToast.h"
#import "RAToastView.h"

typedef NS_ENUM(short int, RAToastOperationStatus) {
	RAToastOperationStatusReady,
	RAToastOperationStatusExecuting,
	RAToastOperationStatusFinished
};

@interface RAToastOperation : NSOperation

- (instancetype)initWithToast:(RAToast *)toast;

@end