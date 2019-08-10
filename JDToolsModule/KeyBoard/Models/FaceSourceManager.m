//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"
#import "JDToolsModuleHeader.h"
#import "YYKit.h"

@implementation FaceSourceManager

//从持久化存储里面加载表情源
//+ (NSArray *)loadFaceSource
//{
//    NSMutableArray *subjectArray = [NSMutableArray array];
//
////    NSArray *sources = @[@"face", @"systemEmoji",@"emotion",];
//    NSArray *sources = @[@"face"];
//
//    NSDictionary  *dic = [[self class] emoticonDic];
//
//    for (int i = 0; i < sources.count; ++i)
//    {
//        NSString *plistName = sources[i];
//
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
//
//
//        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//        NSArray *allkeys = faceDic.allKeys;
//
//        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
//
//        if ([plistName isEqualToString:@"face"]) {
//            themeM.themeStyle = FaceThemeStyleCustomEmoji;
//            themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
//            themeM.themeIcon = @"section0_emotion0";
//        }else if ([plistName isEqualToString:@"systemEmoji"]){
//            themeM.themeStyle = FaceThemeStyleSystemEmoji;
//            themeM.themeDecribe = @"sEmoji";
//            themeM.themeIcon = @"";
//        }
//        else {
//            themeM.themeStyle = FaceThemeStyleGif;
//            themeM.themeDecribe = [NSString stringWithFormat:@"e%d", i];
//            themeM.themeIcon = @"f_static_000";
//        }
//
//
//        NSMutableArray *modelsArr = [NSMutableArray array];
//
//        for (int i = 0; i < allkeys.count; ++i) {
//            NSString *name = allkeys[i];
//            FaceModel *fm = [[FaceModel alloc] init];
//            fm.faceTitle = name;
//            fm.faceIcon = [faceDic objectForKey:name];
//            [modelsArr addObject:fm];
//        }
//        themeM.faceModels = modelsArr;
//
//        [subjectArray addObject:themeM];
//    }
//    return subjectArray;
//}
+ (NSArray *)loadFaceSource
{
    
    FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"plist"];
    NSArray *faceArray = [NSArray arrayWithContentsOfFile:plistPath];

    NSMutableArray *modelsArr = [[NSMutableArray alloc ]init];

    for (int i = 0; i < faceArray.count; i++) {
        NSDictionary *faceD = faceArray[i];
        WBEmoticon *fm = [WBEmoticon modelWithDictionary:faceD];
        [modelsArr addObject:fm];
    }
    themeM.themeStyle = FaceThemeStyleCustomEmoji;
    themeM.themeDecribe = @"微博";
    themeM.themeIcon = @"EmotionsEmojiHL";
    themeM.faceModels = modelsArr;
    [subjectArray addObject:themeM];
    return subjectArray;
}


+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
    });
    return dic;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    WBEmoticonGroup *group = nil;

    if (!group) {
        NSString *plistPath = [path stringByAppendingPathComponent:@"/com.sina.default/sinaInfo.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plist.count) {
            group = [WBEmoticonGroup modelWithJSON:plist];
        }
    }
    for (WBEmoticon *emoticon in group.emoticons) {
        if (emoticon.png.length == 0) continue;
        NSString *pngPath = [path stringByAppendingPathComponent:emoticon.png];
        if (emoticon.chs) dic[emoticon.chs] = pngPath;
        if (emoticon.cht) dic[emoticon.cht] = pngPath;
    }
    
    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *folder in folders) {
        if (folder.length == 0) continue;
        NSDictionary *subDic = [self _emoticonDicFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDic) {
            [dic addEntriesFromDictionary:subDic];
        }
    }
    return dic;
}
@end
