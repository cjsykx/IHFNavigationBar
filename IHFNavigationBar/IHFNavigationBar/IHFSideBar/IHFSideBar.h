//
//  IHFSideBar.h
//  IHFSideBar
//
//  Created by chenjiasong on 16/8/17.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IHFSideBar;
@protocol IHFSideBarDelegate <NSObject>
@optional
- (void)sideBar:(IHFSideBar *)sideBar didAppear:(BOOL)animated;
- (void)sideBar:(IHFSideBar *)sideBar willAppear:(BOOL)animated;
- (void)sideBar:(IHFSideBar *)sideBar didDisappear:(BOOL)animated;
- (void)sideBar:(IHFSideBar *)sideBar willDisappear:(BOOL)animated;

@end

@interface IHFSideBar : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, assign) CGFloat animationDuration;  /**< Default 0.25 , can change it to fit your project */
@property (nonatomic, assign, readonly, getter=isHasShown) BOOL hasShown; /**< is side bar has shown */
@property (nonatomic, assign, readonly, getter=isShowFromRight) BOOL showFromRight; /**< is side bar show from direction , if NOT , from Left , else from right */

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, weak) id <IHFSideBarDelegate> delegate;

/**
 init  !
 @ Defalut showFrom left!
 */
- (instancetype)init;

/**
 init  !
 @ showFromRight showPostion : NO -> From left  .  YES -> from right!
 */
- (instancetype)initWithIsShowFromRight:(BOOL)showFromRight;

/**
 show the side bar with animation!
 @ Defalut show in key window , and animated yes!
 */
- (void)show;

/**
 show the side bar !
 @ animated : if you need animated!
 @ Defalut show in key window!
 */
- (void)showAnimated:(BOOL)animated;

/**
 show the side bar !
 @ animated : if you need animated!
 @ controller : show in controller !
 */

- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

/**
 dismiss the side bar with animation!
 */

- (void)dismiss;

/**
 dismiss the side bar with animation!
 @ animated : if you need animated!
 */
- (void)dismissAnimated:(BOOL)animated;

/**
 set side bar content view!
 @ contentView : what you need to show in the content view .
 */
- (void)setContentView:(UIView *)contentView;

@end
