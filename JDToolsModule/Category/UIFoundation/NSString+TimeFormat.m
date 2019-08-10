//
//  NSString+TimeFormat.m
//  JDBaseModule
//
//  Created by JDragon on 2018/9/20.
//

#import "NSString+TimeFormat.h"

@implementation NSString (TimeFormat)



#pragma mark - 时间戳 转 时间字符串
- (NSString *)timeFormatterFromTypeOne{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSInteger l = [self integerValue]/1000;
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:l];
    NSString *timeStr = [formatter stringFromDate:nowTime];
    return timeStr;
}

- (NSString *)timeFormatterMonthAndDateType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    [formatter setDateFormat:@"MM月dd日"];
    NSInteger l = [self integerValue]/1000;
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:l];
    NSString *timeStr = [formatter stringFromDate:nowTime];
    return timeStr;
}

- (NSString *)timeHourMinuteFormatterType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setDateFormat:@"HH:mm"];
    NSInteger l = [self integerValue]/1000;
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:l];
    NSString *timeStr = [formatter stringFromDate:nowTime];
    return timeStr;
}

//字符串转时间戳
- (NSString*)timeFormatterDDFromStringType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:self];
//
//    NSInteger interval = [timeZone secondsFromGMTForDate:date];
//
//    NSDate * nowDate = [date dateByAddingTimeInterval:interval];

    return [NSString  stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
}
//字符串转时间戳
- (NSString*)timeFormatterFromStringType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:self]; //------------将字符串按formatter转成nsdate
    return [NSString  stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
}

-(NSInteger)isCurrentTimeOutFromStringType
{
    NSInteger  endTime = [self integerValue];
    NSTimeInterval  date = [[NSDate date] timeIntervalSince1970];
    
    NSInteger  num =   endTime - date;
    
    return  num;
}

- (NSString *)timeDayHourMinuteFormatterType {
    
    NSInteger  timeout = [self integerValue];

    //设置倒计时显示的时间
    int days = (int)(timeout/(3600*24));
    int hours = (int)((timeout-days*24*3600)/3600);
    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
    int second = timeout-days*24*3600-hours*3600-minute*60;
    
    return [NSString stringWithFormat:@"%@天%@%@"];
}




@end
