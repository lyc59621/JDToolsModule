//
//  JDragonTypeBtnView.m
//  RthoutHR
//
//  Created by JDragon on 2017/7/19.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "JDragonTypeBtnView.h"
#import "JKUIKit.h"

#define BtnRGBCOLOR(HEX)     [UIColor colorWithRed:((((HEX)>>16)&0xFF))/255. green:((((HEX)>>8)&0xFF))/255.  blue:((((HEX)>>0)&0xFF))/255. alpha:1]
@implementation JDragonTypeBtnView
{
    
    CGFloat  weight;
    CGFloat  height;
    CGFloat  btnHeight;
    CGFloat  btnWidth;
    UILabel  *downLabel;
    CGRect   downLabFrame;
    CGFloat  buttonWeight;
    
    UIColor * btnNormalColor;
    UIColor * btnSelectColor;
    BOOL     isAuto;
    CGFloat  buttonX;
    CGFloat  padding;
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        [self customInit];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    [self setBaseView];
}
-(void)setBaseView
{
    weight = self.frame.size.width;
    height = self.frame.size.height;
    
    btnNormalColor = BtnRGBCOLOR(0x2a2a2a);
//    btnSelectColor = BtnRGBCOLOR(0xfe6046);
    btnSelectColor = BtnRGBCOLOR(0x2a2a2a);

    downLabel = [[UILabel  alloc]init];
    downLabel.backgroundColor = BtnRGBCOLOR(0xfe6046);
    [self addSubview:downLabel];
    [self bringSubviewToFront:downLabel];
    if (!isAuto) {
        UIView  *downView = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, weight, 0.5)];
        downView.backgroundColor = BtnRGBCOLOR(0x323436);
//        [downView jk_shadowWithColor:BtnRGBCOLOR(0xc0c0c0) offset:CGSizeMake(0, 0) opacity:1 radius:4];
        [self addSubview:downView];
    }
}
/**
 *  设置btn  数组
 *
 *  @param titles        <#titles description#>
 *  @param downLabHeight downLab height
 */
-(void)setTypeButtonTitles:(NSArray*)titles  withDownLableHeight:(CGFloat)downLabHeight andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget
{
    [self customInit];
    self.delegate = deleget;
    CGFloat  btnWeight = self.frame.size.width/titles.count;
    buttonWeight = btnWeight;
    downLabel.frame = CGRectMake(0, height-downLabHeight, btnWeight, downLabHeight);
    downLabFrame = downLabel.frame;
    for (int  i=0; i<titles.count; i++)
    {
        NSString  *title = titles[i];
        UIButton  *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeBtn setTitle:title forState:UIControlStateNormal];
        [typeBtn setTitleColor:BtnRGBCOLOR(0x2a2a2a) forState:UIControlStateNormal];
//        [typeBtn setTitleColor:BtnRGBCOLOR(0xde2418) forState:UIControlStateSelected];
        
//        [typeBtn setImage:[UIImage imageNamed:@"rectangle8"] forState:UIControlStateNormal];
//        [typeBtn setImage:[UIImage imageNamed:@"rectangle8"] forState:UIControlStateSelected];
        typeBtn.frame = CGRectMake(i*btnWeight, 0, btnWeight, height);
        typeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        typeBtn.tag = 12345+i;
//        [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - typeBtn.imageView.image.size.width, 0, typeBtn.imageView.image.size.width)];
//        [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, typeBtn.titleLabel.bounds.size.width+2, 0, -typeBtn.titleLabel.bounds.size.width-2)];
        [typeBtn addTarget:self action:@selector(didClickTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBtn];
    }
    [self setSelectTypeIndex:0];
}
-(void)setTypeButtonTitles:(NSArray*)titles  andNormalImages:(NSArray<UIImage*>*)nromalImages andSelectImages:(NSArray<UIImage*>*)selectImages withDownLableHeight:(CGFloat)downLabHeight andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget
{
    
    [self customInit];
    self.delegate = deleget;
    CGFloat  btnWeight = self.frame.size.width/titles.count;
    buttonWeight = btnWeight;
    downLabel.frame = CGRectMake(0, height-downLabHeight, btnWeight, downLabHeight);
    downLabFrame = downLabel.frame;
    for (int  i=0; i<titles.count; i++)
    {
        NSString  *title = titles[i];
        UIButton  *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeBtn setTitle:title forState:UIControlStateNormal];
        [typeBtn setTitleColor:BtnRGBCOLOR(0x2a2a2a) forState:UIControlStateNormal];
        //        [typeBtn setTitleColor:BtnRGBCOLOR(0xde2418) forState:UIControlStateSelected];
        
        [typeBtn setImage:nromalImages[i] forState:UIControlStateNormal];
        [typeBtn setImage:selectImages[i] forState:UIControlStateSelected];
        typeBtn.frame = CGRectMake(i*btnWeight, 0, btnWeight, height);
        typeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        typeBtn.tag = 12345+i;
        [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - typeBtn.imageView.image.size.width, 0, typeBtn.imageView.image.size.width)];
        [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, typeBtn.titleLabel.bounds.size.width+2, 0, -typeBtn.titleLabel.bounds.size.width-2)];
        [typeBtn addTarget:self action:@selector(didClickTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBtn];
    }
    [self setSelectTypeIndex:0];
    
    
    
}

