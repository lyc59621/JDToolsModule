//
//  JDCropImageScrollView.m
//  JDMovie
//
//  Created by JDragon on 2018/8/28.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDCropImageScrollView.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface JDCropImageScrollView () <UIScrollViewDelegate>
{
    CGSize _imageSize;
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end
@implementation JDCropImageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 缩放视图居中，当视图小于屏幕的大小
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = self.zoomView.frame;
//
//    // 水平居中
//    if (frameToCenter.size.width < boundsSize.width) {
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    } else {
//        //        frameToCenter.origin.x = 0;
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    }
//    // 垂直居中
//    if (frameToCenter.size.height < boundsSize.height) {
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    } else {;
//        frameToCenter.origin.y = -self.frame.origin.y;
//    }
//
//    self.zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}

#pragma mark - Configure scrollView to display new image


- (void)displayImage:(UIImage *)image
{
    // 清除View 为image 展示做准备
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    //在进行任何进一步的计算之前，将我们的zoomScale重置为1.0
    self.zoomScale = 1.0;
    
    // 显示新图像
    _zoomView = [[UIImageView alloc] initWithImage:image];
    _zoomView.hidden = true;
    _zoomView.contentMode =  UIViewContentModeScaleAspectFill;
    [self addSubview:_zoomView];
    [self configureForImageSize:image.size];
//    // 缩放视图居中，当视图小于屏幕的大小
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = self.zoomView.frame;
//
//    // 水平居中
//    if (frameToCenter.size.width < boundsSize.width) {
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    } else {
//        //        frameToCenter.origin.x = 0;
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    }
//    // 垂直居中
//    if (frameToCenter.size.height < boundsSize.height) {
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    } else {;
//        frameToCenter.origin.y = -self.frame.origin.y;
//    }
//
//    self.zoomView.frame = frameToCenter;
}

- (void)configureForImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
//    _imageSize.width+=self.bounds.origin.x;
//    _imageSize.height+=self.bounds.origin.y;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setInitialZoomScale];
    [self setInitialContentOffset];
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    // 计算最小/最大缩放比例
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // 在宽度方面适合图像所需的比例
    CGFloat yScale = boundsSize.height / _imageSize.height;   // 高度适配
    
    CGFloat minScale = MIN(xScale, yScale);                   // 使用最小值 使图片可见
    CGFloat maxScale = MAX(xScale, yScale);
    
    // 即使图像尺寸较小，图像也必须适合屏幕。
    CGFloat xImageScale = maxScale*_imageSize.width / boundsSize.width;
    CGFloat yImageScale = maxScale*_imageSize.height / boundsSize.width;
    CGFloat maxImageScale = MAX(xImageScale, yImageScale);
    
    maxImageScale = MAX(minScale, maxImageScale);
    maxScale = MAX(maxScale, maxImageScale);
    
    // 不要让minScale超过maxScale。 （如果图像小于屏幕，不想强制它进行缩放。）
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;

}

- (void)setInitialZoomScale
{
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // 在宽度方面适合图像所需的比例 image width-wise
    CGFloat yScale = boundsSize.height / _imageSize.height;   //  高度适配
    CGFloat scale = MAX(xScale, yScale);
    self.zoomScale = scale;
}

- (void)setInitialContentOffset
{
      CGPoint contentOffset = self.contentOffset;
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = self.zoomView.frame;
//    contentOffset.x = (frameToCenter.size.width - boundsSize.width) / 2.0;
//    contentOffset.y = (frameToCenter.size.height - boundsSize.height) / 2.0;
    
    contentOffset.x  = self.frame.origin.x;
    contentOffset.y  = self.frame.origin.y;
    [self setContentOffset:contentOffset];
    WS(weakSelf);
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setContentOffset:contentOffset];
        weakSelf.zoomView.hidden = false;
//         weakSelf.contentSize = self.bounds.size;
    });
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    int x = point.x;
//    int y = point.y;
//    DDLogVerbose(@"touch (x, y) is (%d, %d)", x, y);
//}

#pragma mark -

#pragma mark - Rotation support

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    // 如果我们处于最小缩放比例，则通过返回0来保留它，这将被转换为最小值
    // 恢复比例。
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: 恢复缩放比例，首先确保它在允许的范围内。
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: 恢复中心点，首先确保它在允许的范围内。
    
    // 2a: 将我们想要的中心点转换回我们自己的坐标空间
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.zoomView];
    
    // 2b: 计算将产生该中心点的内容偏移量
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: 恢复偏移，调整到允许范围内
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}
@end
