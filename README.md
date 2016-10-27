# LPMaskViewAnimation--通过maskView实现碎片动画
## 每个view自身都一个maskView,初始状态background为clearColor,通过实现maskView 的alpha值来影响view的hide,利用时间差异来实现碎片效果.
< maskSubView backgroundColor切记不要clearColor,主要代码如下:

```objc
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
