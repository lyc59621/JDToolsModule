//
//  JDVerifyCodeView.h
//  JDMovie
//
//  Created by Shen Su on 2018/8/17.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OnFinishedEnterCode)(NSString *code);

@interface JDVerifyCodeView : UIView

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode;

- (void)resetDefaultStatus;

- (void)codeBecomeFirstResponder;

@end

NS_ASSUME_NONNULL_END
