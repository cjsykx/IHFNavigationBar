//
//  IHFNavigationBar.m
//  NurseV2
//
//  Created by chenjiasong on 16/8/15.
//  Copyright © 2016年 IHEFE CO., LIMITED. All rights reserved.
//

#import "IHFNavigationBar.h"
#import <objc/runtime.h>

@interface IHFNavigationBar()

@property (weak,nonatomic)UILabel *titleLabel;
@end

@implementation IHFNavigationBar

#pragma mark - system method
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.leftBarTintColor = [UIColor blueColor]; // Defalut Lert
        
        CGRect currentScreenFrame = [[UIScreen mainScreen] bounds];
        // head view frame
        CGFloat headViewX = 0;
        CGFloat headViewY = 0;
        CGFloat headViewW = currentScreenFrame.size.width;
        CGFloat headViewH = 64; // default height
        
        self.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
        
        // create a line
        UIView *line = [[UIView alloc] init];
        CGFloat lineW = headViewW;
        CGFloat lineH = 1; // default height
        CGFloat lineX = 0;
        CGFloat lineY = headViewH - lineH;
        
        line.backgroundColor = [UIColor colorWithRed:166 / 255.0 green:174 / 255.0 blue:189 / 255.0 alpha:0.5];
        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        [self addSubview:line];
        
        // Left bar button item
        IHFBarButtonItem *defaultBackBtn = [[IHFBarButtonItem alloc] init];
        [self addSubview:defaultBackBtn];
        _leftBarButtonItem = defaultBackBtn;

        self.leftBarButtonItemAction = IHFLeftBarButtonItemActionOfPop;
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;

    // titleLabel frame
    CGFloat titleLabelW = 200;
    CGFloat titleLabelH = 24;
    CGFloat titleLabelX = (selfW - titleLabelW) * 0.5;
    CGFloat titleLabelY = (selfH - titleLabelH) * 0.5 + 10;
    
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // leftBarButtonItem frame
    CGFloat margin = 10;
    CGFloat leftBarButtonX = margin;
    CGFloat leftBarButtonY = 20; // 20 is status bar height
    CGFloat leftBarButtonH = 44; // 44 is navagation bar height 
    CGFloat leftBarButtonW = 44;
    
    _leftBarButtonItem.frame = CGRectMake(leftBarButtonX, leftBarButtonY, leftBarButtonW, leftBarButtonH);
    
    //rightBarButtons frame
    CGFloat rightBarButtonH = 44;
    CGFloat rightBarButtonW = 44;
    NSInteger count = [_rightBarButtonItems count];
    
    [_rightBarButtonItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat rightBarButtonX = selfW - ((rightBarButtonW + margin) * (count - idx));
        CGFloat rightBarButtonY = leftBarButtonY;
        obj.frame = CGRectMake(rightBarButtonX, rightBarButtonY, rightBarButtonW, rightBarButtonH);
    }];
}

#pragma mark - setter AND getter
- (void)setTitle:(NSString *)title {
    
    if (_title == title) return;
    
    [_titleLabel removeFromSuperview];
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)setLeftBarButtonItem:(IHFBarButtonItem *)leftBarButtonItem {
    
    [_leftBarButtonItem removeFromSuperview];
    
    _leftBarButtonItem = leftBarButtonItem;
    [self addSubview:_leftBarButtonItem];
    
    // If use call the method , means , it will use custom method!
    self.leftBarButtonItemAction = IHFLeftBarButtonItemActionOfCustomMethod;
}

