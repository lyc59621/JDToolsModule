//
//  JDLoggerManager.h
//  JDMovie
//
//  Created by Shen Su on 2018/8/16.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDLoggerFormatter.h"
#import "JDDeleteToolView.h"
#if __has_include("CocoaLumberjack.h")
#import "CocoaLumberjack.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface JDLoggerManager : NSObject


+(JDLoggerManager *)sharedManager;


@end

NS_ASSUME_NONNULL_END
