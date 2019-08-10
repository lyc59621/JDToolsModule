//
//  JDragonPickView.h
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDragonLocation.h"
@class JDragonPickView;


typedef enum {
    JdragonPickWithStateOther,
    JDragonPickWithStateAndCityAndDistrict,
    JDragonDatePickerYearAndMonuth,

}JDragonPickerStyle;

@protocol JDragonPickViewPickViewDelegate <NSObject>

@optional
-(void)toolbarDonBtnHaveClick:(JDragonPickView *)pickView resultString:(NSString *)resultString;

-(void)toolbarDonBtnHaveClick:(JDragonPickView *)pickView  cityId:(NSString*)cityId;

- (void)toolbarDonBtnHaveClick:(JDragonPickView *)pickView selectedRow:(NSInteger)row resultString:(NSString *)resultString;

- (void)toolbarDonBtnHaveClick:(JDragonPickView *)pickView resultArea:(NSString *)resultArea;
@end

@interface JDragonPickView : UIView

@property(nonatomic,weak) id<JDragonPickViewPickViewDelegate> delegate;
@property (nonatomic, strong) JDragonLocation *showLocation;
@property (nonatomic,strong) UIColor *lineColor;






/**
 *   城市选择pickview
 *
 *  @param cityPlistName      城市plistName
 *  @param isHaveNavControler
 *  @param str
 *
 *  @return
 */
-(instancetype)initPickviewWithCityPlist:(NSString*)cityPlistName isHaveNavController:(BOOL)isHaveNavControler titleStr:(NSString*)str;

/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字

 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param date               默认选中时间
 *  @param isHaveNavControler是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str;



-(instancetype)initDatePickWithYear:(NSInteger)year withMounth:(NSInteger)mounth isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str;

- (instancetype)initLiveStartPicker:(NSDate *)defaultDate isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString *)str;
/**
 *   移除本控件
 */
-(void)remove;
/**
 *  显示本控件
 */
-(void)show;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;

/**
 *  设置toolbar中间title标题
 */
-(void)setToolbarCenterTitleStr:(NSString*)str;
/**
 *  设置选中行
 */
-(void)setSeletedRow:(NSInteger)row;

-(void)setSeletedPick;




#pragma mark--------------------tools------------------

+(void)insertCitysDataToPlist:(NSArray *)array;
@end

