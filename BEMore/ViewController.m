//
//  ViewController.m
//  BEMore
//
//  Created by __无邪_ on 15/5/28.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "BEFunctionView.h"
#import "GGCamera.h"
#import "VMProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "MTAnimatedLabel.h"

@interface ViewController (){
    BOOL functionViewIsHidden;
    UISegmentedControl* WidthButton;
    UISegmentedControl* ColorButton;
    
    CGPoint MyBeganpoint;
    CGPoint MyMovepoint;
    int Segment;
    int SegmentWidth;
}

@property (nonatomic, strong)BEFunctionView *functionView;
@property (strong, nonatomic) UIImageView *backgroundImageView;//背景照片
@property (weak, nonatomic) IBOutlet UIView *paintView;//画布

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet MTAnimatedLabel *labelAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController applyAppDefaultApprence];
    [self.navigationController setHide:YES];
    
    CGFloat x = 20;
    CGFloat y = 95;
    CGFloat width = BEScreenWidth - x * 2;
    CGFloat height = BEScreenHeight - y - 150;
    
    if (IS_IPHONE6_PLUS) {
        x = 35;
        y = 95;
        width = BEScreenWidth - x * 2;
        height = BEScreenHeight - y - 150;
    }else if (IS_IPHONE6){
        x = 30;
        y = 90;
        width = BEScreenWidth - x * 2;
        height = BEScreenHeight - y - 140;
    }else if (IS_IPHONE5){
        x = 25;
        y = 77;
        width = BEScreenWidth - x * 2;
        height = BEScreenHeight - y - 115;
    }else{
        x = 25;
        y = 70;
        width = BEScreenWidth - x * 2;
        height = BEScreenHeight - y - 110;
    }
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.backgroundImageView];
    
    
    [self.paintView setHidden:YES];
    SegmentWidth = 8;
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22];
//        MTAnimatedLabel *label1 = [[MTAnimatedLabel alloc]initWithFrame:CGRectMake(100, 160, 300, 100)];
        [self.labelAnimation setTextColor:[UIColor blueColor]];
        [self.labelAnimation setFont:font];
        [self.labelAnimation setText:@"[Start here]"];
        [self.labelAnimation setTint:[UIColor cyanColor]];
        [self.labelAnimation startAnimating];
