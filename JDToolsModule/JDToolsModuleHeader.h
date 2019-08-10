//
//  JDToolsModuleHeader.h
//  JDToolsModule
//
//  Created by JDragon on 2018/9/9.
//

#ifndef JDToolsModuleHeader_h
#define JDToolsModuleHeader_h


//色值
#define TRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define TRGB(r,g,b) RGBA(r,g,b,1.0f)

#define THEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0f green:((float)((hex & 0xFF00) >> 8)) / 255.0f blue:((float)(hex & 0xFF)) / 255.0f alpha:1]


//获取屏幕宽高
#define TMainScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define TMainScreenHeight [[UIScreen mainScreen] bounds].size.height
#define TMainScreen_Bounds [UIScreen mainScreen].bounds

//JDTools

#import "JDragonAlertView.h"
#import "JDBannerView.h"
#import "JDTimeCountDownManager.h"
#import "UIButton+JDTimeCount.h"
#import "JDCropImageMaskView.h"
#import "JDCropImageScrollView.h"
#import "JDTimeCountDownManager.h"
#import "JDDeleteToolView.h"
#import "JDLoggerManager.h"
#import "JDragonPickView.h"
#import "JDTagsView.h"
#import "JDragonTypeBtnView.h"
#import "JDVerifyCodeView.h"
#import "JDragonStarView.h"
#if __has_include("JDKeyBoard.h")
#import "JDKeyBoard.h"
#endif
#if __has_include("JDPayCenterPickView.h")
#import "JDPayCenterPickView.h"
#endif

#import "MBProgressHUD+JDragon.h"


//GCDHelper
#import "GCD.h"

//swizzle safe
#import "JRSwizzle.h"
#import "SYSafeCategory.h"


//uiimage blur
#import "ANBlurredImageView.h"


//FPSLab
#import "YYFPSLabel.h"


//Category
#import "JKCategories.h"

#import "NSString+Additions.h"
#import "UIButton+Style.h"
#import "NSString+TimeFormat.h"

//Category image View
#import "UIImage+ImageEffects.h"
#import "UIView+JDShade.h"


//Share
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


// 瀑布流


// 各类说明弹出视图
//#import "JDInstructionsActionSheet.h"
#endif /* JDToolsModuleHeader_h */
