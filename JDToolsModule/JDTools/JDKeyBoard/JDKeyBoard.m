//
//  JDKeyBoard.m
//  JDToolsModule
//
//  Created by JDragon on 2018/10/31.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDKeyBoard.h"
#import "ChatKeyBoardMacroDefine.h"
#import "JKCategories.h"


// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define IsIPhoneX                           (ScreenHeight == 812 || ScreenWidth == 812||ScreenHeight == 896 || ScreenWidth == 896)

@implementation JDKeyBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/**
*  调整关联的表的高度
*/
- (void)updateAssociateTableViewFrame
{
    
    UITableView  *tab = [self valueForKey:@"_associateTableView"];
    //表的原来的偏移量
    CGFloat original =  tab.contentOffset.y;

    CGFloat lastChatKeyboardY = [[self valueForKey:@"lastChatKeyboardY"] jk_CGFloatValue];

    CGFloat  tabY = self.associateTableView.frame.origin.y;
    //键盘的y坐标的偏移量
    CGFloat keyboardOffset = self.frame.origin.y - lastChatKeyboardY;
    
    //更新表的frame
    //    CGFloat tableHeight = IS_IPHONEX_All ? kScreenHeight - kNavBarHAbove - 83 : kScreenHeight - kNavBarHAbove - 49;
    tab.frame = CGRectMake(0, tabY+keyboardOffset, tab.size.width, tab.size.height);
    //表的超出frame的内容高度
    CGFloat tableViewContentDiffer = tab.contentSize.height - tab.frame.size.height;
    //是否键盘的偏移量，超过了表的整个tableViewContentDiffer尺寸
    CGFloat offset = 0;
    if (fabs(tableViewContentDiffer) > fabs(keyboardOffset)) {
        offset = original-keyboardOffset;
    }else {
        offset = tableViewContentDiffer;
    }
    
    if (tab.contentSize.height +tab.contentInset.top+tab.contentInset.bottom> tab.frame.size.height) {
        //        _associateTableView.contentOffset = CGPointMake(0, offset);
    }
}
@end
