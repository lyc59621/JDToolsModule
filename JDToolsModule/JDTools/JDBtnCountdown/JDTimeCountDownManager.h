//
//  JDTimeCountDownManager.h
//  JDMovie
//
//  Created by JDragon on 2018/8/18.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDTimeCountModel : NSObject
@property (nonatomic, strong) NSDate *finishDate;
@property (nonatomic, strong) NSString *timeId;
@end

@interface JDTimeCountDownManager : NSObject

+ (JDTimeCountDownManager *)shareInstance;

/**保存开始倒计时的date*/
- (void)saveTimeWithID:(NSString *)timeId timeInterval:(NSTimeInterval)timeInterval;

/**获取剩余时间*/
- (NSTimeInterval)getTimeWithID:(NSString *)timeId;

@end
