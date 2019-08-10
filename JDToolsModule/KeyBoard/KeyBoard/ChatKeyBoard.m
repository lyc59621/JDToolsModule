//
//  ChatKeyBoard.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/29.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "ChatKeyBoard.h"
#import "OfficialAccountToolbar.h"
#import "NSString+Emoji.h"
#import "JDBaseModuleHeader.h"
#import "JDTimToolsHeader.h"

@interface ChatKeyBoard () <ChatToolBarDelegate, FacePanelDelegate, MorePannelDelegate>
{
    __weak UITableView *_associateTableView;    //chatKeyBoard关联的表
}

@property (nonatomic, strong) ChatToolBar *chatToolBar;
@property (nonatomic, strong) FacePanel *facePanel;
@property (nonatomic, strong) MorePanel *morePanel;
@property (nonatomic, strong) OfficialAccountToolbar *OAtoolbar;

/**
 *  聊天键盘 上一次的 y 坐标
 */
@property (nonatomic, assign) CGFloat lastChatKeyboardY;

@end

@implementation ChatKeyBoard

#pragma mark -- life

+ (instancetype)keyBoard
{
    return [self keyBoardWithNavgationBarTranslucent:YES];
}

/**
 *  如果导航栏是透明的，则键盘的初始位置为 kScreenHeight-kChatToolBarHeight
 *
 *  否则，导航栏的高度为 kScreenHeight-kChatToolBarHeight-64
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent
{
    CGRect frame = CGRectZero;
    CGFloat toolBarY;
    if (kIPHONE_X) {
        toolBarY = kScreenHeight - kChatToolBarHeight - 34.0f;
    } else {
        toolBarY = kScreenHeight - kChatToolBarHeight;
    }
    if (translucent) {
        frame = CGRectMake(0, toolBarY, kScreenWidth, kChatKeyBoardHeight);
    }else {
        frame = CGRectMake(0, toolBarY - 64, kScreenWidth, kChatKeyBoardHeight);
    }
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds
{
    
    CGFloat toolBarY;
    if (kIPHONE_X) {
        toolBarY = bounds.size.height - kChatToolBarHeight - 34.0f;
    } else {
        toolBarY = bounds.size.height - kChatToolBarHeight;
    }
    
    CGRect frame = CGRectMake(0, toolBarY, kScreenWidth, kChatKeyBoardHeight);
    if (@available(iOS 11.0, *)) {
//        CGFloat  safeHH = self.safeAreaInsets.bottom;
//        frame.origin.y-= safeHH
    } else {
        // Fallback on earlier versions
    }
    
    return [[self alloc] initWithFrame:frame];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.chatToolBar.frame"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kChatKeyBoardColor;
        [self addSubview:self.chatToolBar];
        [self addSubview:self.facePanel];
        [self addSubview:self.morePanel];
        [self addSubview:self.OAtoolbar];
        
        __weak __typeof(self) weakself = self;
        self.OAtoolbar.switchAction = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakself.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(weakself.frame), CGRectGetWidth(weakself.frame), kChatToolBarHeight);
                CGFloat y = weakself.frame.origin.y;
                y = [weakself getSuperViewH] - weakself.chatToolBar.frame.size.height;
             
                weakself.frame = CGRectMake(0, y, weakself.frame.size.width, weakself.frame.size.height);
            }];
        };
        
        self.lastChatKeyboardY = frame.origin.y;
        self.facePanel.hidden = true;
        self.morePanel.hidden = true;

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self addObserver:self forKeyPath:@"self.chatToolBar.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

#pragma mark -- 跟随键盘的坐标变化
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 键盘已经弹起时，表情按钮被选择
    if (self.chatToolBar.faceSelected)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = YES;
            self.facePanel.hidden = NO;
            self.lastChatKeyboardY = self.frame.origin.y;

            CGFloat toolBarY=0;
            if (kIPHONE_X) {
                toolBarY =   34.0f;
            } else {
            }
            
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame)-toolBarY, kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        } completion:nil];
    }
    // 键盘已经弹起时，more按钮被选择
    else if (self.chatToolBar.moreFuncSelected)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = NO;
            self.facePanel.hidden = YES;
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            
            CGFloat chatToolBarHeight = CGRectGetHeight(self.frame) - kMorePanelHeight;
            
            CGFloat targetY = end.origin.y - chatToolBarHeight - (kScreenHeight - [self getSuperViewH]);

            if(begin.size.height>=0 && (begin.origin.y-end.origin.y>0))
            {
                // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                
                self.lastChatKeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                [self updateAssociateTableViewFrame];
                
            }
            else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘收起
                CGFloat toolBarY;
                if (kIPHONE_X) {
                    toolBarY = targetY - 34.0f;
                } else {
                    toolBarY = targetY;
                }
                
                if (self.keyBoardStyle == KeyBoardStyleChat)
                {
                    self.frame = CGRectMake(0, toolBarY, CGRectGetWidth(self.frame), self.frame.size.height);
                    
                }else if (self.keyBoardStyle == KeyBoardStyleComment)
                {
                    if (self.chatToolBar.voiceSelected)
                    {
                        self.frame = CGRectMake(0, toolBarY, CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                    else
                    {
                        self.frame = CGRectMake(0, [self getSuperViewH], CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                }
                [self updateAssociateTableViewFrame];
                
            }
            else if ((begin.origin.y-end.origin.y<0) && duration == 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘切换
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                [self updateAssociateTableViewFrame];
            }
            
        }];
    }
}

/**
 *  调整关联的表的高度
 */
