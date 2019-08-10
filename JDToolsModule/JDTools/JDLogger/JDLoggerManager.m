//
//  JDLoggerManager.m
//  JDMovie
//
//  Created by Shen Su on 2018/8/16.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import "JDLoggerManager.h"

@interface JDLoggerManager ()

@property (nonatomic, strong, readwrite) DDFileLogger *fileLogger;

@end

@implementation JDLoggerManager

#pragma mark - Inititlization
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureLogging];
    }
    return self;
}

#pragma mark 单例模式

static JDLoggerManager *sharedManager=nil;

+(JDLoggerManager *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager=[[self alloc]init];
    });
    return sharedManager;
}


#pragma mark - Configuration

- (void)configureLogging
{
    
    // Enable XcodeColors利用XcodeColors显示色彩（不写没效果）
    setenv("XcodeColors", "YES", 0);
    // 添加DDTTYLogger，日志语句将被发送到Console.app
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    // 添加DDASLLogger，日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger];
    
    //设置颜色值
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //设置输出的LOG样式
    JDLoggerFormatter* formatter = [[JDLoggerFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
}

#pragma mark - Getters
// 添加DDFileLogger，日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
- (DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        
        _fileLogger = fileLogger;
    }
    
    return _fileLogger;
}

@end
