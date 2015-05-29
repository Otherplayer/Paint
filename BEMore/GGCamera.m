//
//  GGCamera.m
//  __无邪_
//
//  Created by __无邪_ on 15/4/28.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "GGCamera.h"


#import "AppDelegate.h"
#import <objc/runtime.h>

#define kTitle @"title"
#define kSourceType @"sourcetype"
static const char GGCameraDidFinishPickerImage;
static const char GGCameraDidFinishPickerImageUrl;

@interface GGCamera ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)NSMutableArray *items;
@end

@implementation GGCamera

+ (instancetype)sharedInstance{
    static GGCamera *camera = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        camera = [[GGCamera alloc] init];
        camera.items = [[NSMutableArray alloc] init];
    });
    return camera;
}

#pragma mark - 摄像头和相册相关的公共类

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

//// 检查摄像头是否支持录像
//- (BOOL) doesCameraSupportShootingVideos{
//    return [self cameraSupportsMedia:(NSString *)kUTTypeMoviesourceType:UIImagePickerControllerSourceTypeCamera];
//}
//
//// 检查摄像头是否支持拍照
//- (BOOL) doesCameraSupportTakingPhotos{
//    return [self cameraSupportsMedia:(NSString *)kUTTypeImagesourceType:UIImagePickerControllerSourceTypeCamera];
//}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}


// 是否可以在相册中选择视频
//- (BOOL) canUserPickVideosFromPhotoLibrary{
//    return [self cameraSupportsMedia:(NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}

// 是否可以在相册中选择视频
//- (BOOL) canUserPickPhotosFromPhotoLibrary{
//    return [self cameraSupportsMedia:kCIAttributeTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//
//    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}


#pragma mark - Function

- (void)showCamera{
    BOOL photoLibraryAvailable = [self isPhotoLibraryAvailable];
    BOOL rearCameraAvailable = [self isRearCameraAvailable];
    
    [self.items removeAllObjects];
    
    if (rearCameraAvailable) {
        [self.items addObject:@{kTitle:@"拍照",kSourceType:@(UIImagePickerControllerSourceTypeCamera)}];
    }
    if (photoLibraryAvailable) {
        [self.items addObject:@{kTitle:@"从相册选择",kSourceType:@(UIImagePickerControllerSourceTypePhotoLibrary)}];
    }
    
    
    UIActionSheet *actionSheet;
    if (0 == self.items.count) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Device Unavailable" otherButtonTitles:nil];
    }else if (1 == self.items.count){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:[self.items[0] objectForKey:kTitle] otherButtonTitles:nil];
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:[self.items[0] objectForKey:kTitle] otherButtonTitles:[self.items[1] objectForKey:kTitle],nil];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [actionSheet setDelegate:self];
    [actionSheet showInView:window];
}

#pragma mark - Delegate ActionSheets
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (0 == self.items.count || buttonIndex >= self.items.count) {
        return;
    }
    
    NSDictionary *dic = [self.items objectAtIndex:buttonIndex];
    NSUInteger sourceType = [[dic objectForKey:kSourceType] integerValue];
    
    // 延迟3毫秒,iOS 7 bug of Snapshotting a view that has not been rendered results...
    double delayInSeconds = 0.3;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    // 得到全局队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 延期执行
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [self showCameraWithSourceType:sourceType];
    });
    
}

- (void)showCameraWithSourceType:(NSUInteger)sourceType{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    
    
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = [[appdelegate window] rootViewController];
    [rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
    
}


#pragma mark - Delegate Methods of imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    double delayInSeconds = 0.5;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    // 得到全局队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 延期执行
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        if ([_delegate respondsToSelector:@selector(camera:didFinishPickingMediaWithImage:)]) {
            [_delegate camera:self didFinishPickingMediaWithImage:image];
        }
        if (self.resultBlock) {
            self.resultBlock(image);
        }
        
        void (^block)(UIImage *img) = objc_getAssociatedObject(self, &GGCameraDidFinishPickerImage);
        if (block) block(image);
        
        // 拍照时保存
        /*if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
         }*/
        
        NSDate *date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHMMSS"];
        NSString* imageName = [formatter stringFromDate:date];
        [self saveImage:image withName:imageName];
        
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}

- (void)showCameraResult:(void (^)(UIImage *))resultBlock{
    
    [self showCamera];
    objc_setAssociatedObject(self, &GGCameraDidFinishPickerImage, resultBlock, OBJC_ASSOCIATION_COPY);
    
}

- (void)showOnlyCameraResult:(void (^)(UIImage *image))resultBlock{
    BOOL photoLibraryAvailable = [self isPhotoLibraryAvailable];
    BOOL rearCameraAvailable = [self isRearCameraAvailable];
    
    [self.items removeAllObjects];
    
    if (rearCameraAvailable) {
        [self.items addObject:@{kTitle:@"拍照",kSourceType:@(UIImagePickerControllerSourceTypeCamera)}];
    }
    if (photoLibraryAvailable) {
        [self.items addObject:@{kTitle:@"从相册选择",kSourceType:@(UIImagePickerControllerSourceTypePhotoLibrary)}];
    }
    
    NSInteger buttonIndex = 0;
    

    NSDictionary *dic = [self.items objectAtIndex:buttonIndex];
    NSUInteger sourceType = [[dic objectForKey:kSourceType] integerValue];
    
//    // 延迟3毫秒,iOS 7 bug of Snapshotting a view that has not been rendered results...
//    double delayInSeconds = 0.3;
//    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    // 得到全局队列
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    // 延期执行
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//    });
    [self showCameraWithSourceType:sourceType];
    
    
    objc_setAssociatedObject(self, &GGCameraDidFinishPickerImage, resultBlock, OBJC_ASSOCIATION_COPY);
    
}

- (void)showLocalPictureResult:(void (^)(UIImage *image))resultBlock{
    BOOL photoLibraryAvailable = [self isPhotoLibraryAvailable];
    BOOL rearCameraAvailable = [self isRearCameraAvailable];
    
    [self.items removeAllObjects];
    
    if (rearCameraAvailable) {
        [self.items addObject:@{kTitle:@"拍照",kSourceType:@(UIImagePickerControllerSourceTypeCamera)}];
    }
    if (photoLibraryAvailable) {
        [self.items addObject:@{kTitle:@"从相册选择",kSourceType:@(UIImagePickerControllerSourceTypePhotoLibrary)}];
    }
    
    NSInteger buttonIndex = 1;
    
    
    NSDictionary *dic = [self.items objectAtIndex:buttonIndex];
    NSUInteger sourceType = [[dic objectForKey:kSourceType] integerValue];
    
    //    // 延迟3毫秒,iOS 7 bug of Snapshotting a view that has not been rendered results...
    //    double delayInSeconds = 0.3;
    //    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    // 得到全局队列
    //    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    // 延期执行
    //    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
    //    });
    [self showCameraWithSourceType:sourceType];
    
    objc_setAssociatedObject(self, &GGCameraDidFinishPickerImage, resultBlock, OBJC_ASSOCIATION_COPY);
}



- (void)showCameraResultWithUrl:(void (^)(NSString *imageurl))resultBlock{
    [self showCamera];
    objc_setAssociatedObject(self, &GGCameraDidFinishPickerImageUrl, resultBlock, OBJC_ASSOCIATION_COPY);
}

// 保存到本地
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:YES];
    
    void (^block)(NSString *imgurl) = objc_getAssociatedObject(self, &GGCameraDidFinishPickerImageUrl);
    if (block) block(imageName);
}

// 保存到相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
