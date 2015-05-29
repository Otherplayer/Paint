//
//  BEFunctionView.m
//  BEMore
//
//  Created by __无邪_ on 15/5/29.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "BEFunctionView.h"

#define kButtonStartTag 1000
#define kColorButtonStartTag 2000
#define kCameraButtonStartTag 2100
#define kShareButtonStartTag 2200


@interface BEFunctionView ()

@property (nonatomic, strong) UIView *contentView1;
@property (nonatomic, strong) UIView *contentView2;
@property (nonatomic, strong) UIView *contentView3;

@end


@implementation BEFunctionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CGFloat halfHeight = frame.size.height / 2;
        
        NSArray *imageArr = @[@"app_13.png",@"app_14.png",@"app_15.png"];
        NSArray *lightImageArr = @[@"app_13_l.png",@"app_14_l.png",@"app_15_l.png"];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * halfHeight, 0, halfHeight, halfHeight)];
            [button setBackgroundColor:[UIColor blueColor]];
            [button setTag:kButtonStartTag + i];
            [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:lightImageArr[i]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:lightImageArr[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        
        
        
        
        //content function
        
        // 1
        CGRect contentRect = CGRectMake(0, halfHeight, frame.size.width, halfHeight);
        self.contentView1 = [[UIView alloc] initWithFrame:contentRect];
        [self.contentView1 setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.contentView1];
        
        
        UIButton *biButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, halfHeight, halfHeight)];
        [biButton setBackgroundImage:[UIImage imageNamed:@"app_13.png"] forState:UIControlStateNormal];
        [biButton setBackgroundColor:[UIColor colorWithRed:0.161 green:1.000 blue:0.843 alpha:1.000]];
        [biButton addTarget:self action:@selector(paintAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView1 addSubview:biButton];
        
        
        
        UIButton *caButton = [[UIButton alloc] initWithFrame:CGRectMake(BEScreenWidth - halfHeight, 0, halfHeight, halfHeight)];
        [caButton setBackgroundColor:[UIColor whiteColor]];
        [caButton addTarget:self action:@selector(eraserAction:) forControlEvents:UIControlEventTouchUpInside];
        [caButton setBackgroundImage:[UIImage imageNamed:@"app_ca.png"] forState:UIControlStateNormal];
        [self.contentView1 addSubview:caButton];
        
        
        CGFloat width = halfHeight / 3.0;
        NSArray *colors = @[
                            [UIColor colorWithRed:0.996 green:1.000 blue:0.043 alpha:1.000],
                            [UIColor redColor],
                            [UIColor colorWithRed:0.957 green:0.498 blue:0.102 alpha:1.000],
                            
                            [UIColor colorWithRed:0.137 green:1.000 blue:0.035 alpha:1.000],
                            [UIColor colorWithRed:0.984 green:0.000 blue:1.000 alpha:1.000],
                            [UIColor colorWithRed:0.322 green:0.102 blue:0.494 alpha:1.000],
                            
                            [UIColor blueColor],
                            [UIColor whiteColor],
                            [UIColor blackColor],
                            ];
        for (int i = 0; i < 9; i++) {
            CGFloat y = 0;
            CGFloat x = 0;
            x = halfHeight + (i % 3) * width;
            y = width * (i / 3);
            UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, width)];
            [colorButton setBackgroundColor:colors[i]];
            [colorButton setTag:kColorButtonStartTag + i];
            [colorButton addTarget:self action:@selector(colorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView1 addSubview:colorButton];
        }
        
        
        
        
        
        // 2
        
        self.contentView2 = [[UIView alloc] initWithFrame:contentRect];
        [self.contentView2 setBackgroundColor:[UIColor blueColor]];
        [self addSubview:self.contentView2];
        
        
        NSArray *backgroundColors = @[[UIColor cyanColor] , [UIColor whiteColor]];
        NSArray *imagesOfBackGArr = @[@"app_16.png",@"app_17.png"];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * BEScreenWidth / 2, 0, BEScreenWidth/2, halfHeight)];
            [button setBackgroundImage:[UIImage imageNamed:imagesOfBackGArr[i]] forState:UIControlStateNormal];
            [button setBackgroundColor:backgroundColors[i]];
            [button setTag:kCameraButtonStartTag+i];
            [button addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView2 addSubview:button];
        }
        
        
        
        
        // 3
        
        self.contentView3 = [[UIView alloc] initWithFrame:contentRect];
        [self.contentView3 setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:self.contentView3];
        
        
        NSArray *shareImageArr = @[@"app_13share.png",@"app_18share.png",@"app_19share.png"];
        NSArray *shareBGColors = @[[UIColor cyanColor],[UIColor whiteColor],[UIColor cyanColor]];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * halfHeight, 0, halfHeight, halfHeight)];
            [button setBackgroundColor:shareBGColors[i]];
            [button setTag:kShareButtonStartTag + i];
            [button setBackgroundImage:[UIImage imageNamed:shareImageArr[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView3 addSubview:button];
        }
        
        
        
        
    }
    return self;
}


- (void)buttonClicked:(UIButton *)sender{
    
    [self.contentView3 setHidden:YES];
    [self.contentView1 setHidden:YES];
    [self.contentView2 setHidden:YES];
    
    
    switch (sender.tag - kButtonStartTag) {
        case 0:
            [self.contentView1 setHidden:NO];
            break;
        case 1:
            [self.contentView2 setHidden:NO];
            break;
        case 2:
            [self.contentView3 setHidden:NO];
            break;
        default:
            break;
    }
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:kButtonStartTag + i];
        [button setSelected:NO];
    }
    
    [sender setSelected:YES];
    if (self.mainFunctionButtonClickedBlock) {
        self.mainFunctionButtonClickedBlock(sender.tag - kButtonStartTag);
    }
}

- (void)colorButtonClicked:(UIButton *)sender{
    if (self.colorSelectedBlock) {
        self.colorSelectedBlock(sender.tag - kColorButtonStartTag);
    }
}

- (void)eraserAction:(id)sender{
    if (self.eraserDidClickedBlock) {
        self.eraserDidClickedBlock();
    }
}

- (void)paintAction:(id)sender{
    if (self.paintDidClickedBlock) {
        self.paintDidClickedBlock();
    }
}

- (void)cameraButtonClicked:(UIButton *)sender{
    if (self.cameraDidClickedBlock) {
        self.cameraDidClickedBlock(sender.tag - kCameraButtonStartTag);
    }
}

- (void)shareButtonClicked:(UIButton *)sender{
    if (self.shareDidClickedBlock) {
        self.shareDidClickedBlock(sender.tag - kShareButtonStartTag);
    }
}



@end