//        [self.view addSubview:label1];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startHereAction:)];
    [self.labelAnimation addGestureRecognizer:tapgesture];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    
    
    CGFloat heightOfFunctionView = BEScreenWidth / 3.0 * 2;
    
    if ([self.functionView isDescendantOfView:self.view]) {
        return;
    }
    
    self.functionView = [[BEFunctionView alloc] initWithFrame:CGRectMake(0, BEScreenHeight - heightOfFunctionView/2, BEScreenWidth, heightOfFunctionView)];
    [self.functionView setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:self.functionView];
    [self.functionView setHidden:YES];
    
    [self.view bringSubviewToFront:self.functionView];
    functionViewIsHidden = YES;
    
    WS(weakSelf);
    
    [self.functionView setMainFunctionButtonClickedBlock:^(NSInteger index) {

        
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.functionView setFrame:CGRectMake(0, BEScreenHeight - heightOfFunctionView, BEScreenWidth, heightOfFunctionView)];
            functionViewIsHidden = NO;
        }];
    }];
    
    
    //设置颜色
    [self.functionView setColorSelectedBlock:^(NSInteger colorIndex) {
        Segment = (int)colorIndex;
        SegmentWidth = 8;
    }];
    
    
    //擦
    [self.functionView setEraserDidClickedBlock:^{
        Segment = 10;
        SegmentWidth = 20;
    }];
    
    //笔
    [self.functionView setPaintDidClickedBlock:^{
        Segment = 0;
        SegmentWidth = 8;
    }];
    
    //相机
    [self.functionView setCameraDidClickedBlock:^(NSInteger index) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 == index) {//相册
                [[GGCamera sharedInstance] showLocalPictureResult:^(UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.backgroundImageView setImage:image];
                    });
                }];
            }else{//相机
                [[GGCamera sharedInstance] showOnlyCameraResult:^(UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.backgroundImageView setImage:image];
                    });
                }];
            }
        });
    }];
    
    //分享
    [self.functionView setShareDidClickedBlock:^(NSInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat heightOfFunctionView = BEScreenWidth / 3.0 * 2;
            
            
            [UIView animateWithDuration:0.15 animations:^{
                [weakSelf.functionView setFrame:CGRectMake(0, BEScreenHeight - heightOfFunctionView/2, BEScreenWidth, heightOfFunctionView)];
                functionViewIsHidden = YES;
                
            } completion:^(BOOL finished) {
                
                //iphone6 69
                
                if (finished) {
                    
                    
                    CGFloat x = 0;
                    CGFloat y = 20 + 49;
                    CGFloat width = BEScreenWidth;
                    CGFloat height = BEScreenHeight - heightOfFunctionView / 2 - 69;
                    if (IS_IPHONE4) {
                        y = 20 + 40;
                        height = BEScreenHeight - heightOfFunctionView / 2 - 60;
                    }
                    
                    
                    UIImage *image = [UIImage imageFromView:weakSelf.view atFrame:CGRectMake(x, y, width, height)];
                    if (index == 0) {
                        
                        UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
                        [[VMProgressHUD sharedInstance] showTipTextOnly:@"截图已保存到相册" dealy:1.2];
                        
                    }else if (index == 1){
                        
                        [weakSelf shareImage:image type:1];
                        
                    }else{
                        [weakSelf shareImage:image type:2];
                    }
                    
                    
                }
                
                
            }];
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareImage:(UIImage *)image type:(NSInteger)index{

    ShareType type = ShareTypeWeixiSession;
    if (index == 2) {
        type = ShareTypeSinaWeibo;
    }
    
    id<ISSContent> publishContent = [ShareSDK content:@"BE MORE"
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];

    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    [ShareSDK showShareViewWithType:type container:container content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess)
        {
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            [[VMProgressHUD sharedInstance] showTipTextOnly:@"分享成功" dealy:1.2];
        }
        else if (state == SSResponseStateFail)
        {
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            [[VMProgressHUD sharedInstance] showTipTextOnly:@"分享失败" dealy:1.2];
        }
    }];
    
}



#pragma mark -
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.paintView.isHidden) {
        return;
    }
    
    [self hidenFunctionView];
    
    
    [ColorButton removeAllSegments];
    [WidthButton removeAllSegments];
    UITouch* touch=[touches anyObject];
    MyBeganpoint=[touch locationInView:self.paintView ];
    
    [(Palette*)self.paintView Introductionpoint4:Segment];//画笔颜色
    [(Palette*)self.paintView Introductionpoint5:SegmentWidth];//画笔宽度
    [(Palette*)self.paintView Introductionpoint1];
    [(Palette*)self.paintView Introductionpoint3:MyBeganpoint];
    
    NSLog(@"======================================");
    NSLog(@"MyPalette Segment=%i",Segment);
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.paintView.isHidden) {
        return;
    }
    
    NSArray* MovePointArray=[touches allObjects];
    MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:self.paintView];
    [(Palette*)self.paintView Introductionpoint3:MyMovepoint];
    [self.paintView setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.paintView.isHidden) {
        return;
    }
    
    [(Palette*)self.paintView Introductionpoint2];
    [self.paintView setNeedsDisplay];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touches Canelled");
}


- (void)hidenFunctionView{
    if (!functionViewIsHidden) {
        CGFloat heightOfFunctionView = BEScreenWidth / 3.0 * 2;
        [UIView animateWithDuration:0.25 animations:^{
            [self.functionView setFrame:CGRectMake(0, BEScreenHeight - heightOfFunctionView/2, BEScreenWidth, heightOfFunctionView)];
            functionViewIsHidden = YES;
        }];
    }
}


- (void)startHereAction:(UITapGestureRecognizer *)gesture {
    
    [self.labelAnimation stopAnimating];
    [self.firstView setHidden:YES];
    [self.functionView setHidden:NO];
    [self.paintView setHidden:NO];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
}



@end
