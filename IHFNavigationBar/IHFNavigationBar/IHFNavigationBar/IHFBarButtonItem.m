//
//  IHFBarButtonItem.m
//  IHFNavigationBar
//
//  Created by chenjiasong on 16/9/21.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "IHFBarButtonItem.h"

@implementation IHFBarButtonItem

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    self = [super init];
    
    if (self) {
        _title = title;
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    
    self = [super init];
    
    if (self) {
        _image = image;
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setParameters];
    }
    return self;
}

#pragma mark - custom method

- (void)setParameters {
    self.titleColor = [UIColor blueColor];
}

#pragma mark - setter and getter

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor == titleColor) return;
    _titleColor = titleColor;
    
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
}

@end
