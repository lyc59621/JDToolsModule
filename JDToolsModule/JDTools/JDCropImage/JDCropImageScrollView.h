//
//  JDCropImageScrollView.h
//  JDMovie
//
//  Created by JDragon on 2018/8/28.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDCropImageScrollView : UIScrollView

@property (nonatomic, strong) UIImageView *zoomView;

- (void)displayImage:(UIImage *)image;

@end
