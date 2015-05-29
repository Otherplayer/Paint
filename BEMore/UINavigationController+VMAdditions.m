//
//  UINavigationController+VMAdditions.m
//  VMark
//
//  Created by __无邪_ on 15/3/2.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "UINavigationController+VMAdditions.h"

@implementation UINavigationController (VMAdditions)

- (void)applyAppDefaultApprence{
    [self applyApprenceWithBarTintColor:[UIColor blueColor] fontColor:[UIColor whiteColor]];
}

- (void)applyApprenceWithBarTintColor:(UIColor *)tintColor fontColor:(UIColor *)fontColor{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UINavigationBar *navigationBar = self.navigationBar;
    
    [navigationBar setTitleTextAttributes:@{
                                            NSFontAttributeName : [UIFont systemFontOfSize:20.f],
                                            NSForegroundColorAttributeName : fontColor,
                                            }];
    [navigationBar setTintColor:fontColor];    //设置字体颜色
    
    [navigationBar setBarTintColor:tintColor]; //设置背景色
    [navigationBar setTranslucent:YES];        //关透明
}

- (void)setHide:(BOOL)hide{
    [self setNavigationBarHidden:hide animated:YES];
}

@end
