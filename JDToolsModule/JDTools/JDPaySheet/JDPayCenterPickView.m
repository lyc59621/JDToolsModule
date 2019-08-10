//
//  JDPayCenterPickView.m
//  JDMovie
//
//  Created by JDragon on 2018/9/12.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDPayCenterPickView.h"
#import "JDPopupViewPage.h"
#import "JKCategories.h"

@interface JDPayCenterPickView()



@property (nonatomic,copy) PaySelectIndexBlock  selectBlock;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) UITableView *aTableView;
@property (nonatomic,strong) JDragonTableManager *tabDataSource;
@property (nonatomic,strong) NSArray *tabImages;
@property (nonatomic,strong) NSArray *tabTitles;
@property (strong, nonatomic)JDPopupViewPage *popupViewPage;


@end

@implementation JDPayCenterPickView

-(NSArray*)tabImages
{
    
    return @[@"icAlipay",@"icWechatPay",@"icApplePay"];
    return @[@"icAlipay",@"icWechatPay",];

}
-(NSArray*)tabTitles
{
//    return @[@"支付宝",@"微信支付",@"Apple Pay"];
      return @[@"支付宝",@"微信支付",@"In-App-Purchase"];
    return @[@"支付宝",@"微信支付",];

}

-(UIView*)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
    }
    return _titleView;
}
-(UIButton*)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:IMAGE(@"icCloseGray") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(didClickCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(UILabel*)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HEXCOLOR(0x454545);
        _titleLab.font = KJD_FONT_Medium(16);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"选择支付方式";
    }
    return _titleLab;
}
-(JDBaseTableView*)aTableView
{
    if (!_aTableView) {
        WS(weaKSelf);
       _aTableView = [[JDBaseTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _aTableView.backgroundColor = KClearColor;
        _aTableView.separatorColor = HEXCOLOR(0xf5f5f5);
        _aTableView.scrollEnabled = false;
        [_aTableView registerNib:[UINib nibWithNibName:@"JDPayCenterCell" bundle:nil] forCellReuseIdentifier:@"JDPayCenterCell"];
        CGRect frame=CGRectMake(0, 0, 0, CGFLOAT_MIN);
        _aTableView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
        _aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tabDataSource = [_aTableView JDTab_DataSourceWithTabType:NumberOfRowsInSectionOne withVC:nil isSection:true reuseIdentifier:@"JDPayCenterCell"];
        [_tabDataSource setCellAutoHeightAndeHeaderHeight:0.0001 footerHeight:0 selectBlock:^(NSIndexPath *indexPath) {
            weaKSelf.selectBlock(indexPath.section);
            [weaKSelf.popupViewPage dismiss];
        }];

    }
    return _aTableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(JDPayCenterPickView*)instancePayCenterViewWithSelectBlock:(PaySelectIndexBlock)selectBlock
{
//    JDPayCenterPickView *pay = [[JDPayCenterPickView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200-48)];
    JDPayCenterPickView *pay = [[JDPayCenterPickView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
    pay.selectBlock = selectBlock;
    return pay;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIConfig];
    }
    return self;
}
-(void)setUIConfig
{
    [self jk_setRoundedCorners:UIRectCornerTopLeft radius:8];
    [self jk_setRoundedCorners:UIRectCornerTopRight radius:8];
    self.backgroundColor = KWhiteColor;
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.closeBtn];
    [self.titleView addSubview:self.titleLab];
    [self addSubview:self.aTableView];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] init];
    visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView.frame = self.bounds;
    [self insertSubview:visualEffectView atIndex:0];
    
    WS(weakSelf);
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(0);
        make.height.equalTo(53);
    }];
    [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    [self.aTableView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.titleView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(0);
    }];
    NSMutableArray  *tempArr = [[NSMutableArray alloc]init];
    for (int i=0; i<self.tabImages.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:self.tabTitles[i] forKey:@"title"];
        [dic setValue:self.tabImages[i] forKey:@"image"];
        [tempArr addObject:dic];
    }
    [self.tabDataSource updateReloadData:tempArr];
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
- (void)doneAction{
    
    [UIView animateWithDuration:.3 animations:^{
        self.maskView.alpha = 0;
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 180);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
    
}
-(void)didClickCloseBtnAction
{
    [self.popupViewPage dismiss];
}
- (void)cancleAction{
    
//    [UIView animateWithDuration:.3 animations:^{
//        self.maskView.alpha = 0;
//        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 180);
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        [self.maskView removeFromSuperview];
//    }];
    
    [self.popupViewPage dismiss];
}
- (void)show{

    self.popupViewPage = [JDPopupViewPage new];
    self.popupViewPage.layoutType = JDPopupLayoutTypeBottom;
    self.popupViewPage.dismissOnMaskTouched = YES;
    UIView  *v= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
    [self.popupViewPage presentContentView:self];
}



@end