- (void)setLeftBarButtonItemAction:(IHFLeftBarButtonItemAction)leftBarButtonItemAction {
    
    if (_leftBarButtonItemAction == leftBarButtonItemAction) return;
    _leftBarButtonItemAction = leftBarButtonItemAction;
    
    if (leftBarButtonItemAction == IHFLeftBarButtonItemActionOfCustomMethod) {
        [_leftBarButtonItem removeTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if(leftBarButtonItemAction == IHFLeftBarButtonItemActionOfPop) {
        [_leftBarButtonItem setImage:[self imageForArrowWithTintColor:self.leftBarTintColor] forState:UIControlStateNormal];
        [_leftBarButtonItem addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if (leftBarButtonItemAction == IHFLeftBarButtonItemActionOfShowSideBar) {
        [_leftBarButtonItem setImage:[self imageForMenuWithTintColor:self.leftBarTintColor] forState:UIControlStateNormal];
        [_leftBarButtonItem addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setRightBarButtonItem:(IHFBarButtonItem *)rightBarButtonItem {
    
    _rightBarButtonItem = rightBarButtonItem;
    self.rightBarButtonItems = [NSArray arrayWithObject:rightBarButtonItem];
}

- (void)setRightBarButtonItems:(NSArray<IHFBarButtonItem *> *)rightBarButtonItems {
    
    [_rightBarButtonItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IHFBarButtonItem class]]) {
            [obj removeFromSuperview];
        } else {
            NSAssert([obj isKindOfClass:[IHFBarButtonItem class]], @"rightBarButtonItems must contain UIButton Class Object");
        }
    }];
    
    _rightBarButtonItems = rightBarButtonItems;
    
    __weak typeof(self) weakSelf = self;
    [rightBarButtonItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IHFBarButtonItem class]]) {
            [weakSelf addSubview:obj];
        } else {
            NSAssert([obj isKindOfClass:[IHFBarButtonItem class]], @"rightBarButtonItems must contain UIButton Class Object");
        }
    }];
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    if (_titleColor == titleColor) return;
    
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        // create title label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    
    return _titleLabel;
}

- (IHFSideBar *)sideBar {
    
    if (!_sideBar) {
        _sideBar = [[IHFSideBar alloc] initWithIsShowFromRight:NO];
        [_sideBar setContentView:self.sideBarContentView];
    }
    return _sideBar;
}

- (void)setLeftBarTintColor:(UIColor *)leftBarTintColor {
    
    if (_leftBarTintColor == leftBarTintColor) return;
    _leftBarTintColor = leftBarTintColor;
    
    if (_leftBarButtonItemAction == IHFLeftBarButtonItemActionOfPop) {
        [_leftBarButtonItem setImage:[self imageForArrowWithTintColor:leftBarTintColor] forState:UIControlStateNormal];
    } else if(_leftBarButtonItemAction == IHFLeftBarButtonItemActionOfShowSideBar) {
        [_leftBarButtonItem setImage:[self imageForMenuWithTintColor:leftBarTintColor] forState:UIControlStateNormal];
    }
}

#pragma mark - custom method

- (UIImage *)imageForMenuWithTintColor:(UIColor *)tintColor {
    
    CGSize menuSize = CGSizeMake(44, 44);
    CGSize zise = CGSizeMake(24, 17);
    CGFloat thickness = 2;
    
    return [self imageForMenuWithImageSize:menuSize size:zise offset:CGPointMake(-1.f, -1.f) rotate:0.f thickness:thickness dotted:YES dotsCornerRadius:thickness * 0.5 linesCornerRadius:thickness * 0.5 backgroundColor:[UIColor clearColor] fillColor:tintColor];
}

- (UIImage *)imageForArrowWithTintColor:(UIColor *)tintColor {
    
    CGSize menuSize = CGSizeMake(44, 44);
    CGSize zise = CGSizeMake(44 * 0.4, 44 * 0.5);
    CGFloat thickness = 2;
    
    return [self imageForArrowWithImageSize:menuSize size:zise offset:CGPointMake(-1, -1) rotate:0.f thickness:thickness backgroundColor:[UIColor clearColor] color:tintColor];
}


#pragma mark - btn action
- (void)leftBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickLeftBarButtonItem:)]) {
        [self.delegate navigationBar:self didClickLeftBarButtonItem:sender];
    }
}

- (void)rightBtnClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickRightBarButtonItem:)]) {
        [self.delegate navigationBar:self didClickRightBarButtonItem:sender];
    }
}

#pragma mark - support tool

