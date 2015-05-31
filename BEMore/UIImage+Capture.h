//
//  UIImage+Capture.h
//  IOS-Categories
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)
+ (UIImage *)captureWithView:(UIView *)view;

+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;
+ (UIImage *)imageFromView2: (UIView *) theView   atFrame:(CGRect)r;
@end
