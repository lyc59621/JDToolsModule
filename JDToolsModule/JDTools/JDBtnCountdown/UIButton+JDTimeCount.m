//
//  UIButton+JDTimeCount.m
//  JDMovie
//
//  Created by JDragon on 2018/8/18.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "UIButton+JDTimeCount.h"
#import "JDTimeCountDownManager.h"
#import <objc/runtime.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static NSString *timerKey = @"timerKey";

@implementation UIButton (JDTimeCount)

- (void)checkTimeWithTimeId:(NSString *)timeId
                      title:(NSString *)title
             countDownTitle:(NSString *)subTitle{
    
    NSTimeInterval timeInterval = [[JDTimeCountDownManager shareInstance] getTimeWithID:timeId];
    
    if (timeInterval) {
        [self startWithTime:timeInterval  title:title countDownTitle:subTitle timeId:timeId complete:^{
            
        }];
    }
}

- (void)startWithTime:(NSTimeInterval)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
               timeId:(NSString *)timeId{
    [self startWithTime:timeLine  title:title countDownTitle:subTitle mainColor:nil countColor:nil timeId:timeId complete:nil];
}
- (void)startWithTime:(NSTimeInterval)timeLine
        title:(NSString *)title
        countDownTitle:(NSString *)subTitle
        timeId:(NSString *)timeId
        complete:(void(^)(void))complete
{
     [self startWithTime:timeLine  title:title countDownTitle:subTitle mainColor:nil countColor:nil timeId:timeId complete:complete];
}

- (void)startWithTime:(NSTimeInterval)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color
               timeId:(NSString *)timeId
        complete:(void(^)(void))complete{
    
    NSTimeInterval timeInterval = [[JDTimeCountDownManager shareInstance] getTimeWithID:timeId];
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    
    if (timeInterval) {
        timeOut = timeInterval;
    }else{
        [[JDTimeCountDownManager shareInstance] saveTimeWithID:timeId timeInterval:timeLine];
    }
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = _timer;
    
    //每秒执行一次
    WS(weakSelf);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            self.timer = nil;
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(mColor) self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
                if (complete) {
                    complete();
                }
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(color)self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)cancelTimer{
    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)setTimer:(dispatch_source_t)timer{
    //关联对象
    objc_setAssociatedObject(self, &timerKey, timer, OBJC_ASSOCIATION_ASSIGN);
}

- (dispatch_source_t)timer{
    return objc_getAssociatedObject(self, &timerKey);
}

@end
