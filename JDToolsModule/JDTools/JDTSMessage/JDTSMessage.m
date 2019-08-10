//
//  TSMessage+JDHelp.m
//  JDMovie
//
//  Created by JDragon on 2018/9/5.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDTSMessage.h"

@implementation JDTSMessage

+(void)TSmessageConfig
{
    //    [[TSMessageView appearance] setTitleFont:[UIFont boldSystemFontOfSize:6]];
    //    [[TSMessageView appearance] setTitleTextColor:[UIColor redColor]];
    //    [[TSMessageView appearance] setContentFont:[UIFont boldSystemFontOfSize:10]];
    //    [[TSMessageView appearance]setContentTextColor:[UIColor greenColor]];
    //    [[TSMessageView appearance]setErrorIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    //    [[TSMessageView appearance]setSuccessIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    //    [[TSMessageView appearance]setMessageIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    //    [[TSMessageView appearance]setWarningIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
}

+(void)showInfoMessageWithMsg:(NSString*)msg
{
    #if __has_include("TSMessage.h")
    [TSMessage showMessageWithMsg:msg withType:TSMessageNotificationTypeMessage];
    #else
    NSAssert(NO, @"请导入TSMessage");
    #endif
}
+(void)showWarningMessageWithMsg:(NSString*)msg
{
        #if __has_include("TSMessage.h")
    [TSMessage showMessageWithMsg:msg withType:TSMessageNotificationTypeWarning];
#else
    NSAssert(NO, @"请导入TSMessage");
#endif
}
+(void)showErrorMessageWithMsg:(NSString*)msg
{
#if __has_include("TSMessage.h")

    [TSMessage showMessageWithMsg:msg withType:TSMessageNotificationTypeError];
#else
    NSAssert(NO, @"请导入TSMessage");
#endif
}
+(void)showSuccessMessageWithMsg:(NSString*)msg
{
#if __has_include("TSMessage.h")

    [TSMessage showMessageWithMsg:msg withType:TSMessageNotificationTypeSuccess];
#else
    NSAssert(NO, @"请导入TSMessage");
#endif
}
+(void)showMessageWithMsg:(NSString*)msg withType:(NSInteger)type
{
#if __has_include("TSMessage.h")

    [TSMessage showNotificationInViewController:nil
                                          title:msg
                                       subtitle:nil
                                          image:nil
                                           type:type
                                       duration:1.2
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
#else
    NSAssert(NO, @"请导入TSMessage");
#endif
    
}





@end
