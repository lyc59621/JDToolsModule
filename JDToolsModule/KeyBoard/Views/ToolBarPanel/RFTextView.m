//
//  RFTextView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/28.
//  Copyright © 2016年 ruofei. All rights reserved.
//
#import "JDToolsModuleHeader.h"
#import "RFTextView.h"
#import "ChatKeyBoardMacroDefine.h"

@implementation RFTextView

@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = THEXCOLOR(0xe8e8e8);
        self.font = [UIFont systemFontOfSize:15.f];
        self.textColor = THEXCOLOR(0xf0f0f0);
//        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
//        self.layer.borderWidth = 0.65f;
        self.layer.cornerRadius = 5.0f;
        self.keyboardAppearance = UIKeyboardAppearanceDark;
        self.contentMode = UIViewContentModeRedraw;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        self.tintColor = THEXCOLOR(0x9b9b9b);
        _placeHolder = nil;
        _placeHolderTextColor = [UIColor lightGrayColor];
                
        [self _addTextViewNotificationObservers];
    }
    return self;
}

- (void)dealloc
{
    [self _removeTextViewNotificationObservers];
}

- (void)deleteBackward
{
    if (IsTextContainFace(self.text)) { // 如果text中有表情
        if ([self.delegate respondsToSelector:@selector(textViewDeleteBackward:)]) {
            [self.delegate textViewDeleteBackward:self];
        }
    }else {
        
        [super deleteBackward];
    }
}

#pragma mark -RFTextView 方法
- (NSUInteger)numberOfLinesOfText{
    return [RFTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)? 33:109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text{
    return (text.length / [RFTextView maxCharactersPerLine]) + 1;
}

#pragma mark -- Setters
- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    
    _placeHolder = [placeHolder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor
{
    if ([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark -- UITextView overrides
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark -- Drawing
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self.text length] == 0 && self.placeHolder) {
        [self.placeHolderTextColor set];
        [self.placeHolder drawInRect:CGRectInset(rect, 7.0f, 7.5f) withAttributes:[self _placeholderTextAttributes]];
    }
}

#pragma mark -- Notifications
- (void)_addTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}

- (void)_didReceiveTextViewNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)_removeTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self];

}

- (NSDictionary *)_placeholderTextAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = self.textAlignment;
    
    return @{ NSFontAttributeName : self.font,
              NSForegroundColorAttributeName : self.placeHolderTextColor,
              NSParagraphStyleAttributeName : paragraphStyle };
}


@end
