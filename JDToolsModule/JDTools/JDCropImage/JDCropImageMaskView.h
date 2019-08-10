//
//  JDCropImageMaskView.h
//  JDMovie
//
//  Created by JDragon on 2018/8/28.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface JDCropImageMaskView : UIView


-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)cropWidth height:(CGFloat)height;

@property (nonatomic,strong) UIColor *lineColor; // 线条颜色
@property (nonatomic,assign) BOOL    isDark; // 是否为虚线 default is NO

@end
