//
//  UIView+MaskAnimation.h
//  LPMaskViewAnimation
//
//  Created by QFWangLP on 2016/10/26.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LPMaxDuration 1.2
#define LPMinDuration 0.2
#define LPMultipled   0.25

/**
 碎片动画--类别
 */
@interface UIView (MaskAnimation)

/**
 视图是否隐藏-mask
 */
@property (nonatomic, assign, readonly) BOOL isFade;

/**
 是否处在动画中
 */
@property (nonatomic, assign, readonly) BOOL isFading;

/**
 垂直方块view个数,default is 3
 */
@property (nonatomic, assign) NSInteger verticalCount;

/**
 水平方块view个数, default is 18
 */
@property (nonatomic, assign) NSInteger horizontalCount;

/**
 方块动画间隔0.2~1.2, default is 0.7
 */
@property (nonatomic, assign) NSTimeInterval intervalDuration;

/**
  每个方块隐藏的动画时间0.05~0.3，最多为动画时长的25%。默认为0.175
 */
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;

- (void)configurateWithVerticalCount:(NSInteger)verticalCount
                     horizontalCount:(NSInteger)horizontalCount
                            interval:(NSTimeInterval)interval
                            duration:(NSTimeInterval)duration;
- (void)reverseWithComplete:(void(^)(void))complete;
- (void)animationFadeWithComplete:(void(^)(void))complete;
- (void)reverseWithoutAnimation;
@end
