//
//  UIButton+Style.m
//  JDMovie
//
//  Created by JDragon on 2018/8/24.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "UIButton+Style.h"

@implementation UIButton (Style)



-(void)makeApperanceFollowBtnStrokeType
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds=YES;
//    self.layer.borderColor= (self.titleLabel.textColor).CGColor;
//    self.layer.borderWidth=1;
//    [self setBackgroundImage:IMAGE(@"btnBgAttentionMe") forState:UIControlStateNormal];
//    UIImage *  image=[UIImage imageWithColor:[UIColor clearColor]];
//    [self setBackgroundImage:image forState:UIControlStateHighlighted];
//    self.layer.cornerRadius=4;
    [self addTarget:self action:@selector(didSelectChangeFollowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didSelectChangeFollowBtnAction:(UIButton*)btn
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.layer.borderColor= (btn.titleLabel.textColor).CGColor;
    });
}


@end
