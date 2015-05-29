//
//  GGCamera.h
//  __无邪_
//
//  Created by __无邪_ on 15/4/28.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGCamera;


@protocol GGCameraDelegate <NSObject>

- (void)camera:(GGCamera *)camera didFinishPickingMediaWithImage:(UIImage *)image;

@end
@interface GGCamera : NSObject
@property (nonatomic, unsafe_unretained) id<GGCameraDelegate>delegate;
@property (nonatomic, strong) void(^resultBlock)(UIImage *image);
+ (instancetype)sharedInstance;

- (void)showCamera;
- (void)showCameraResult:(void(^)(UIImage *image))resultBlock; /*  */
- (void)showCameraResultWithUrl:(void (^)(NSString *imageurl))resultBlock;


- (void)showOnlyCameraResult:(void (^)(UIImage *image))resultBlock;
- (void)showLocalPictureResult:(void (^)(UIImage *image))resultBlock;

@end