- (void)updateAssociateTableViewFrame
{
    // 表的原来的偏移量
    CGFloat original =  _associateTableView.contentOffset.y;
    
    //键盘的y坐标的偏移量
    CGFloat keyboardOffset = self.frame.origin.y - self.lastChatKeyboardY;
    
    //更新表的frame
    CGFloat tabHeight = self.frame.origin.y - (kIPHONE_X ? 88.0f : 64.0f);
    _associateTableView.frame = CGRectMake(0, kIPHONE_X == 1 ? 88 : 64, self.frame.size.width, tabHeight);
    
    if (_associateTableView.contentSize.height > _associateTableView.frame.size.height) {
        // 如果tableView的内容高度比本身高度高，将tableView滚动到最后一行
        [_associateTableView scrollToBottom];
    }
}
#pragma mark -- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.chatToolBar.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
        self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
        self.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), kChatToolBarHeight);
        
        [self updateAssociateTableViewFrame];
    }
}

#pragma mark -- ChatToolBarDelegate

/**
 *  语音按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar voiceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    self.morePanel.hidden = true;
    self.facePanel.hidden = true;
    if (select && change == NO) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat y = self.frame.origin.y;
            y = kIPHONE_X ? [self getSuperViewH] - self.chatToolBar.frame.size.height - 34 : [self getSuperViewH] - self.chatToolBar.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}

/**
 *  表情按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar faceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = YES;
        self.facePanel.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat toolBarY=0;
            if (IS_IPHONEX) {
                toolBarY =   34.0f;
            } else {
            }
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame)-toolBarY, kScreenWidth, CGRectGetHeight(self.frame));
//            CGFloat y = self.frame.origin.y;
//            y = kIPHONE_X ? [self getSuperViewH] - CGRectGetHeight(self.frame) - 34 : [self getSuperViewH] - CGRectGetHeight(self.frame);
//            self.frame = CGRectMake(0, y, kScreenWidth, CGRectGetHeight(self.frame));
        
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}

/**
 *  more按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar moreBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = NO;
        self.facePanel.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat toolBarY=0;
            if (IS_IPHONEX) {
                toolBarY =   34.0f;
            } else {
            }
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame)-toolBarY, kScreenWidth, CGRectGetHeight(self.frame));
            
//            CGFloat y = self.frame.origin.y;
//            y = kIPHONE_X ? [self getSuperViewH] - CGRectGetHeight(self.frame) - 34 : [self getSuperViewH] - CGRectGetHeight(self.frame);
//            self.frame = CGRectMake(0, y, kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}
- (void)chatToolBarSwitchToolBarBtnPressed:(ChatToolBar *)toolBar keyBoardState:(BOOL)change
{
    if (change == NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat y = self.frame.origin.y;
            y = kIPHONE_X ? [self getSuperViewH] - self.chatToolBar.frame.size.height - 34 : [self getSuperViewH] - self.chatToolBar.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
            [self updateAssociateTableViewFrame];
            
        }];
    }
    else
    {
        self.lastChatKeyboardY = self.frame.origin.y;
        CGFloat y = self.frame.origin.y;
        y = kIPHONE_X ? [self getSuperViewH] - self.chatToolBar.frame.size.height - 34 : [self getSuperViewH] - self.chatToolBar.frame.size.height;
        self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
        
        [self updateAssociateTableViewFrame];
        
    }
}

- (void)chatToolBarDidStartRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidStartRecording:)]) {
        [self.delegate chatKeyBoardDidStartRecording:self];
    }
}
- (void)chatToolBarDidCancelRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidCancelRecording:)]) {
        [self.delegate chatKeyBoardDidCancelRecording:self];
    }
}
- (void)chatToolBarDidFinishRecoding:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidFinishRecoding:)]) {
        [self.delegate chatKeyBoardDidFinishRecoding:self];
    }
}
- (void)chatToolBarWillCancelRecoding:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardWillCancelRecoding:)]) {
        [self.delegate chatKeyBoardWillCancelRecoding:self];
    }
}
- (void)chatToolBarContineRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardContineRecording:)]) {
        [self.delegate chatKeyBoardContineRecording:self];
    }
}

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}

- (void)chatToolBarSendText:(NSString *)text
{
    [self.chatToolBar clearTextViewContent];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
}

- (void)chatToolBarTextViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
        [self.delegate chatKeyBoardTextViewDidChange:textView];
    }
}

- (void)chatToolBarTextViewDeleteBackward:(RFTextView *)textView
{
    NSRange range = textView.selectedRange;
    NSString *handleText;
    NSString *appendText;
    if (range.location == textView.text.length) {
        handleText = textView.text;
        appendText = @"";
    }else {
        handleText = [textView.text substringToIndex:range.location];
        appendText = [textView.text substringFromIndex:range.location];
    }
    
    if (handleText.length > 0) {
        
        [self deleteBackward:handleText appendText:appendText];
    }
}

#pragma mark -- FacePanelDelegate
- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName isDeleteKey:(BOOL)deletekey
{
    NSString *text = self.chatToolBar.textView.text;
    
    if (deletekey == YES)
    {
        if (text.length <= 0) {
            [self.chatToolBar setTextViewContent:@""];
            [self.facePanel setFacePanelSendBtnState:false];
        }else {
            [self deleteBackward:text appendText:@""];
        }
    }else {
        [self.chatToolBar setTextViewContent:[text stringByAppendingString:faceName]];
        [self.facePanel setFacePanelSendBtnState:true];

    }
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.chatToolBar.textView.text];
    }
    [self.chatToolBar clearTextViewContent];
//    self.chatToolBar.faceBtn.selected = !self.chatToolBar.faceBtn.selected;
//    self.facePanel.hidden = true;
}

- (void)facePanelAddSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
        [self.delegate chatKeyBoardAddFaceSubject:self];
    }
}
- (void)facePanelSetSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
        [self.delegate chatKeyBoardSetFaceSubject:self];
    }
}

#pragma mark -- MorePannelDelegate
- (void)morePannel:(MorePanel *)morePannel didSelectItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoard:didSelectMorePanelItemIndex:)]) {
        [self.delegate chatKeyBoard:self didSelectMorePanelItemIndex:index];
    }
}
#pragma mark -- dataSource

- (void)setDataSource:(id<ChatKeyBoardDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardToolbarItems)]) {
        NSArray<ChatToolBarItem *> *barItems = [self.dataSource chatKeyBoardToolbarItems];
        [self.chatToolBar loadBarItems:barItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardMorePanelItems)]) {
        NSArray<MoreItem *> *moreItems = [self.dataSource chatKeyBoardMorePanelItems];
        [self.morePanel loadMoreItems:moreItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardFacePanelSubjectItems)]) {
        NSArray<FaceThemeModel *> *themeItems = [self.dataSource chatKeyBoardFacePanelSubjectItems];
        [self.facePanel loadFaceThemeItems:themeItems];
    }
}

#pragma mark -- set方法
- (void)setAssociateTableView:(UITableView *)associateTableView
{
    if (_associateTableView != associateTableView) {
        _associateTableView = associateTableView;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    [self.chatToolBar setTextViewPlaceHolder:placeHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    
    [self.chatToolBar setTextViewPlaceHolderColor:placeHolderColor];
}

-(void)setAllowVoice:(BOOL)allowVoice
{
    self.chatToolBar.allowVoice = allowVoice;
}

- (void)setAllowFace:(BOOL)allowFace
{
    self.chatToolBar.allowFace = allowFace;
}

- (void)setAllowMore:(BOOL)allowMore
{
    self.chatToolBar.allowMoreFunc = allowMore;
}

- (void)setAllowSwitchBar:(BOOL)allowSwitchBar
{
    self.chatToolBar.allowSwitchBar = allowSwitchBar;
}

- (void)setKeyBoardStyle:(KeyBoardStyle)keyBoardStyle
{
    _keyBoardStyle = keyBoardStyle;
    
    if (keyBoardStyle == KeyBoardStyleComment) {
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y+kChatToolBarHeight, self.frame.size.width, self.frame.size.height);
    }
}

- (void)keyboardUp
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        [self.chatToolBar prepareForBeginComment];
        [self.chatToolBar.textView becomeFirstResponder];
    }
    else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardUpforComment" userInfo:nil];
        [excp raise];
    }
}

- (void)keyboardDown
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        if ([self.chatToolBar.textView isFirstResponder])
        {
            [self.chatToolBar.textView resignFirstResponder];
        }
        else
        {
            if(([self getSuperViewH] - CGRectGetMinY(self.frame)) > self.chatToolBar.frame.size.height)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.lastChatKeyboardY = self.frame.origin.y;
                    CGFloat y = self.frame.origin.y;
                    y = kIPHONE_X ? [self getSuperViewH] - self.chatToolBar.frame.size.height - 34 : [self getSuperViewH] - self.chatToolBar.frame.size.height;
                    self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
                    CGFloat panelY = kIPHONE_X ? CGRectGetHeight(self.frame) + 34.0f : CGRectGetHeight(self.frame);
                    self.facePanel.frame = CGRectMake(0, panelY, kScreenWidth, kFacePanelHeight);
                    self.morePanel.frame = CGRectMake(0, panelY, kScreenWidth, kFacePanelHeight);
                    [self updateAssociateTableViewFrame];
                    
                }];
                
            }
        }
    }else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardDownForComment" userInfo:nil];
        [excp raise];
    }
}

- (void)keyboardUpforComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [self.chatToolBar prepareForBeginComment];
    [self.chatToolBar.textView becomeFirstResponder];
}

- (void)keyboardDownForComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.lastChatKeyboardY = self.frame.origin.y;
        
        [self.chatToolBar prepareForEndComment];
        self.frame = CGRectMake(0, [self getSuperViewH], self.frame.size.width, CGRectGetHeight(self.frame));
        
        [self updateAssociateTableViewFrame];
        
    } completion:nil];
}

- (CGFloat)getSuperViewH
{
    if (self.superview == nil) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"未添加到父视图上面" userInfo:nil];
        [excp raise];
    }
    
    return self.superview.frame.size.height;
}

#pragma mark - 回删表情或文字

- (void)deleteBackward:(NSString *)text appendText:(NSString *)appendText
{
    if (IsTextContainFace(text)) { // 如果最后一个是表情
        
        NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
        NSString *current = [text substringToIndex:startRang.location];
        [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
        self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        if (self.chatToolBar.textView.text.length<=0) {
            [self.facePanel setFacePanelSendBtnState:false];
        }
    }else { // 如果最后一个系统键盘输入的文字
        
        if (text.length >= 2) {
            
            NSString *tempString = [text substringWithRange:NSMakeRange(text.length - 2, 2)];
            
            if ([tempString isEmoji]) { // 如果是Emoji表情
                NSString *current = [text substringToIndex:text.length - 2];
                
                [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
                self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
                
            }else { // 如果是纯文字
                NSString *current = [text substringToIndex:text.length - 1];
                [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
                self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
            }
            
        }else { // 如果是纯文字
            
            NSString *current = [text substringToIndex:text.length - 1];
            [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        }
    }
}

#pragma mark -- 懒加载
- (ChatToolBar *)chatToolBar
{
    if (!_chatToolBar) {
        _chatToolBar = [[ChatToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kChatToolBarHeight)];
        _chatToolBar.delegate = self;
    }
    return _chatToolBar;
}

- (FacePanel *)facePanel
{
    if (!_facePanel) {
        CGFloat y;
        if (kIPHONE_X) {
            y = kChatKeyBoardHeight - kFacePanelHeight + 34.0f;
        } else {
            y = kChatKeyBoardHeight - kFacePanelHeight;
        }
        _facePanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kFacePanelHeight)];
        _facePanel.delegate = self;
    }
    return _facePanel;
}

- (MorePanel *)morePanel
{
    if (!_morePanel) {
        _morePanel = [[MorePanel alloc] initWithFrame:self.facePanel.frame];
        _morePanel.delegate = self;
    }
    return _morePanel;
}

- (OfficialAccountToolbar *)OAtoolbar
{
    if (!_OAtoolbar) {
        _OAtoolbar = [[OfficialAccountToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kChatToolBarHeight)];
        _OAtoolbar.backgroundColor = kChatKeyBoardColor;
    }
    return _OAtoolbar;
}

@end
