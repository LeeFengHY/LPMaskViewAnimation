//
//  UIImageView+BannerMaskAnimation.h
//  LPMaskViewAnimation
//
//  Created by QFWangLP on 2016/10/26.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MaskAnimation.h"

/**
 图片轮播广告页碎片化动画
 */
@interface UIImageView (BannerMaskAnimation)

/**
 是否停止动画
 */
@property (nonatomic, assign) BOOL stop;

/**
 每次切换图片的动画时长
 */
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/**
 轮播图片数组
 */
@property (nonatomic, strong) NSArray *bannerImages;

- (void)fadeBanner;
- (void)fadeBannerWithImages:(NSArray *)images;
- (void)stopBanner;

@end
