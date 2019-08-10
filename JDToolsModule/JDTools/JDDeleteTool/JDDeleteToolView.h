//
//  JDDeleteToolView.h
//  JDMovie
//
//  Created by JDragon on 2018/9/1.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDSelectBlock)(NSNumber *isSelect);
typedef void(^DBlock)(void);


@interface JDDeleteToolView : UIView

@property (nonatomic, strong) UIButton  *selectBtn;
@property (nonatomic, strong) NSArray   *selectArray;


-(void)deleteBtnBlock:(DBlock)deleteBlock withSelectbtnBlock:(JDSelectBlock)selectBlock;
-(void)isShowDeleteView:(BOOL)isShow;
-(void)setDeleteSelectDataInfoWithArray:(NSArray *)selectArray;

@end
