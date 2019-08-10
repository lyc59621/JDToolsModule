//
//  JDragonLocation.h
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDragonLocation : NSObject


@property (copy, nonatomic) NSString *provinceID;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *cities;


@property (copy, nonatomic) NSString *cityID;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *isFrequently;



@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *mounth;


@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
