//
//  JDragonTypeBtnView.h
//  RthoutHR
//
//  Created by JDragon on 2017/7/19.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JDragonTypeBtnActionDelegate <NSObject>

@optional

-(void)didClickTypeButtonAction:(UIButton*)button withIndex:(NSInteger)index;

@end

@interface JDragonTypeBtnView : UIView

@property(nonatomic, assign) CGSize intrinsicContentSize;

//@property(nonatomic,assign) JDragonTypeButtonEnum  buttonEnum;
@property(nonatomic,assign) id<JDragonTypeBtnActionDelegate> delegate;

/**
 *  设置btn  数组  自动Width
 *
 *  @param titles        <#titles description#>
 *  @param downLabHeight downLab height
 */
-(void)setTypeButtonTitles:(NSArray*)titles  withDownLableHeight:(CGFloat)downLabHeight andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget;

-(void)setTypeButtonTitles:(NSArray*)titles  andNormalImages:(NSArray<UIImage*>*)nromalImages andSelectImages:(NSArray<UIImage*>*)selectImages withDownLableHeight:(CGFloat)downLabHeight andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget;

/**
 *  设置btn  数组  计算Title Width
 *
 *  @param titles        <#titles description#>
 *  @param downLabHeight downLab height
 */
-(void)setTypeButtonAutoTitles:(NSArray*)titles  withDownLableHeight:(CGFloat)downLabHeight withPaddingWeight:(CGFloat)paddingW andDeleagte:(id<JDragonTypeBtnActionDelegate>)deleget;

/**
 *  设置选中button
 *
 *  @param index <#index description#>
 */
-(void)setSelectButtonIndex:(NSInteger)index;

/**
 *  设置typeBtn选中Color
 *
 *  @param normalColor 默认Color
 *  @param selectColor 选中Color
 */
-(void)setTypeButtonNormalColor:(UIColor*)normalColor andSelectColor:(UIColor*)selectColor;


/**
 *  设置Downlable选中Color
 *
 *  @param selectColor <#selectColor description#>
 */
-(void)setTypeDownlableSelectColor:(UIColor*)selectColor;


/**
 *  设置Downlable Heoght
 *
 */
-(void)setTypeDownlableHeight:(CGFloat)h;


/**
 *  设置Downlable Font
 *
 */
-(void)setTypeDownlableFont:(UIFont*)font;


@end
