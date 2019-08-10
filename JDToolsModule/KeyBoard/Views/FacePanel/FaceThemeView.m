//
//  FaceView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceThemeView.h"

#import "FacePageView.h"

#import "FaceThemeModel.h"
#import "ChatKeyBoardMacroDefine.h"

NSString *const PageFaceViewIdentifier = @"PageFaceViewIdentifier";

@interface FaceThemeView () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 表情主题 */
@property (nonatomic, strong) FaceThemeModel *themeModel;
@property (nonatomic, strong) NSArray *pageFaceArray;

@end

@implementation FaceThemeView
{
    UICollectionView *_collectionView;
    UIPageControl    * _pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageFaceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FacePageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PageFaceViewIdentifier forIndexPath:indexPath];
    cell.themeStyle = self.themeModel.themeStyle;
    [cell loadPerPageFaceData:self.pageFaceArray[indexPath.row]];
    
    return cell;
}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"选择face");
//}

#pragma mark -- UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
        //每页宽度
        CGFloat pageWidth = scrollView.frame.size.width;
        //根据当前的坐标与页宽计算当前页码
        NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        [_pageControl setCurrentPage:currentPage];
    }
}

/**
 *  加载表情主题，并进行分页
 */
- (void)loadFaceTheme:(FaceThemeModel *)faceTheme;
{
    _themeModel = faceTheme;
    
    NSInteger numbersOfPerPage = [self numbersOfPerPage:faceTheme];
    
    NSMutableArray *pagesArray = [NSMutableArray array];
    NSInteger counts = faceTheme.faceModels.count;
    
    NSMutableArray *page = nil;
    for (int i = 0; i < counts; ++i) {
        if (i % numbersOfPerPage == 0) {
            page = [NSMutableArray array];
            [pagesArray addObject:page];
        }
        [page addObject:faceTheme.faceModels[i]];
    }
    self.pageFaceArray = [NSArray arrayWithArray:pagesArray];
    _pageControl.numberOfPages = self.pageFaceArray.count;
}


- (NSInteger)numbersOfPerPage:(FaceThemeModel *)faceSubject
{
    NSInteger perPageNum = 0;
    
    if (faceSubject.themeStyle == FaceThemeStyleSystemEmoji) {
        
        NSInteger colNumber = 7;
        if (isIPhone4_5)
            colNumber = 7;
        else if (isIPhone6_6s)
            colNumber = 8;
        else if (isIPhone6p_6sp)
            colNumber = 9;
        perPageNum = colNumber * 3 - 1; //最后一个是删除符
        
    }else if (faceSubject.themeStyle == FaceThemeStyleCustomEmoji){
        NSInteger colNumber = 7;
        if (isIPhone4_5)
            colNumber = 7;
        else if (isIPhone6_6s)
            colNumber = 8;
        else if (isIPhone6p_6sp)
            colNumber = 9;
        perPageNum = colNumber * 3 - 1; //最后一个是删除符
    }
    else if (faceSubject.themeStyle == FaceThemeStyleGif)
    {
        perPageNum = 4 * 2;
    }
    return perPageNum;
}

- (void)initSubViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //这个 item 表示cell的大小
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[FacePageView class] forCellWithReuseIdentifier:PageFaceViewIdentifier];

    
//    [self  registerGestureRecognizer ];
    
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kUIPageControllerHeight, self.frame.size.width, kUIPageControllerHeight)];
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.defersCurrentPageDisplay = YES;

    [self addSubview:_pageControl];
}
#pragma mark - TIPs

//- (void)registerGestureRecognizer {
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//
//    [_collectionView addGestureRecognizer:tap];
//
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                               initWithTarget:self action:@selector(longPressHandler:)];
//    longPress.allowableMovement = 10000;
//    longPress.minimumPressDuration = 0.5;
//
//    [_collectionView addGestureRecognizer:longPress];
//}

//- (UIView *)subViewAtPoint:(CGPoint)point {
//    if (point.y <= 0)return nil;
//    for (UIView *view in _collectionView.subviews) {
//        CGPoint localPoint = [view convertPoint:point fromView:_collectionView];
//        if ([view pointInside:localPoint withEvent:nil]) {
//            return view;
//        }
//    }
//    return nil;
//}

//- (void)tapHandler:(UITapGestureRecognizer *)tap {
//    CGPoint point = [tap locationInView:tap.view];
//    UIView *touchView = [self subViewAtPoint:point];
//    if (!touchView) return;
//
//    if ([touchView isKindOfClass:[LLCollectionEmojiCell class]]) {
//        LLCollectionEmojiCell *cell = (LLCollectionEmojiCell *)touchView;
//        if (cell.isDelete) {
//            [self.delegate deleteCellDidSelected];
//        }else {
//            [self.delegate emojiCellDidSelected:cell.emotionModel];
//        }
//    }else {
//        [self.delegate gifCellDidSelected:((LLCollectionGifCell *)touchView).emotionModel];
//    }
//}

//- (void)longPressHandler:(UILongPressGestureRecognizer *)longPress {
//    CGPoint point = [longPress locationInView:longPress.view];
//    id<ILLEmotionTipDelegate> touchView = (id<ILLEmotionTipDelegate>)[self subViewAtPoint:point];
//
//    if (longPress.state == UIGestureRecognizerStateEnded) {
//        [_touchView didMoveOut];
//    }else {
//        if (touchView == _touchView) return;
//        [_touchView didMoveOut];
//        _touchView = touchView;
//        [_touchView didMoveIn];
//    }
//
//}
@end
