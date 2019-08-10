//
//  PanelBottomView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "PanelBottomView.h"
#import "FaceThemeModel.h"
#import "ChatKeyBoardMacroDefine.h"
#import "JDToolsModuleHeader.h"

@implementation PanelBottomView
{
    UIButton        *_addBtn;
    UIScrollView    *_facePickerView;
    UIButton        *_sendBtn;
    UIButton        *_setBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    self.backgroundColor = [UIColor clearColor];
    _addBtn = [self createButtonWithImage:@"EmotionsBagAdd" widthIndex:0];
    _addBtn.frame = CGRectMake(0, 0, KBOTTOM_BUTTON_WIDTH, kFacePanelBottomToolBarHeight);
//    [self addSubview:_addBtn];
//    _addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    _addBtn.frame = CGRectMake(0, 0, kFacePanelBottomToolBarHeight, kFacePanelBottomToolBarHeight);
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    _facePickerView = [[UIScrollView alloc] initWithFrame:CGRectMake(kFacePanelBottomToolBarHeight, 0, kScreenWidth-2*kFacePanelBottomToolBarHeight, kFacePanelBottomToolBarHeight)];
    [self addSubview:_facePickerView];
    
//    _sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _sendBtn.frame = CGRectMake(kScreenWidth-kFacePanelBottomToolBarHeight, 0, kFacePanelBottomToolBarHeight, kFacePanelBottomToolBarHeight);
//    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _sendBtn.backgroundColor = HEXCOLOR(0x2662ec);
//    [_sendBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
//    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_sendBtn];
//
//    _setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _setBtn.frame = _sendBtn.frame;
//    [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
//    _setBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _setBtn.backgroundColor = HEXCOLOR(0x2662ec);
//    [_setBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
//    _setBtn.hidden = YES;
//    [_setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_setBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"Emotions_Send_Btn_Normal"] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"Emotions_Send_Btn_Normal"] forState:UIControlStateHighlighted];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"Emotions_Send_Btn_Disable"] forState:UIControlStateDisabled];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:THEXCOLOR(0xa8a9aa) forState:UIControlStateDisabled];
    [_sendBtn setTitleColor:THEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    _sendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _sendBtn.enabled = NO;
    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _sendBtn.frame = CGRectMake(kScreenWidth-60, 0, 60, kFacePanelBottomToolBarHeight);
    [self addSubview:_sendBtn];
}
- (void)sendEnabled:(BOOL)enabled {
    _sendBtn.enabled = enabled;
}


- (void)loadfaceThemePickerSource:(NSArray *)pickerSource
{
    for (int i = 0; i<pickerSource.count; i++) {
        FaceThemeModel *themeM = pickerSource[i];
        UIButton *btn = [self createButtonWithImage:themeM.themeIcon widthIndex:i];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.tag = i+100;
//        [btn setTitle:themeM.themeDecribe forState:UIControlStateNormal];
//        [btn setImage:IMAGE(@"EmotionsEmojiHL") forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(subjectPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*kFacePanelBottomToolBarHeight, 0, kFacePanelBottomToolBarHeight, kFacePanelBottomToolBarHeight);
        [_facePickerView addSubview:btn];
        
        if (i == pickerSource.count - 1) {
             NSInteger pages = CGRectGetMaxX(btn.frame) / CGRectGetWidth(_facePickerView.frame) + 1;
            _facePickerView.contentSize = CGSizeMake(pages*CGRectGetWidth(_facePickerView.frame), 0);
        }
    }
}

- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex
{
    [_facePickerView setContentOffset:CGPointMake(subjectIndex*kFacePanelBottomToolBarHeight, 0) animated:YES];
    
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.tag-100 == subjectIndex) {
                btn.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
    
    if (subjectIndex > 0) {
        _setBtn.hidden = NO;
        _sendBtn.hidden = YES;
    }else {
        _setBtn.hidden = YES;
        _sendBtn.hidden = NO;
    }
    
}

- (UIButton *)createButtonWithImage:(NSString *)imageName widthIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //右侧加一条竖线
//    CALayer *line = [CALayer layer];
//    line.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
//    line.frame = CGRectMake(KBOTTOM_BUTTON_WIDTH - 1,(kFacePanelBottomToolBarHeight - 25) / 2, 1, 25);
//    [button.layer addSublayer:line];
    return button;
}


#pragma mark -- 点击事件

- (void)addBtnClick:(UIButton *)sender
{
    if (self.addAction) {
        self.addAction();
    }
}

- (void)sendBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(panelBottomViewSendAction:)]) {
        [self.delegate panelBottomViewSendAction:self];
    }
}

- (void)setBtnClick:(UIButton *)sender
{
    if (self.setAction) {
        self.setAction();
    }
}

- (void)subjectPicBtnClick:(UIButton *)sender
{
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn == sender) {
                sender.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
    
    if (sender.tag-100 > 0) {
        _setBtn.hidden = NO;
        _sendBtn.hidden = YES;
    }else {
        _setBtn.hidden = YES;
        _sendBtn.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(panelBottomView:didPickerFaceSubjectIndex:)]) {
        [self.delegate panelBottomView:self didPickerFaceSubjectIndex:sender.tag-100];
    }
}


@end