/**
 *  设置btn  数组
 *
 *  @param titles        <#titles description#>
 *  @param downLabHeight downLab height
 */
-(void)setTypeButtonAutoTitles:(NSArray*)titles  withDownLableHeight:(CGFloat)downLabHeight withPaddingWeight:(CGFloat)paddingW andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget
{
    isAuto = true;
    padding =  paddingW;
    [self customInit];
    self.delegate = deleget;
    NSDictionary*attrs =@{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    //计算文本宽度。
    CGFloat   textW = [titles[0]  boundingRectWithSize:CGSizeMake(weight, height)  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size.width;
    buttonWeight = textW;
//    downLabel.frame = CGRectMake(padding/2, height-downLabHeight, textW, downLabHeight);

    downLabel.frame = CGRectMake((textW-15)/2, height-downLabHeight, 15, downLabHeight);
    downLabFrame = downLabel.frame;
    downLabel.backgroundColor = BtnRGBCOLOR(0xde2418);
    for (int  i=0; i<titles.count; i++)
    {
        NSString  *title = titles[i];
        UIButton  *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeBtn setTitle:title forState:UIControlStateNormal];
        [typeBtn setTitleColor:BtnRGBCOLOR(0x989898)  forState:UIControlStateNormal];
//        [typeBtn setTitleColor:BtnRGBCOLOR(0xde2418) forState:UIControlStateSelected];
        [typeBtn setTitleColor:BtnRGBCOLOR(0xde2418)forState:UIControlStateHighlighted];
        
        NSDictionary*attrs =@{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        //计算文本宽度。
        CGFloat   textW = [title  boundingRectWithSize:CGSizeMake(weight, height)  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size.width+padding;
        
        typeBtn.frame = CGRectMake(buttonX, 0, textW, height);
        typeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        typeBtn.tag = 12345+i;
        [typeBtn addTarget:self action:@selector(didClickTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBtn];
        buttonX+=textW;
    }
    CGRect  ff = self.frame;
    ff.size.width = buttonX;
    self.frame = ff;
    [self setSelectTypeIndex:0];
}
-(void)didClickTypeButtonAction:(UIButton*)button
{
    NSInteger  index = button.tag - 12345;
    [self setSelectTypeIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(didClickTypeButtonAction:withIndex:)]) {
        [self.delegate didClickTypeButtonAction:button withIndex:index];
    }
}
-(void)setSelectTypeIndex:(NSInteger)index
{
    UIButton *btn = [self viewWithTag:12345+index];
    for (UIView  *view in self.subviews) {
        
        if([view  isKindOfClass:[UIButton  class]]){
            
            UIButton  *abutton = (UIButton*)view;
            if (abutton.tag==index+12345) {
                abutton.selected = YES ;
                [abutton setTitleColor:btnSelectColor forState:UIControlStateNormal];
                
            }else {
                abutton.selected = NO;
                [abutton setTitleColor:btnNormalColor forState:UIControlStateNormal];
                
            }
        }
    }
    if (btn.selected) {
        
        
        if (isAuto) {
            downLabFrame.origin.x = btn.frame.origin.x+(btn.frame.size.width-15)/2;
            downLabFrame.size.width = 15;
        }else
        {
            downLabFrame.origin.x = btn.frame.origin.x+(padding/2);
            downLabFrame.size.width = btn.frame.size.width-padding;
        }
        buttonWeight =  downLabFrame.size.width;
        [self bringSubviewToFront:btn];
        [UIView  animateWithDuration:.2 animations:^{
            downLabel.frame = downLabFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}
/**
 *  设置选中button
 *
 *  @param index <#index description#>
 */
-(void)setSelectButtonIndex:(NSInteger)index
{
    
    [self setSelectTypeIndex:index];
}
/**
 *  设置typeBtn选中Color
 *
 *  @param normalColor 默认Color
 *  @param selectColor 选中Color
 */
-(void)setTypeButtonNormalColor:(UIColor*)normalColor andSelectColor:(UIColor*)selectColor
{
    btnNormalColor = normalColor;
    btnSelectColor = selectColor;
    for (UIView  *view in self.subviews) {
        
        if([view  isKindOfClass:[UIButton  class]]){
            UIButton  *abutton = (UIButton*)view;
            [abutton setTitleColor:normalColor forState:UIControlStateNormal];
//            [abutton setTitleColor:selectColor forState:UIControlStateSelected];
            [abutton setTitleColor:selectColor forState:UIControlStateHighlighted];
            
        }
    }
    downLabel.backgroundColor = selectColor;
}

/**
 *  设置Downlable Font
 *
 *
 */
-(void)setTypeDownlableFont:(UIFont*)font
{
    for (UIView  *view in self.subviews) {
        
        if([view  isKindOfClass:[UIButton  class]]){
            UIButton  *abutton = (UIButton*)view;
            abutton.titleLabel.font = font;
        }
    }
    
}


/**
 *  设置Downlable选中Color
 *
 *  @param selectColor <#selectColor description#>
 */
-(void)setTypeDownlableSelectColor:(UIColor*)selectColor
{
    downLabel.backgroundColor = selectColor;
}
/**
 *  设置Downlable Heoght
 *
 *  @param
 */
-(void)setTypeDownlableHeight:(CGFloat)h
{
    downLabel.frame = CGRectMake(downLabFrame.origin.x, height-h, downLabFrame.size.width, h);
    
}
@end
