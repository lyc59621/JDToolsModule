//
//  UIButton+JDTimeCount.h
//  JDMovie
//
//  Created by JDragon on 2018/8/18.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JDTimeCount)


@property (nonatomic, weak) dispatch_source_t timer;

/**检测是否还没有倒计时完*/
- (void)checkTimeWithTimeId:(NSString *)timeId
                      title:(NSString *)title
             countDownTitle:(NSString *)subTitle;


/**
 开始倒计时

 @param timeLine <#timeLine description#>
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param startWithTime <#startWithTime description#>
 @param timeLine <#timeLine description#>
 @param maxTime <#maxTime description#>
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param timeId <#timeId description#>
 @param complete <#complete description#>
 */
- (void)startWithTime:(NSTimeInterval)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
               timeId:(NSString *)timeId;


/**
 <#Description#>

 @param timeLine <#timeLine description#>
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param timeId <#timeId description#>
 @param complete <#complete description#>
 */
- (void)startWithTime:(NSTimeInterval)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
               timeId:(NSString *)timeId
             complete:(void(^)(void))complete;


/**
 开始倒计时2

 @param timeLine <#timeLine description#>
 @param maxTime <#maxTime description#>
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param mColor <#mColor description#>
 @param color <#color description#>
 @param timeId <#timeId description#>
 @param complete <#complete description#>
 */
- (void)startWithTime:(NSTimeInterval)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color
               timeId:(NSString *)timeId
        complete:(void(^)(void))complete;

/**退出*/
- (void)cancelTimer;

@end
