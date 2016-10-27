//
//  UIView+MaskAnimation.m
//  LPMaskViewAnimation
//
//  Created by QFWangLP on 2016/10/26.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "UIView+MaskAnimation.h"
#import <objc/runtime.h>

const void *kIsFadeKey = &kIsFadeKey;
const void *kIsAnimatingKey = &kIsAnimatingKey;
const void *kVerticalCountKey = &kVerticalCountKey;
const void *kHorizontalCountKey = &kHorizontalCountKey;
const void *kIntervalDurationKey = &kIntervalDurationKey;
const void *kAnimationDurationKey = &kAnimationDurationKey;
static NSInteger kMaskViewTag = 0x1000000;



/*
 intervalTime = fadeDurationTime / verticalCount * horizontalCount ;
 */
@implementation UIView (MaskAnimation)

- (BOOL)isFade
{
    return [objc_getAssociatedObject(self, kIsFadeKey) boolValue];
}
- (BOOL)isFading
{
    return [objc_getAssociatedObject(self, kIsAnimatingKey) boolValue];
}
- (NSInteger)verticalCount
{
    NSNumber *count = objc_getAssociatedObject(self, kVerticalCountKey);
    if (!count) {
        self.verticalCount = 2;
    }
    return [objc_getAssociatedObject(self, kVerticalCountKey) integerValue];
}
- (NSInteger)horizontalCount
{
    NSNumber *count = objc_getAssociatedObject(self, kHorizontalCountKey);
    if (!count) {
        self.horizontalCount = 15;
    }
    return [count integerValue];
}
- (NSTimeInterval)intervalDuration
{
    NSNumber *duration = objc_getAssociatedObject(self, kIntervalDurationKey);
    if (!duration) {
        objc_setAssociatedObject(self, kIntervalDurationKey, @0.175, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [duration doubleValue];
}
- (NSTimeInterval)fadeAnimationDuration
{
    NSNumber *duration = objc_getAssociatedObject(self, kAnimationDurationKey);
    if (!duration) {
        objc_setAssociatedObject(self, kAnimationDurationKey, @(0.7), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [duration doubleValue];
}

- (void)setIsFade:(BOOL)isFade
{
    objc_setAssociatedObject(self, kIsFadeKey, @(isFade), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setIsFading:(BOOL)isFading
{
    objc_setAssociatedObject(self, kIsAnimatingKey, @(isFading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setVerticalCount:(NSInteger)verticalCount
{
    verticalCount = MAX(2, MIN(3, verticalCount));
    objc_setAssociatedObject(self, kVerticalCountKey, @(verticalCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setHorizontalCount:(NSInteger)horizontalCount
{
    horizontalCount = MAX(15, MIN(18, horizontalCount));
    objc_setAssociatedObject(self, kHorizontalCountKey, @(horizontalCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setIntervalDuration:(NSTimeInterval)intervalDuration
{
    intervalDuration = MAX(LPMinDuration * LPMultipled, MIN(self.fadeAnimationDuration * LPMultipled, intervalDuration));
    objc_setAssociatedObject(self, kIntervalDurationKey, @(intervalDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setFadeAnimationDuration:(NSTimeInterval)fadeAnimationDuration
{
    fadeAnimationDuration = MAX(LPMinDuration, MIN(LPMaxDuration, fadeAnimationDuration));
    if (self.intervalDuration > fadeAnimationDuration * LPMultipled || self.intervalDuration <= 0) {
        self.intervalDuration = fadeAnimationDuration * LPMultipled;
    }
    objc_setAssociatedObject(self, kAnimationDurationKey, @(fadeAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)configurateWithVerticalCount:(NSInteger)verticalCount
                     horizontalCount:(NSInteger)horizontalCount
                            interval:(NSTimeInterval)interval
                            duration:(NSTimeInterval)duration
{
    self.verticalCount = verticalCount;
    self.horizontalCount = horizontalCount;
    self.intervalDuration = interval;
    self.fadeAnimationDuration = duration;
    if (!self.maskView) {
        self.maskView = [self fadeMaskView];
    }
}
- (void)reverseWithComplete:(void(^)(void))complete
{
    NSParameterAssert(self.maskView);
    if (self.isFading) {
        NSLog(@"It's animating");
        return;
    }
    self.isFading = YES;
    if (self.fadeAnimationDuration <= 0) {
        self.fadeAnimationDuration = (LPMaxDuration + LPMinDuration) / 2;
    }
    if (self.intervalDuration <= 0) {
        self.intervalDuration = self.fadeAnimationDuration * LPMultipled;
    }
    __block NSInteger timeCount = 0;
    NSInteger fadeCount = self.verticalCount * self.horizontalCount;
    for (NSInteger i = fadeCount - 1; i >= 0 ; i--) {
        UIView *subView = [self.maskView viewWithTag:[self subViewTag:i]];
       [UIView animateWithDuration:self.fadeAnimationDuration delay:self.intervalDuration *(fadeCount - 1 - i) options:UIViewAnimationOptionCurveLinear animations:^{
           subView.alpha = 1.0;
       } completion:^(BOOL finished) {
           if (++timeCount == fadeCount) {
               self.isFading = NO;
               self.isFade = NO;
               if (complete) {
                   complete();
               }
           }
       }];
    }
}
- (void)animationFadeWithComplete:(void(^)(void))complete
{
    if (self.isFading) {
        NSLog(@"It's animating");
        return;
    }
    if (!self.maskView) {
        self.maskView = self.fadeMaskView;
    }
    self.isFading = YES;
    if (self.fadeAnimationDuration <= 0) {
        self.fadeAnimationDuration = (LPMaxDuration + LPMinDuration) / 2;
    }
    if (self.intervalDuration <= 0) {
        self.intervalDuration = self.fadeAnimationDuration * LPMultipled;
    }
    __block NSInteger timeCount = 0;
    NSInteger fadeCount = self.verticalCount * self.horizontalCount;
    for (NSInteger i = 0; i < fadeCount ; i++) {
        UIView *subView = [self.maskView viewWithTag:[self subViewTag:i]];
        if (!subView) {
            continue;
        }
        [UIView animateWithDuration:self.fadeAnimationDuration delay:self.intervalDuration * i options:UIViewAnimationOptionCurveLinear animations:^{
            subView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (timeCount != fadeCount - 1) {
                timeCount++;
            }else{
                self.isFade = YES;
                self.isFading = NO;
                if (complete) {
                    complete();
                }
            }
        }];
    }
}
- (void)reverseWithoutAnimation
{
    if (self.isFading) {
        NSLog(@"It's animating");
        return;
    }
    for (UIView *subView in self.maskView.subviews) {
        subView.alpha = 1.0;
    }
}

- (UIView *)fadeMaskView
{
    UIView *fadeMaskView = [[UIView alloc] initWithFrame:self.bounds];
    if (self.horizontalCount <= 0) {
        self.horizontalCount = 15;
    }
    if (self.verticalCount <= 0) {
        self.verticalCount = 3;
    }
    CGFloat itemWidth = CGRectGetWidth(self.frame) / self.horizontalCount;
    CGFloat itemHeight = CGRectGetHeight(self.frame) / self.verticalCount;
    for (NSInteger line = 0; line < self.horizontalCount; line++) {
        for (NSInteger row = 0; row < self.verticalCount; row++) {
            UIView *maskSubView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * line, itemHeight * row, itemWidth, itemHeight)];
            maskSubView.tag = [self subViewTag: line * self.verticalCount + row];
            maskSubView.backgroundColor = [UIColor redColor];
            [fadeMaskView addSubview:maskSubView];
        }
    }
    return fadeMaskView;
}
- (NSInteger)subViewTag:(NSInteger)idx
{
    return kMaskViewTag + idx;
}
@end
