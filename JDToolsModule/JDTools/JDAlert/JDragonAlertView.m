//
//  JDragonAlertView.m
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import "JDragonAlertView.h"

@interface JDragonAlertView()

@property(copy,nonatomic)void (^cancelClicked)();

//@property(copy,nonatomic)void (^confirmClicked)();

@property (copy, nonatomic)void (^confirmClicked)(NSString *plainText);

@end
@implementation JDragonAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//增加plainText的返回值
-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock{
self=[super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
if (self) {
    _cancelClicked=[cancelblock copy];
    _confirmClicked=[confirmBlock copy];
}
return self;
}

+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock{
JDragonAlertView *alert=[[JDragonAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
    [alert show];
    return alert;
}


//UIAlertViewStylePlainTextInput样式
+ (instancetype)alertPlainTextWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *plainText))confirmBlock {
    JDragonAlertView *alert=[[JDragonAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    return alert;
}


//文本框右边带有按钮的alertView
+ (instancetype)alertCustomPlainTextWithTitle:(NSString *)title message:(NSString *)message
                            placeHold:(NSString *)placeHold
                          buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)sel
                cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *plainText))confirmBlock {
    JDragonAlertView *alert=[[JDragonAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = placeHold;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 20);
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:85/255.0 green:185/255.0 blue:214/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = textField.frame;
    rect.size.height = 50;
    textField.frame = rect;
    textField.rightView = button;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [alert show];
    return alert;

}

/*
 //UIAlertViewStyleLoginAndPasswordInput样式
 + (void)alertLoginAndPasswordInputWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)(NSString *login,NSString *password))confirmBlock {
 BlockAlertView *alert=[[BlockAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
 alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
 [alert show];
 }
 */

#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //如果只显示一个button，因判断buttonIndex的数值，不准确，所以更改为直接判断是否是cancelButton
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (self.confirmClicked) {
            if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
                self.confirmClicked([alertView textFieldAtIndex:0].text);
            }else {
                self.confirmClicked(@"");
            }
        }
    }else {
        if (self.cancelClicked) {
            self.cancelClicked();
        }
    }
}

@end
