//
//  JDClearCacheManager.m
//  ZMMovie
//
//  Created by JDragon on 2018/9/28.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import "JDClearCacheManager.h"


@implementation JDClearCacheManager

#pragma mark - 获取Cache文件夹大小
+ (NSString *)getCacheSize {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *totleSize = [[self class] getCacheSizeWithFilePath:cachesPath];
    return totleSize;
}

#pragma mark - 删除Cache文件夹中的缓存
+ (BOOL)clearCache {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    BOOL isAlreadyClearCache = [[self class]  clearCacheWithFilePath:cachesPath];
    return isAlreadyClearCache;
}
+ (void)readyClearCache {
    BOOL isClearCache = [[self class]  clearCache];
    if (isClearCache) {
                NSLog(@"清理完毕");
    } else {
                NSLog(@"清理失败");
    }
}

#pragma mark - 计算和清理WebKit文件夹的WKWebKit总缓存
+ (NSString *)getWKWebKitCacheSize {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/WebKit"];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        NSLog(@"%@",filePath);
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
//    NSString *totleStr = nil;
//    if (totleSize > 1000 * 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
//    }else if (totleSize > 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
//    }else{
//        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
//    }
    NSString *totleStr = [NSByteCountFormatter stringFromByteCount:totleSize countStyle:NSByteCountFormatterCountStyleFile];

    return totleStr;
}

+ (BOOL)clearWKWebKitCache {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/WebKit"];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
        //       NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

#pragma mark - 计算和清理SDImageCache--default文件夹的总缓存
+ (NSString *)getSDImageDefaultCacheSize {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/default"];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
//    NSString *totleStr = nil;
//    if (totleSize > 1000 * 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
//    }else if (totleSize > 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
//    }else{
//        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
//    }
    NSString *totleStr = [NSByteCountFormatter stringFromByteCount:totleSize countStyle:NSByteCountFormatterCountStyleFile];
    return totleStr;
}

+ (BOOL)clearSDImageDefaultCache {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/default"];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
        //        NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}
+ (NSString *)getJDBannerImageDefaultCacheSize
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/JDBannerDataCache"];
    
    long long  size = [[self class] fileSizeAtPath:path];
    
    NSString *totleStr = [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
    return totleStr;
}
+ (BOOL)clearJDBannerImageDefaultCache {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/JDBannerDataCache"];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
            //        NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path {
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    long long totleSize = 0;
    for (NSString *subPath in subPathArr){
        //        NSLog(@"getCacheSize = %@",subPath);
        // 0. 把Snapshots文件夹过滤掉,没有访问权限,否则删除时操过200M会失败!!!!!!!!
        if (![subPath containsString:@"Snapshots"]) {
            // 1. 拼接每一个文件的全路径
            filePath =[path stringByAppendingPathComponent:subPath];
        }
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
//    NSString *totleStr = nil;
//    if (totleSize > 1000 * 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fMB",totleSize / 1000.00f /1000.00f];
//    }else if (totleSize > 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
//    }else{
//        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
//    }
    NSString *totleStr = [NSByteCountFormatter stringFromByteCount:totleSize countStyle:NSByteCountFormatterCountStyleFile];
    return totleStr;
}

#pragma mark - 清除path文件夹下缓存大小--/Caches/Snapshots,真机测试会输出error
//Error Domain=NSCocoaErrorDomain Code=513 "未能移除“Snapshots”，因为您没有访问它的权限。"
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
       //         NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

#pragma mark - 模拟器下计算和清理WebKit文件夹的WKWebKit总缓存
+ (NSString *)getSimulatorWKWebKitCacheSize {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    //    NSLog(@"%@",identifier);
    NSString *path = [NSString stringWithFormat:@"%@/%@",cachesPath,identifier];
    path = [path stringByAppendingPathComponent:@"/WebKit"];
    //    NSLog(@"%@",path);
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
//    NSString *totleStr = nil;
//    if (totleSize > 1000 * 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
//    }else if (totleSize > 1000){
//        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
//    }else{
//        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
//    }
    NSString *totleStr = [NSByteCountFormatter stringFromByteCount:totleSize countStyle:NSByteCountFormatterCountStyleFile];
    return totleStr;
}

+ (BOOL)clearSimulatorWKWebKitCache {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    //    NSLog(@"%@",identifier);
    NSString *path = [NSString stringWithFormat:@"%@/%@",cachesPath,identifier];
    path = [path stringByAppendingPathComponent:@"/WebKit"];
    //    NSLog(@"%@",path);
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //        NSLog(@"%@",filePath);
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
       //            NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}


#pragma mark----------------deafult cache   暂未使用 ------------------------------
+ (NSString *)appCache {
    
    
    NSString *path = [[self class]cachePath];
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:[[self class ] folderSizeAtPath:path] countStyle:NSByteCountFormatterCountStyleFile];
    NSLog(@"file=======%@",folderSizeStr);
    return folderSizeStr;
}

/**
 cache Path

 @return path
 */
+ (NSString *)cachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

/**
 cache folder cache size

 @return size
 */
+(long long )folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager * manager=[NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize;
}


/**
 计算单个文件大小

 @param filePath path
 @return size
 */
+(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
    
}
@end
