//
//  JDPayCenterPickView.h
//  JDMovie
//
//  Created by JDragon on 2018/9/12.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PaySelectIndexBlock)(NSInteger index);

@interface JDPayCenterPickView : UIView

@property (nonatomic,copy) PaySelectIndexBlock selectedBlock;


+(JDPayCenterPickView*)instancePayCenterViewWithSelectBlock:(PaySelectIndexBlock)selectBlock;

- (void)show;


@end;
