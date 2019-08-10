//
//  JDragonAlertView.h
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDragonAlertView : UIAlertView<UIAlertViewDelegate>


//UIAlertViewStyleDefault样式
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock;



//UIAlertViewStylePlainTextInput样式
+ (instancetype)alertPlainTextWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *plainText))confirmBlock;


//文本框右边带有按钮的alertView
+ (instancetype)alertCustomPlainTextWithTitle:(NSString *)title message:(NSString *)message
                            placeHold:(NSString *)placeHold
                          buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)sel
                cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *plainText))confirmBlock;


//UIAlertViewStyleLoginAndPasswordInput样式
//+ (void)alertLoginAndPasswordInputWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *login,NSString *password))confirmBlock;
@end
