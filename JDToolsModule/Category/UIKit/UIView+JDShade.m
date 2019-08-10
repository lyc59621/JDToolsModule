//
//  UIView+JDShade.m
//  JDMovie
//
//  Created by JDragon on 2018/8/31.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "UIView+JDShade.h"

@implementation UIView (JDShade)


-(void)shadeWithStartColor:(UIColor*)startColor withEndColor:(UIColor*)endColor withType:(NSInteger)type
{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer   *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];

    switch (type) {
        case 0:
            // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case 1:
            // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            break;
            break;
        case 2:
           // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
           gradientLayer.startPoint = CGPointMake(0, 1);
           gradientLayer.endPoint = CGPointMake(1, 1);
        default:
            break;
    }
}
@end
