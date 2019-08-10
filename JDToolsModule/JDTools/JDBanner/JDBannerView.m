//
//  JDBannerView.m
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import "JDBannerView.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark-------------------------------------JDHelper------------------------------------------------------


@interface JDPageControl:UIPageControl

@end;

@implementation JDPageControl

//重写setCurrentPage方法，可设置圆点大小
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIView* dot = [self.subviews objectAtIndex:i];
        UIView* bDot = [self.subviews objectAtIndex:i==0?0:i-1];

        dot.layer.cornerRadius = 2;
        dot.layer.masksToBounds = true;
        CGFloat margin = i==0?15:3;
        if (dot==bDot) {
            margin = i==0?8:-5;
        }
        margin == i==0?10:margin;
        if (self.currentPage==i) {
        [dot setFrame:CGRectMake(bDot.frame.origin.x+bDot.frame.size.width+margin, dot.frame.origin.y,12,4)];
        }else
        {
        [dot setFrame:CGRectMake(bDot.frame.origin.x+bDot.frame.size.width+margin, dot.frame.origin.y, 4, 4)];
        }
    }
}
@end
static NSInteger const KMaxBannerCacheFileCount = 100;

@implementation JDHelper

+ (NSString *)cachePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"Caches/JDBannerDataCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
+ (NSString *)createDataPathWithString:(NSString *)identifier{
    return [[self cachePath] stringByAppendingPathComponent:[self createMD5StringWithString:identifier]];
}
+ (BOOL)saveBannerCache:(NSData *)data WithIdentifier:(NSString *)identifier {
    NSString *path = [self createDataPathWithString:identifier];
    return [data writeToFile:path atomically:YES];
}
+ (NSData *)getBannerCacheDataWithIdentifier:(NSString *)identifier {
    static BOOL isCheckCacheDisk = NO;
    if (!isCheckCacheDisk) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cachePath] error:nil];
        if (contents.count > KMaxBannerCacheFileCount) {
            [manager removeItemAtPath:[self cachePath] error:nil];
        }
        isCheckCacheDisk = YES;
    }
    NSString *path = [self createDataPathWithString:identifier];
    NSData *data =[NSData dataWithContentsOfFile:path];
    return data;
}


