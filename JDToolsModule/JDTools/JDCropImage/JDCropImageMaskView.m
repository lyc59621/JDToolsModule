//
//  JDCropImageMaskView.m
//  JDMovie
//
//  Created by JDragon on 2018/8/28.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDCropImageMaskView.h"

typedef NS_ENUM(NSInteger, PhotoMaskViewMode) {
    PhotoMaskViewModeCircle = 1, // default
    PhotoMaskViewModeSquare = 2  // square
};

@interface  JDCropImageMaskView()

@property (nonatomic,assign) PhotoMaskViewMode mode;

@end

@implementation JDCropImageMaskView
{
    CGRect _squareRect;   // 外切正方形
    CGFloat _cropWidth;
    CGFloat _cropHeight;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)cropWidth height:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = PhotoMaskViewModeCircle;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _cropWidth = cropWidth;
        _cropHeight = height;
        self.isDark = NO;
        self.lineColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//
    if (self.mode == PhotoMaskViewModeCircle) {

        [self crop:rect];
    }else{
        [self crop2:rect];
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutScrollViewWithRect:)]) {
//        [self.delegate layoutScrollViewWithRect:_squareRect];
//    }
    
}

-(void)crop2:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    _squareRect = CGRectMake((width - _cropWidth) / 2, (height - _cropHeight) / 2, _cropWidth, _cropHeight);
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:_squareRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    [maskBezierPath appendPath:squarePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    CGContextSetLineWidth(contextRef, 2);
    if (self.isDark) {
        CGFloat length[2] = {5,5};
        CGContextSetLineDash(contextRef, 0, length, 2);
    }
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    [squarePath stroke];
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}
-(void)crop:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
   
//    UIImage  *blurImage = [IMAGE(@"photo")  blurImageWithRadius:20];
//    UIColor  *c = [UIColor colorWithPatternImage:blurImage];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 255, 255, 255, 0);
//    CGContextSetFillColor(contextRef, CGColorGetComponents(c.CGColor));
    _squareRect = CGRectMake((width - _cropWidth) / 2, 50, _cropWidth, _cropWidth);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_squareRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    [maskBezierPath appendPath:circlePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    CGContextSetLineWidth(contextRef, 2);
    if (self.isDark) {
        CGFloat length[2] = {5,5};
        CGContextSetLineDash(contextRef, 0, length, 2);
    }
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    ///
    

    
    
    
    
    ///
    [circlePath stroke];
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}
@end
