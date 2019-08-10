//
//  JDLoggerFormatter.h
//  JDMovie
//
//  Created by Shen Su on 2018/8/16.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("CocoaLumberjack.h")
#import "CocoaLumberjack.h"
#endif
NS_ASSUME_NONNULL_BEGIN




#if __has_include("CocoaLumberjack.h")

@interface JDLoggerFormatter : NSObject<DDLogFormatter>

@end


#else
@interface JDLoggerFormatter : NSObject

@end
#endif

NS_ASSUME_NONNULL_END