+ (void)clearBannerCache {
    if (![[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:nil]) {
        NSLog(@"JDBannerView 清除缓存失败");
    };
}
#pragma mark - hash
+ (NSString *)createMD5StringWithString:(NSString *)string{
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    [hash lowercaseString];
    return hash;
}
@end

#pragma mark-------------------------------------JDBannerView------------------------------------------------------

@interface JDBannerView()<UIScrollViewDelegate>{
    CGFloat _kWidth;
    CGFloat _KHeight;
    BOOL _remoteImageType;  //图片源类型:当为本地图片时=100,网络加载图片时为101;
    __weak UIScrollView *_scrollView;
    __weak UIImageView *_leftImageView, *_middleImageView, *_rightImageView;
    __weak JDPageControl *_pageControl;
}
@property (nonatomic, copy) NSMutableArray *datasources;
@property (nonatomic, strong) NSMutableArray *urlStringSources;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLab;

/**
 *  当前被点击的图片索引
 */
@property (nonatomic, copy)  ComplimentBlock currentIndexDidTap;
@end



@implementation JDBannerView
{
    NSInteger _numbersOfImages;
    NSInteger _currentIndex;
    NSTimer *_timer;
}

-(UIView*)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-30, _kWidth, 30)];
        _titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _titleView;
}
-(UILabel*)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(12, self.bounds.size.height-30, _kWidth-_pageControl.frame.origin.x-12, 30)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}
+(UIImage *)JDImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Init methods
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray*)names  clickCompliment:(void(^)(NSInteger index))clickBlock{
    self = [super initWithFrame:frame];
    NSAssert(names.count!=0, @"Exception: JDBannerView init method: sources cannot be nil");
    if (self) {
        [self setupDefaultValues:names.count];
        _remoteImageType = NO;
        [self confirgueScrollView];
        [self setImageData:names];
        [self setNumbersOfImage:names.count];
        _currentIndexDidTap = clickBlock;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray*)imageUrls clickCompliment:(void(^)(NSInteger index))clickBlock{
    self = [super initWithFrame:frame];
    NSAssert(imageUrls.count!=0, @"Exception: JDBannerView init method: sources cannot be nil");
    if (self) {
        [self setupDefaultValues:imageUrls.count];
        _remoteImageType = YES;
        [self.urlStringSources addObjectsFromArray:imageUrls];
        [self confirgueScrollView];
        [self setImageData:nil];
        [self setNumbersOfImage:imageUrls.count];
        _currentIndexDidTap = clickBlock;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        //todo
        NSLog(@"frame");
        NSLog(@"%s",__FUNCTION__);
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //todo
        NSLog(@"decoder");
        NSLog(@"%s",__FUNCTION__);
    }
    return self;
}
- (NSMutableArray *)urlStringSources {
    if (!_urlStringSources) {
        _urlStringSources = [NSMutableArray array];
    }
    return _urlStringSources;
}
#pragma mark - Init with subviews
- (void)setupDefaultValues:(NSInteger )count{
    _kWidth           = self.frame.size.width;
    _KHeight          = self.frame.size.height;
    _numbersOfImages  = count;
    _autoBanner       = YES;
    _placeholderImage = [JDBannerView JDImageWithColor:[UIColor clearColor]];
    _datasources      = [NSMutableArray arrayWithCapacity:count];
}
- (void)confirgueScrollView{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroll];
    
    _scrollView                                = scroll;
    _scrollView.pagingEnabled                  = YES;
    _scrollView.backgroundColor                = [UIColor lightGrayColor];
    _scrollView.delegate                       = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.contentSize                    = _numbersOfImages==1?CGSizeMake(0, 0): CGSizeMake(_kWidth * 3, 0);
    
    _currentIndex = 0;
}
- (void)confirgueImageView{
    UIImageView *leftTemp   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _kWidth, _KHeight)];
    UIImageView *middleTemp = [[UIImageView alloc] initWithFrame:CGRectMake(_kWidth, 0, _kWidth, _KHeight)];
    UIImageView *rightTemp  = [[UIImageView alloc] initWithFrame:CGRectMake(_kWidth * 2, 0, _kWidth, _KHeight)];
    middleTemp.userInteractionEnabled = YES;
    [middleTemp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    [_scrollView addSubview:leftTemp];
    [_scrollView addSubview:middleTemp];
    [_scrollView addSubview:rightTemp];
    _leftImageView   = leftTemp;
    _middleImageView = middleTemp;
    _rightImageView  = rightTemp;
    
}
- (void)confirguePageControl{
    JDPageControl *page                = [[JDPageControl alloc] initWithFrame:CGRectMake(0,_KHeight - 20,_kWidth, 7)];
    page.pageIndicatorTintColor        = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor redColor];
    page.hidesForSinglePage            = YES;
    page.numberOfPages                 = _numbersOfImages;
    page.currentPage                   = 0;
    [page setUserInteractionEnabled:false];
    [self addSubview:page];
    _pageControl = page;
}
- (void)configueTitleLab{
    [self addSubview:self.titleView];
    [self addSubview:self.titleLab];
}
#pragma mark -  配置属性
- (void)setNumbersOfImage:(NSInteger)numbersofimage{
    [self confirgueImageView];
    [self confirguePageControl];
    _autoScrollTimeInterval = 3.f;
    if (_numbersOfImages > 1) {
        [self setupTimer];
    }
    [self changeImageLeft:_numbersOfImages-1 middle:0 right:1];
}
- (void)setImageData:(NSArray<UIImage *>*)names{
    if (_remoteImageType == YES) { //网络加载图片
        for (NSInteger index =0; index < _numbersOfImages; index++) {
            [_datasources addObject:_placeholderImage];
            [self loadImagesAtIndex:index];
        }
    }
    for (id object in names) {
        if (![object isKindOfClass:[UIImage class]]) {
            NSAssert([object isKindOfClass:[UIImage class]], @"Exception: JDBannerview datasource must be UIImage class");
        }
    }
    if (_remoteImageType == NO) {
        _datasources = [names copy];
    }
}
- (void)setImages:(NSArray *)images {
    if ([images.firstObject isKindOfClass:[UIImage class]]) {
        _remoteImageType = NO;
        [_datasources removeAllObjects];
        images = [_datasources copy];
    }else{
        _remoteImageType = NO;
        [_urlStringSources removeAllObjects];
        _urlStringSources = [images copy];
    }
}
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if (_placeholderImage!=placeholderImage)
    {
        _placeholderImage = placeholderImage;
    }
    NSMutableArray  *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_datasources.count; i++)
    {
        [arr addObject:_placeholderImage];
    }
    [_datasources removeAllObjects];
    [_datasources addObjectsFromArray:arr];
    
    for (int  i = 0; i<_datasources.count; i++)
    {
        
        [self loadImagesAtIndex:i];
    }
}
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
- (void)setAutoBanner:(BOOL)autoBanner{
    if (autoBanner == NO) {
        _autoBanner = NO;
        [self removeTimer];
    }
}
#pragma mark implentation method
- (void)changeImageLeft:(NSInteger)leftIndex middle:(NSInteger)middleIndex right:(NSInteger)rightIndex{
    if (_numbersOfImages == 1) {
        leftIndex = middleIndex = rightIndex = 0;
    }
    _leftImageView.image   = _datasources[leftIndex];
    _middleImageView.image = _datasources[middleIndex];
    _rightImageView.image  = _datasources[rightIndex];
    [_scrollView setContentOffset:CGPointMake(_kWidth, 0)];
}
- (void)imageViewDidTap{
    if (self.currentIndexDidTap) {
        self.currentIndexDidTap(_currentIndex);
    }
}
- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self removeTimer];
    [self setupTimer];
    
}
- (void)setPageType:(PageControlPosition)pageType {
    switch (pageType) {
        case PageControlPositionUpleft:
            [_pageControl setFrame:CGRectMake(0, 20, _numbersOfImages * 20, 7)];
            break;
        case PageControlPositionUpCenter:
            [_pageControl setFrame:CGRectMake(0, 20, _kWidth, 7)];
            break;
        case PageControlPositionUpRight:
            [_pageControl setFrame:CGRectMake(_kWidth - _numbersOfImages * 20, 20, _numbersOfImages * 20, 7)];
            break;
        case PageControlPositionDownLeft:
            [_pageControl setFrame:CGRectMake(0, _KHeight-20, _numbersOfImages * 20, 7)];
            break;
        case PageControlPositionDownCenter:
            [_pageControl setFrame:CGRectMake(0, _KHeight-20, _kWidth, 7)];
            break;
        case PageControlPositionDownRight:
            [_pageControl setFrame:CGRectMake(_pageControl.numberOfPages==0?_kWidth-25
                                              :_kWidth - (_numbersOfImages * 10)-20, _KHeight-16, (_numbersOfImages * 8)+10, 4)];
            
            self.titleLab.frame = CGRectMake(12, self.bounds.size.height-30, _pageControl.frame.origin.x-12, 30);
            break;
        default:
            break;
    }
}
-(void)setPageImageStr:(NSString *)pageImageStr
{
    if (pageImageStr)
    {
        _pageImageStr = pageImageStr;
        [_pageControl setValue:[UIImage imageNamed:_pageImageStr] forKeyPath:@"_pageImage"];
    }
}
-(void)setPageCurrentImageStr:(NSString *)pageCurrentImageStr
{
    if (pageCurrentImageStr)
    {
        _pageCurrentImageStr = pageCurrentImageStr;
        [_pageControl setValue:[UIImage imageNamed:_pageCurrentImageStr] forKeyPath:@"_currentPageImage"];
    }
    
}
-(void)setPageControlUserEnable:(BOOL)enable
{
    if (enable)
    {
       [_pageControl setUserInteractionEnabled:true];
       [_pageControl addTarget:self action:@selector(didClickPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
      [_pageControl setUserInteractionEnabled:false];
    }
  
}
-(void)didClickPageAction:(UIPageControl*)page
{
    [self removeTimer];
    [page setSelected:true];
     NSLog(@"点到page了index===%ld",page.currentPage);
    [self changeImageWithOffset:page.currentPage*_kWidth];
    if (_autoBanner) {
        [self setupTimer];
    }
}
#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeImageWithOffset:scrollView.contentOffset.x];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoBanner) {
        [self setupTimer];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}
- (void)changeImageWithOffset:(CGFloat)offsetX {
    if (offsetX >= _kWidth * 2) {
        _currentIndex ++;
        if (_currentIndex == _numbersOfImages - 1) {
            [self changeImageLeft:_currentIndex-1 middle:_currentIndex right:0];
        }else if (_currentIndex == _numbersOfImages){
            _currentIndex = 0;
            [self changeImageLeft:_numbersOfImages-1 middle:0 right:1];
        }else{
            [self changeImageLeft:_currentIndex-1 middle:_currentIndex right:_currentIndex+1];
        }
    }
    if (offsetX <= 0) {
        _currentIndex--;
        if (_currentIndex == 0) {
            [self changeImageLeft:_numbersOfImages-1 middle:0 right:1];
        }else if(_currentIndex == -1){
            _currentIndex = _numbersOfImages - 1;
            [self changeImageLeft:_currentIndex-1 middle:_currentIndex right:0];
        }else{
            [self changeImageLeft:_currentIndex-1 middle:_currentIndex right:_currentIndex+1];
        }
    }
    _pageControl.currentPage = _currentIndex;
    if (self.delegate) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(bannerAutoScrollIndex:)]) {
            [self.delegate bannerAutoScrollIndex:_currentIndex];
        } 
    }
    
    self.titleLab.text = self.titles[_currentIndex];
}
#pragma mark -定时器
- (void)setupTimer {
    if (_autoScrollTimeInterval < 0.5 || !_autoBanner)return;
    _timer = [NSTimer timerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (void)removeTimer{
    if (!_timer)return;
    [_timer invalidate];
    _timer = nil;
}
- (void)autoScroll{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _kWidth, 0) animated:YES];
}
- (void)removeFromSuperview {
    [super removeFromSuperview];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - downLoad and cache images
- (void)loadImagesAtIndex:(NSInteger)index {
    NSString *urlString = self.urlStringSources[index];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [JDHelper getBannerCacheDataWithIdentifier:urlString];
    if (data) {
        [self.datasources setObject:[UIImage imageWithData:data] atIndexedSubscript:index];
    }else{
        
        [NSURLConnection  sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (!connectionError) {
                UIImage *image = [UIImage imageWithData:data];
                if (!image) return ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_datasources setObject:image atIndexedSubscript:index];
                });
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if([JDHelper saveBannerCache:data WithIdentifier:url.absoluteString]){
                    };
                });
            }
        }];
    }
}

-(void)setTitles:(NSArray<NSString*> *)titles
{
    if (_titles!=titles) {
        _titles = titles;
    }
    if (!self.titleView.superview) {
        [self configueTitleLab];
        self.titleLab.text = titles[0];
    }
    [self bringSubviewToFront:_pageControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
