//
//  ViewController.m
//  LPMaskViewAnimation
//
//  Created by QFWangLP on 2016/10/26.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "ViewController.h"
#import "UIView+MaskAnimation.h"
#import "UIImageView+BannerMaskAnimation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#if 0
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    view1.backgroundColor = [UIColor redColor];
    
    UIView *maskView = [[UIView alloc] initWithFrame:view1.bounds];
    maskView.backgroundColor = [UIColor yellowColor];
    maskView.alpha = 1.0;
    view1.maskView = maskView;
    
    [self.view addSubview:view1];
    
    UIView * viewContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 50, 200, 200)];
    viewContainer.backgroundColor = [UIColor blueColor];
    
    UIView * contentView = [[UIView alloc] initWithFrame: CGRectMake(20, 20, 160, 160)];
    contentView.backgroundColor = [UIColor yellowColor];
    [viewContainer addSubview: contentView];
    
    UIView * maskView = [[UIView alloc] initWithFrame: contentView.bounds];
    maskView.backgroundColor = [UIColor redColor];
    maskView.alpha = 0.0;
    contentView.maskView = maskView;
    [self.view addSubview: viewContainer];
    
    maskView.backgroundColor = [UIColor clearColor];
    UIView * sub1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 20, 40)];
    sub1.backgroundColor = [UIColor blackColor];
    UIView * sub2 = [[UIView alloc] initWithFrame: CGRectMake(20, 40, 33, 40)];
    sub2.backgroundColor = [UIColor blackColor];
    [maskView addSubview: sub1];
    [maskView addSubview: sub2];
#endif

    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self imageFadeTransition];
    [self bannerFadeAnimate];
}
/*
 碎片动画效果
 */
- (void)imageFadeTransition
{
    if (_imageViewTwo.isFade) {
        [_imageViewTwo reverseWithComplete:^{
            NSLog(@"maskView alpha is 1.0 show the top view");
        }];
    }else{
        [_imageViewTwo animationFadeWithComplete:^{
            NSLog(@"maskView alpha is 0.0 finish animation");
        }];
    }
}


/**
 广告页轮播效果
 */
- (void)bannerFadeAnimate
{
    NSMutableArray * images = @[].mutableCopy;
    for (NSInteger idx = 1; idx < 5; idx++) {
        [images addObject: [NSString stringWithFormat: @"banner%lu", idx]];
    }
    [_bannerImageView fadeBannerWithImages: images];
}

@end
