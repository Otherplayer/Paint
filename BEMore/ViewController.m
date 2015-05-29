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
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;//背景照片
@property (weak, nonatomic) IBOutlet UIView *paintView;//画布

@property (weak, nonatomic) IBOutlet UIView *firstView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController applyAppDefaultApprence];
    [self.navigationController setHide:YES];
    
    
    [self.paintView setHidden:YES];
    SegmentWidth = 8;
    
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
            if (index == 0) {
                
                [UIView animateWithDuration:0.15 animations:^{
                    CGFloat heightOfFunctionView = BEScreenWidth / 3.0 * 2;
                    [weakSelf.functionView setFrame:CGRectMake(0, BEScreenHeight - heightOfFunctionView/2, BEScreenWidth, heightOfFunctionView)];
                    functionViewIsHidden = YES;
                    
                } completion:^(BOOL finished) {
                    UIImage *image = [UIImage imageFromView:weakSelf.view atFrame:CGRectMake(0, 0, BEScreenWidth, BEScreenHeight - heightOfFunctionView / 2)];
                    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
                    [[VMProgressHUD sharedInstance] showTipTextOnly:@"截图已保存到相册" dealy:1.2];
                    
                }];
            }else if (index == 1){
            
                
            }else{
                
            }
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)startHereAction:(id)sender {
    
    [self.firstView setHidden:YES];
    [self.functionView setHidden:NO];
    [self.paintView setHidden:NO];
}





@end
