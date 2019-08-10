//
//  JDVerifyCodeView.m
//  JDMovie
//
//  Created by Shen Su on 2018/8/17.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import "JDVerifyCodeView.h"
#import "UITextField+GTExtend.h"
#import "JKUIKit.h"
#import "JDToolsModuleHeader.h"

#define verifyEnableColor THEXCOLOR(0xffffff)
#define verifyDisabledColor THEXCOLOR(0xf1f1f1)

@interface UIView (JDLayout)


///圆角
- (void)setCornerWithRadius:(CGFloat)radius;
///圆角加边框
- (void)setCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

@end
@implementation UIView (JDLayout)

- (void)setCornerWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
- (void)setCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

@end



@interface JDVerifyCodeView ()<UITextFieldDelegate,GTTextFieldDelegate>

/** */
@property (nonatomic, weak) UITextField *codeTextField;
@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;
@property (nonatomic, weak) UILabel *label3;
@property (nonatomic, weak) UILabel *label4;
@property (nonatomic, weak) UILabel *label5;
@property (nonatomic, weak) UILabel *label6;

@property (nonatomic, copy) NSString *autoCode;

/** */
@property (nonatomic, copy) OnFinishedEnterCode onFinishedEnterCode;

@end

@implementation JDVerifyCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode {
    if (self = [super initWithFrame:frame]) {
        CGFloat labWidth = 32;
        CGFloat labHeight = 40;
        CGFloat spacing = 8;
        CGFloat margin = (self.jk_width-labWidth*6-spacing*5)/2.;
        
        if (onFinishedEnterCode) {
            _onFinishedEnterCode = [onFinishedEnterCode copy];
        }
        
        for (NSInteger i = 0; i<6; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin+(labWidth+spacing)*i, 0, labWidth, labHeight)];
            label.tag = 100+i;
            label.textColor = THEXCOLOR(0x575757);
            label.font = [UIFont systemFontOfSize:18];
            label.textAlignment = NSTextAlignmentCenter;
            [label setCornerWithRadius:5.f borderWidth:0 borderColor:verifyDisabledColor];
            [label setBackgroundColor:[UIColor grayColor]];
            
            [self addSubview:label];
            if (i == 0) {
                _label1 = label;
            }else if (i == 1) {
                _label2 = label;
            }else if (i == 2) {
                _label3 = label;
            }else if (i == 3) {
                _label4 = label;
            }else if (i == 4) {
                _label5= label;
            }else if (i == 5) {
                _label6 = label;
            }
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, labWidth, labHeight)];
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = THEXCOLOR(0x575757);
        textField.font = [UIFont systemFontOfSize:18];
        [textField setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:textField];
        _codeTextField = textField;
        [self sendSubviewToBack:self.codeTextField];
        [textField becomeFirstResponder];
//        DDLogDebug(@"C===%@",verifyDisabledColor);
//        DDLogDebug(@"D==%@",HEXCOLOR(0xf1f1f1));

    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length>=6) {
        self.autoCode = string;
    }
    if (!self.label1.text.length) {
        self.label1.text = string.length>0?[string substringToIndex:1]:string;
        [self.label1 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        
        [self.label1 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        //        [self bringSubviewToFront:self.codeTextField];
        _codeTextField.jk_left = _label2.jk_left;
        
    }else if (!self.label2.text.length) {
        self.label2.text = string;
        [self.label2 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [self.label2 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        //        [self bringSubviewToFront:self.codeTextField];
        
        _codeTextField.jk_left = _label3.jk_left;
        
    }else if (!self.label3.text.length) {
        self.label3.text = string;
        [self.label3 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [self.label3 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        //        [self bringSubviewToFront:self.codeTextField];
        
        _codeTextField.jk_left = _label4.jk_left;
    }else if (!self.label4.text.length) {
        self.label4.text = string;
        [self.label4 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [self.label4 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        //        [self bringSubviewToFront:self.label4];
        
        _codeTextField.jk_left = _label5.jk_left;
    }else if (!self.label5.text.length) {
        self.label5.text = string;
        [self.label5 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [self.label5 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        //        [self bringSubviewToFront:self.codeTextField];
        
        _codeTextField.jk_left = _label6.jk_left;
    }else if (!self.label6.text.length) {
        self.label6.text = string;
        [self.label6 setCornerWithRadius:5.f borderWidth:0 borderColor:verifyEnableColor];
        [self.label6 setBackgroundColor:verifyEnableColor];
        [self.codeTextField setBackgroundColor:verifyEnableColor];
        
        _codeTextField.jk_left = _label6.jk_left;
        if (_onFinishedEnterCode) {
            NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@",_label1.text,_label2.text,_label3.text,_label4.text,_label5.text,_label6.text];
            if (code.length>6) {
                NSString  *dd = [code substringToIndex:6];
                _onFinishedEnterCode(dd);
            }else
            if (self.autoCode.length==6) {
                NSString  *dd = self.autoCode;
                _onFinishedEnterCode(dd);
            }else
            {
                _onFinishedEnterCode(code);
            }
        }
    }
    return NO;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (self.label6.text.length) {
        self.label6.text = @"";
        [self.label6 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label6 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label6.jk_left;
    }else
    if (self.label5.text.length) {
        self.label5.text = @"";
        [self.label5 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label5 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label5.jk_left;
    } else
    if (self.label4.text.length) {
        self.label4.text = @"";
        [self.label4 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label4 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label4.jk_left;
    }else if (self.label3.text.length) {
        self.label3.text = @"";
        [self.label3 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label3 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label3.jk_left;
    }else if (self.label2.text.length) {
        self.label2.text = @"";
        [self.label2 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label2 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label2.jk_left;
    }else if (self.label1.text.length) {
        self.label1.text = @"";
        [self.label1 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.label1 setBackgroundColor:verifyDisabledColor];
        [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
        [self.codeTextField setBackgroundColor:verifyDisabledColor];
        self.codeTextField.jk_left = self.label1.jk_left;
    }
}

- (void)resetDefaultStatus {
    self.label1.text = self.label2.text = self.label3.text = self.label4.text = self.label5.text = self.label6.text =@"";
    [self.label1 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.label2 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.label3 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.label4 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.label5 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.label6 setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];

    [self.codeTextField setCornerWithRadius:5. borderWidth:0 borderColor:verifyDisabledColor];
    [self.codeTextField setBackgroundColor:verifyEnableColor];
    self.codeTextField.jk_left = self.label1.jk_left;
    [self codeBecomeFirstResponder];
}

- (void)codeBecomeFirstResponder {
    [self.codeTextField becomeFirstResponder];
}


@end
