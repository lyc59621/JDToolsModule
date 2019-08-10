//
//  NSString+TimeFormat.h
//  JDBaseModule
//
//  Created by JDragon on 2018/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TimeFormat)


#pragma mark -------------------------时间转换 -------------------------------------
/**
 *  时间戳转时间 2015-12-12 格式
 *
 *  @param ts 传入时间戳
 *
 *  @return 返回2015-12-12 格式字符
 */
- (NSString *)timeFormatterFromTypeOne;

/**
 * 时间戳转时间 2015年12月12日 12:12:22
 *
 *  @param ts 传入时间戳
 *
 *  @return 返回2015年12月12日 12:12:22
 */
- (NSString *)timeFormatterMonthAndDateType;
/**
 *  时间戳转时间 HH:mm
 *
 *  @param ts
 *
 *  @return 返回HH:mm 格式字符
 */
- (NSString *)timeHourMinuteFormatterType;


//字符串转时间戳
- (NSString*)timeFormatterDDFromStringType;

//字符串转时间戳
- (NSString*)timeFormatterFromStringType;

/**
 *  时间戳对比
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)isCurrentTimeOutFromStringType;



/**
 时间戳转时间差
 
 @return dd天HH小时mm分
 */
- (NSString *)timeDayHourMinuteFormatterType;

@end

NS_ASSUME_NONNULL_END
