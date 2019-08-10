//
//  JDLoggerFormatter.m
//  JDMovie
//
//  Created by Shen Su on 2018/8/16.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import "JDLoggerFormatter.h"

@implementation JDLoggerFormatter


#if __has_include("CocoaLumberjack.h")

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel = nil;
    switch (logMessage.flag) {
            case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
            case DDLogFlagWarning:
            logLevel = @"[WARN]";
            break;
            case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
            case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VBOSE]";
            break;
    }
    

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString  *ssf =  [formatter stringFromDate:logMessage.timestamp];
    
    NSString *formatStr
    = [NSString stringWithFormat:@"%@ %@ [%@][line %ld] %@ %@", logLevel, ssf, logMessage.fileName, logMessage.line, logMessage.function, logMessage.message];
    return formatStr;
    
}

#else


#endif



@end
