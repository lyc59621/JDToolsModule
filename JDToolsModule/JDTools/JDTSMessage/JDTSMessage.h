//
//  TSMessage+JDHelp.h
//  JDMovie
//
//  Created by JDragon on 2018/9/5.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#if __has_include("TSMessage.h")
#import "TSMessage.h"
#endif

@interface JDTSMessage : NSObject


+(void)TSmessageConfig;

+(void)showInfoMessageWithMsg:(NSString*)msg;
+(void)showWarningMessageWithMsg:(NSString*)msg;
+(void)showErrorMessageWithMsg:(NSString*)msg;
+(void)showSuccessMessageWithMsg:(NSString*)msg;

@end
