//
//  JDDeleteToolView.m
//  JDMovie
//
//  Created by JDragon on 2018/9/1.
//  Copyright © 2018年 JDragon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JDDeleteToolView.h"
#if __has_include("Masonry.h")
#import "Masonry.h"
#endif



@interface JDDeleteToolView ()

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIButton  *deleteBtn;
@property (nonatomic, strong) UIView    *lineView;
@property (nonatomic, strong) UIView    *topLineView;

@property (nonatomic, copy) JDSelectBlock  lSelectBlock;
@property (nonatomic, copy) DBlock  deleteBlock;



@end


@implementation JDDeleteToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIButton*)selectBtn
{
    if (_selectBtn==nil) {
        self.selectBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn  setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectBtn  setTitle:@"取消全选" forState:UIControlStateSelected];
        [self.selectBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.selectBtn.titleLabel setFont:[UIFont systemFontOfSize:(CGFloat)15]];
        [self.selectBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.selectBtn addTarget:self action:@selector(didClickAllSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
-(UIButton*)deleteBtn
{
    if (_deleteBtn==nil) {
        self.deleteBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:(CGFloat)15]];
        [self.deleteBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.deleteBtn addTarget:self action:@selector(didClickDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.enabled = false;
    }
    return _deleteBtn;
}
-(UIView*)lineView
{
    if (_lineView==nil) {
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _lineView;
}
-(UIView*)topLineView
{
    if (_topLineView==nil) {
        self.topLineView = [[UIView alloc]init];
        self.topLineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _topLineView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self setUiconfig];
        [self updateViewConstraints];
    }
    return  self;
}
-(void)setUiconfig
{
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.topLineView];
    [self addSubview:self.selectBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.lineView];
}
-(void)updateViewConstraints
{
    
#if __has_include("Masonry.h")

    if (!self.didSetupConstraints)
    {


        [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.left.bottom.equalTo(@0);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        [self.deleteBtn  mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.bottom.right.equalTo(@0);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@6);
            make.bottom.equalTo(@-6);
            make.width.equalTo(@0.5);
        }];
        self.didSetupConstraints = true;
    }
#else
        NSAssert(NO, @"请导入Masnory");
#endif
}
-(void)deleteBtnBlock:(DBlock)deleteBlock withSelectbtnBlock:(JDSelectBlock)selectBlock
{
    self.deleteBlock = deleteBlock;
    self.lSelectBlock = selectBlock;
}
-(void)didClickAllSelectBtnAction:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (self.lSelectBlock)
    {
        self.lSelectBlock([NSNumber numberWithBool:btn.selected]);
    }
}
-(void)didClickDeleteBtnAction:(UIButton*)btn
{
    if (self.deleteBlock)
    {
        self.deleteBlock();
    }
}
-(void)isShowDeleteView:(BOOL)isShow
{
    if (isShow)
    {
        [self   showDeleteView];
        
    }else
    {
        [self   hideDeleteView];
    }
}
-(void)showDeleteView
{
    if (!self.isShow) {
        CGRect  frame  = self.frame;
        frame.origin.y -= 50 ;
        self.isShow = true;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = frame;
        }];
    }
}
-(void)hideDeleteView
{
    if (self.isShow) {
        CGRect  frame  = self.frame;
        frame.origin.y += 50 ;
        self.isShow = false;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = frame;
        }];
    }
}
-(void)setDeleteSelectDataInfoWithArray:(NSArray *)selectArray
{
    self.selectArray = selectArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (selectArray.count==0)
        {
            self.deleteBtn.enabled = false;
            self.selectBtn.selected = false;
            [self.deleteBtn  setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else
        {
            self.deleteBtn.enabled = true;
            [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",(unsigned long)selectArray.count] forState:UIControlStateNormal];
        }
    });
}
@end
