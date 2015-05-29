//
//  BEFunctionView.h
//  BEMore
//
//  Created by __无邪_ on 15/5/29.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEFunctionView : UIView

@property (nonatomic, strong)void(^mainFunctionButtonClickedBlock)(NSInteger index);
@property (nonatomic, strong)void(^colorSelectedBlock)(NSInteger colorIndex);
@property (nonatomic, strong)void(^eraserDidClickedBlock)();
@property (nonatomic, strong)void(^paintDidClickedBlock)();
@property (nonatomic, strong)void(^cameraDidClickedBlock)(NSInteger index);

@end
