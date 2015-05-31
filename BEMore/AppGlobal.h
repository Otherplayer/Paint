//
//  AppGlobal.h
//  BEMore
//
//  Created by __无邪_ on 15/5/28.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#ifndef BEMore_AppGlobal_h
#define BEMore_AppGlobal_h



#import "BMCategories-Header.h"

#define BEScreenWidth [[UIScreen mainScreen] bounds].size.width
#define BEScreenHeight [[UIScreen mainScreen] bounds].size.height


#define WS(weakSelf)          __weak __typeof(&*self)weakSelf = self;



#define IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480.0f)
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568.0f)
#define IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height == 667.0f)//375w
#define IS_IPHONE6_PLUS ([UIScreen mainScreen].bounds.size.height == 736.0f)//414w


#endif
