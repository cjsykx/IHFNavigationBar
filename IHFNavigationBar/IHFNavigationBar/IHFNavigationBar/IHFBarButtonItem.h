//
//  IHFBarButtonItem.h
//  IHFNavigationBar
//
//  Created by chenjiasong on 16/9/21.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHFBarButtonItem : UIButton

/**
 Returns a bar button item which is specified image and the specified target do your custom action.
 @ image : The image for the item .
 */

- (instancetype)initWithImage:(UIImage *)image  target:(id)target action:(SEL)action;

/**
 Returns a bar button item which is specified image and the specified target do your custom action.
 @ title : The title for the item .
 */

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@property (copy, nonatomic, readonly) NSString *title; /**< The item title ,the color can change by titleColor */
@property (strong, nonatomic, readonly) UIImage *image; /**< The item image */

@property (strong, nonatomic) UIColor *titleColor; /**< The item title color */

@end
