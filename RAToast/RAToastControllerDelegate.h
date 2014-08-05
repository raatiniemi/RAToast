//
//  RAToastControllerDelegate.h
//  RAToast
//
//  Created by Tobias Raatiniemi on 2014-08-05.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Delegate for managing toast controller.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>
 */
@protocol RAToastControllerDelegate <NSObject>

@optional

/**
 Get the controller for the toast.

 @return Toast controller or `nil`.

 @author Tobias Raatiniemi <raatiniemi@gmail.com>

 @note
 This method should be implemented with the desired toast controller is not the
 root view controller retrieved from the shared application.
 */
- (UIViewController *)getToastController;

@end