- (UIImage *)imageForMenuWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                            dotted:(BOOL)dotted
                  dotsCornerRadius:(CGFloat)dotsCornerRadius
                 linesCornerRadius:(CGFloat)linesCornerRadius
                   backgroundColor:(UIColor *)backgroundColor
                         fillColor:(UIColor *)fillColor {
    
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    
    // BACKGROUND -----
    
    if (backgroundNeeded) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }
    
    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);
    
    UIBezierPath *path = [UIBezierPath new];
    
    CGFloat originX = rect.origin.x;
    CGFloat sizeWidth = rect.size.width;
    
    if (dotted) {
        originX = rect.origin.x + thickness * 1.5;
        sizeWidth -= thickness * 1.5;
    }
    
    {
        CGRect rect1 = CGRectMake(originX, rect.origin.y, sizeWidth, thickness);
        CGRect rect2 = CGRectMake(originX, rect.origin.y+rect.size.height/2-thickness/2, sizeWidth, thickness);
        CGRect rect3 = CGRectMake(originX, rect.origin.y+rect.size.height-thickness, sizeWidth, thickness);
        
        UIBezierPath *line1;
        UIBezierPath *line2;
        UIBezierPath *line3;
        
        if (dotsCornerRadius) {
            line1 = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:linesCornerRadius];
            line2 = [UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:linesCornerRadius];
            line3 = [UIBezierPath bezierPathWithRoundedRect:rect3 cornerRadius:linesCornerRadius];
        } else {
            line1 = [UIBezierPath bezierPathWithRect:rect1];
            line2 = [UIBezierPath bezierPathWithRect:rect2];
            line3 = [UIBezierPath bezierPathWithRect:rect3];
        }
        
        [path appendPath:line1];
        [path appendPath:line2];
        [path appendPath:line3];
    }
    
    if (dotted) {
        CGRect rect1 = CGRectMake(rect.origin.x, rect.origin.y, thickness, thickness);
        CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2-thickness/2, thickness, thickness);
        CGRect rect3 = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height-thickness, thickness, thickness);
        
        UIBezierPath *dot1;
        UIBezierPath *dot2;
        UIBezierPath *dot3;
        
        if (dotsCornerRadius) {
            dot1 = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:dotsCornerRadius];
            dot2 = [UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:dotsCornerRadius];
            dot3 = [UIBezierPath bezierPathWithRoundedRect:rect3 cornerRadius:dotsCornerRadius];
        } else {
            dot1 = [UIBezierPath bezierPathWithRect:rect1];
            dot2 = [UIBezierPath bezierPathWithRect:rect2];
            dot3 = [UIBezierPath bezierPathWithRect:rect3];
        }
        
        [path appendPath:dot1];
        [path appendPath:dot2];
        [path appendPath:dot3];
    }
    
    if (fillNeeded) {
        [fillColor setFill];
        [path fill];
    }

    // MAKE UIImage -----
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageForArrowWithImageSize:(CGSize)imageSize
                               size:(CGSize)size
                             offset:(CGPoint)offset
                             rotate:(CGFloat)degrees
                          thickness:(CGFloat)thickness
                    backgroundColor:(UIColor *)backgroundColor
                              color:(UIColor *)color {
    
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    
    if (backgroundNeeded) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }
    
    
    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);
    
    CGPoint topCenter = CGPointZero;
    CGPoint bottomLeft = CGPointZero;
    CGPoint bottomRight = CGPointZero;
    
    // Default left
    topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/2);
    bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
    bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
    
    UIBezierPath *path = [UIBezierPath new];
    
    [path moveToPoint:bottomLeft];
    [path addLineToPoint:topCenter];
    [path addLineToPoint:bottomRight];
    
    // -----
    
    if (degrees) {
        CGRect originalBounds = path.bounds;
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(degrees * M_PI / 180);
        [path applyTransform:rotate];
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }
    
    path.lineWidth = thickness;
    
    // -----
    
    [color setStroke];
    [path stroke];
    
    // MAKE UIImage -----
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end


//************************ View controller catagory *****************************
static const void *IHFNavigationBarKey = &IHFNavigationBarKey;
@interface UIViewController ()<IHFNavigationBarDelegate,IHFSideBarDelegate>

@end
@implementation UIViewController (IHFNavigationBar)

- (IHFNavigationBar *)navigationBar {
    
    IHFNavigationBar *bar = objc_getAssociatedObject(self, &IHFNavigationBarKey);
    
    if (!bar) {
        bar = [[IHFNavigationBar alloc] init];
        [self.view addSubview:bar];
        bar.delegate = self;
        objc_setAssociatedObject(self, &IHFNavigationBarKey, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return bar;
}

- (void)setNavigationBar:(IHFNavigationBar *)navigationBar {
    objc_setAssociatedObject(self, &IHFNavigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)navigationBar:(IHFNavigationBar *)bar didClickLeftBarButtonItem:(UIButton *)leftBarButtonItem {
    
    if(bar.leftBarButtonItemAction == IHFLeftBarButtonItemActionOfPop) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (bar.leftBarButtonItemAction == IHFLeftBarButtonItemActionOfShowSideBar) {
        [self.navigationBar.sideBar show];
    }
}

@end

