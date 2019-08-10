//
//  JDShareManager.h
//  JDMovie
//
//  Created by JDragon on 2018/9/27.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

//typedef void (^ResultBlock)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error);

static SSDKShareStateChangedHandler myResultBlock;

NS_ASSUME_NONNULL_BEGIN

@interface JDShareManager : NSObject


/**
 分享

 @param title share Title
 @param content
 @param url Share Url
 @param imageURL Image Url String
 @param resultBlock
 */
+(void)ShareTextActionWithTitle:(NSString*)title ShareContent:(NSString*)content ShareUlr:(NSString*)url imageURL:(id)imageURL Result:(SSDKShareStateChangedHandler)resultBlock;

+(void)ShareNormalParams:(NSDictionary*)params ActionResult:(SSDKShareStateChangedHandler)resultBlock;

@end

NS_ASSUME_NONNULL_END
