# IHFNavigationBar

IHFNavigationBar 是一个自定义导航条，当你不想使用系统自带的导航栏时，就可以轻松接入IHFNavigationBar代替系统的导航条了。
简书地址 : http://www.jianshu.com/p/96d8bb77813a


****
使用方法
****

####1.导入： #import "IHFNavigationBar.h"####
####2.创建Title####
创建导航栏标题和标题颜色
```
self.navigationBar.title = @"首页";
self.navigationBar.titleColor = [UIColor lightGrayColor];
```
####3.根据需求是否创建LeftBarButtonItem,默认POP####

如果不创建,类似系统导航栏，默认是向左箭头和返回到前一个控制器。
如果创建,类似系统导航栏，有一下2个办法：
- 方法1.设置IHFLeftBarButtonItemAction:

IHFLeftBarButtonItemActionOfPop:也就是默认是向左箭头和返回到前一个控制器。
IHFLeftBarButtonItemActionOfShowSideBar：显示侧边栏，默认是菜单图标。
>IHFLeftBarButtonItemActionOfShowSideBar是IHFSideBar[简书地址](http://www.jianshu.com/p/792e4a80b611),需要设置sideBarContentView，也就是侧边栏里面的内容视图。
默认图标可以使用leftBarTintColor修改颜色，默认是蓝色。


- 方法2. 使用leftBarButtonItem
需要自己定义IHFBarButtonItem，设置Title或者Image 还有响应方法 

```
IHFBarButtonItem *item1 = [[IHFBarButtonItem alloc] initWithTitle:@"返回" target:self action:@selector(didClick:)];
self.navigationBar.leftBarButtonItem = item1;
```
####3.根据需求是否创建RightBarButtonItem,默认为空####

如果需要RightBarButtonItem，则也要自己定义IHFBarButtonItem。
- 可以加入一个（rightBarButtonItem）

```
IHFBarButtonItem *item1 = [[IHFBarButtonItem alloc] initWithTitle:@"返回" target:self action:@selector(didClick:)];
self.navigationBar.rightBarButtonItem = item1;
```

- 可以加入多个（rightBarButtonItems）

```
IHFBarButtonItem *item1 = [[IHFBarButtonItem alloc] initWithTitle:@"游记" target:self action:@selector(didClick:)];
IHFBarButtonItem *item2 = [[IHFBarButtonItem alloc] initWithTitle:@"右边" target:self action:@selector(didClick:)];
self.navigationBar.rightBarButtonItems = [NSArray arrayWithObjects:item1,item2, nil];
```