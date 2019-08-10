//
//  JDBannerView.h
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark-------------------------------------JDHelper------------------------------------------------------

@interface JDHelper : NSObject

/**
 *  图片缓存路径
 *
 *  @return <#return value description#>
 */
+ (NSString *)cachePath;

/**
 *  将图片保存到本地缓存中
 *
 *  @param identifier url.absoluteString
 *
 *  @return <#return value description#>
 */
+ (BOOL)saveBannerCache:(NSData *)data WithIdentifier:(NSString *)identifier;

/**
 *  取出本地的图片缓存
 *
 *  @param identifier url.absoluteString
 *
 *  @return <#return value description#>
 */

+ (NSData *)getBannerCacheDataWithIdentifier:(NSString *)identifier;

/**
 *  清除轮播图缓存图片
 */
+ (void)clearBannerCache;
@end

#pragma mark-------------------------------------JDBannerView------------------------------------------------------

typedef   void(^ComplimentBlock)(NSInteger index);


@protocol JDBannerDelegate <NSObject>

@optional
    
-(void)bannerAutoScrollIndex:(NSInteger)index;

@end



typedef NS_ENUM(NSInteger, PageControlPosition){
    PageControlPositionUpleft = 1,
    PageControlPositionUpCenter,
    PageControlPositionUpRight,
    PageControlPositionDownLeft,
    PageControlPositionDownCenter,
    PageControlPositionDownRight
};

@interface JDBannerView : UIView

/**
 *  通过本地图片资源加载轮播图
 *
 *  @param frame <#frame description#>
 *  @param names <#names description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray*)names  clickCompliment:(ComplimentBlock)clickBlock;

/**
 *  获取网络图片并进行显示
 *
 *  @param frame     轮播图范围
 *  @param imageUrls 网络图片链接数组
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray*)imageUrls clickCompliment:(ComplimentBlock)clickBlock;

-(void)setPageControlUserEnable:(BOOL)enable;

/**
 *  图片数据源, 可设置(可以是本地图片UIImage, 也可以是远程url的NSString)
 */
@property (nonatomic, copy)  NSArray *images;

@property (nonatomic, assign) id<JDBannerDelegate> delegate;
/**
 *  占位图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  是否自动轮播, 默认=YES
 */
@property (nonatomic, assign) BOOL autoBanner;

/**
 *  轮播时差
 */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/**
 *  PageControl的位置
 */
@property (nonatomic, assign) PageControlPosition pageType;
/**
 *  PageContril默认指示颜色
 */
@property (nonatomic, assign) UIColor *pageIndicatorTintColor;

/**
 *  pageControl
 */
@property (nonatomic, assign) UIColor *currentPageIndicatorTintColor;

/**
 *  pageImageStr
 */
@property (nonatomic, strong) NSString *pageImageStr;

/**
 *  pageCurrentImageStr
 */
@property (nonatomic, strong) NSString *pageCurrentImageStr;




@property (nonatomic, copy)  NSArray *titles;


@end
