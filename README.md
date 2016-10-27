# LPMaskViewAnimation--通过maskView实现碎片动画
## 每个view自身都有一个maskView,maskView初始background为clearColor,通过实现maskView的alpha值来影响view的hide,利用时间差异来实现碎片效果.
> maskSubView backgroundColor切记不要clearColor,主要代码如下:

```objc

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

```
