//
//  JDTimeCountDownManager.m
//  JDMovie
//
//  Created by JDragon on 2018/8/18.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDTimeCountDownManager.h"

@implementation JDTimeCountModel


@end
@interface JDTimeCountDownManager ()

@property (nonatomic, strong) NSMutableArray <JDTimeCountModel *> *dataArray;

@end

@implementation JDTimeCountDownManager


+ (JDTimeCountDownManager *)shareInstance{
    static JDTimeCountDownManager *helper;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[JDTimeCountDownManager alloc]init];
        }
    });
    return helper;
}

- (void)saveTimeWithID:(NSString *)timeId timeInterval:(NSTimeInterval)timeInterval{
    
    NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeId == '%@'",timeId];
    NSArray *exists = [self.dataArray filteredArrayUsingPredicate:predicate];
    [self.dataArray removeObjectsInArray:exists];
    
    JDTimeCountModel *time = [JDTimeCountModel new];
    time.finishDate = finishDate;
    time.timeId = timeId;
    
    [self.dataArray addObject:time];
}

- (NSTimeInterval)getTimeWithID:(NSString *)timeId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeId == %@",timeId];
    NSArray *exists = [self.dataArray filteredArrayUsingPredicate:predicate];
    
    if (exists.count == 0) {
        return 0;
    }
    
    JDTimeCountModel *time = [exists objectAtIndex:0];
    
    NSTimeInterval t = [time.finishDate timeIntervalSinceNow];
    
    if(t <= 0){
        [self.dataArray removeObject:time];
    }
    
    return t>0?t:0;
}

- (NSMutableArray<JDTimeCountModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
