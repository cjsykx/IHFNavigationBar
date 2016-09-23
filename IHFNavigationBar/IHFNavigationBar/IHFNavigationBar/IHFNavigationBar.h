//
//  IHFNavigationBar.h
//  NurseV2
//
//  Created by chenjiasong on 16/8/15.
//  Copyright © 2016年 IHEFE CO., LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHFSideBar.h"
#import "IHFBarButtonItem.h"

typedef NS_OPTIONS(NSUInteger, IHFLeftBarButtonItemAction) {
    
    IHFLeftBarButtonItemActionOfCustomMethod      = 0x00, // The button custom by you ！
    IHFLeftBarButtonItemActionOfPop               = 0x01, // Default Pop to pervious controller
    IHFLeftBarButtonItemActionOfShowSideBar       = 0x02, // Show side bar , but you need set sideBarContentView !
};


@class IHFNavigationBar;
@protocol IHFNavigationBarDelegate <NSObject>

@optional

/**
 Tell delegate left bar button is did click
 
 Tips :
 @ If the type is IHFLeftBarButtonItemActionOfPop ,it default Pop to pervious controller , but you can do your would like to do instead of pop !
  @ If the type is IHFLeftBarButtonItemActionOfShowSideBar ,it default to show sidee bar , but you can do your would like to do instead of show sidee bar !
 @ If the type is IHFLeftBarButtonItemActionOfCustomMethod ,You can add target and action for left button method , or use the delegate !
 */

-(void)navigationBar:(IHFNavigationBar *)bar didClickLeftBarButtonItem:(UIButton *)leftBarButtonItem;

/**
 Tell delegate right bar button is did click
 
 Tips : You can add target and action for right button method , or use the delegate !
 */

-(void)navigationBar:(IHFNavigationBar *)bar didClickRightBarButtonItem:(UIButton *)rightBarButtonItem;

@end

@interface IHFNavigationBar : UIView

// -------------------- Title

@property (copy, nonatomic) NSString *title; /**< title for the controller */
@property (strong, nonatomic) UIColor *titleColor; /**< Default black , can change the title color would you like */

// -------------------- Left bar button item

@property (weak, nonatomic) IHFBarButtonItem *leftBarButtonItem;
@property (assign, nonatomic) IHFLeftBarButtonItemAction leftBarButtonItemAction;
@property (strong, nonatomic) IHFSideBar *sideBar;
@property (strong, nonatomic) UIView *sideBarContentView ;  /**< If the type is side Bar , you need set the content view you would like to display  */

@property (strong, nonatomic) UIColor *leftBarTintColor ;  /**< Default blue. It Only take effect on type of POP or SideBar , to change image color . */

// -------------------- Right bar button item

@property (weak, nonatomic) IHFBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) NSArray <IHFBarButtonItem *> *rightBarButtonItems; /**< Contain right bar button items to show  */

// -------------------- Delegate

@property (weak, nonatomic) id <IHFNavigationBarDelegate> delegate; /**< To be delete for IHFNavigationBar */

@end


//***************************** View controller catagory ***********************
@interface UIViewController (IHFNavigationBar)

@property (strong,nonatomic) IHFNavigationBar *navigationBar; /**< Navigation bar auto add in the view */

@end

