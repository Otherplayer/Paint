//
//  UINavigationController+VMAdditions.h
//  VMark
//
//  Created by __无邪_ on 15/3/2.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (VMAdditions)
- (void)applyAppDefaultApprence;
- (void)applyApprenceWithBarTintColor:(UIColor *)tintColor fontColor:(UIColor *)fontColor;

- (void)setHide:(BOOL)hide;
@end
