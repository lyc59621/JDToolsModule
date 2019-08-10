//
//  JDTagsView.m
//  JDMovie
//
//  Created by JDragon on 2018/9/5.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDTagsView.h"
#if __has_include("YYKit.h")
#import "YYKit.h"
#endif
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static NSString * const kTagCellID = @"TagCellID";

@interface JDTagModel : NSObject

@property (copy, nonnull) NSString *name;
@property (nonatomic) BOOL selected;
//用于计算文字大小
@property (strong, nonatomic) UIFont *font;

@property (nonatomic, readonly) CGSize contentSize;

- (instancetype)initWithName:(NSString *)name font:(UIFont *)font;

@end

@implementation JDTagModel

- (instancetype)initWithName:(NSString *)name font:(UIFont *)font {
    if (self = [super init]) {
        _name = name;
        self.font = font;
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self calculateContentSize];
}

- (void)calculateContentSize {
    NSDictionary *dict = @{NSFontAttributeName: self.font};
    CGSize textSize = [_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1000)
                                          options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    _contentSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end

@interface JDTagCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *tagLabel;
@property (nonatomic) JDTagModel *tagModel;
@property (nonatomic) UIEdgeInsets contentInsets;

@end

@implementation JDTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_tagLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    CGRect frame = CGRectMake(0, 0, width, [self.tagModel contentSize].height);
    self.tagLabel.frame = frame;
    self.tagLabel.center = self.contentView.center;
}

@end

@interface JDEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentHeight;
@property (strong,nonatomic) NSString *autoHeight;

@end

@implementation JDEqualSpaceFlowLayout

- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 6;
        self.minimumLineSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return self;
}

- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return self.minimumInteritemSpacing;
}

- (CGFloat)minimumLineSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    return self.minimumLineSpacing;
}

- (UIEdgeInsets)sectionInsetAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    _contentHeight = 0;
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingAtSection:0];
    CGFloat minimumLineSpacing = [self minimumLineSpacingAtSection:0];
    UIEdgeInsets sectionInset = [self sectionInsetAtSection:0];
    
    CGFloat xOffset = sectionInset.left;
    CGFloat yOffset = sectionInset.top;
    CGFloat xNextOffset = sectionInset.left;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        xNextOffset += (minimumInteritemSpacing + itemSize.width);
        
        if (xNextOffset - minimumInteritemSpacing > [self collectionView].bounds.size.width - sectionInset.right) {
            xOffset = sectionInset.left;
            xNextOffset = (sectionInset.left + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
        
        _contentHeight = MAX(_contentHeight, CGRectGetMaxY(layoutAttributes.frame));
    }
    
    _contentHeight = MAX(_contentHeight + sectionInset.bottom, self.collectionView.frame.size.height);
    CGRect  ff = self.collectionView.frame;
    ff.size.height = _contentHeight;
    self.collectionView.frame = ff;
    self.autoHeight  =  [NSString stringWithFormat:@"%f",_contentHeight];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    CGSize contentSize  = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds)) {
        return YES;
    }
    return YES;
}

@end

@interface JDTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSString *> *tagsMutableArray;
@property (strong, nonatomic) NSMutableArray<JDTagModel *> *tagModels;

@property (strong, nonatomic) JDEqualSpaceFlowLayout *collectionFlowLayout;

@end

@implementation JDTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    _contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _tagInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _tagBorderWidth = 0;
    _tagBackgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:1.0 green:0.38 blue:0.0 alpha:1.0];
    _tagFont = [UIFont systemFontOfSize:14];
    _tagSelectedFont = [UIFont systemFontOfSize:14];
    _tagTextColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    _tagSelectedTextColor = [UIColor whiteColor];
    
    _tagHeight = 28;
    _mininumTagWidth = 0;
    _maximumTagWidth = CGFLOAT_MAX;
    _lineSpacing = 10;
    _interitemSpacing = 5;
    
    _allowsSelection = YES;
    _allowsMultipleSelection = NO;
    
    [self addSubview:self.collectionView];
    
    UICollectionView *collectionView = self.collectionView;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                   options:NSLayoutFormatAlignAllTop
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:views]];
    [self addConstraints:constraints];
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    return CGSizeMake(UIViewNoIntrinsicMetric, contentSize.height);
}

- (void)setTagsArray:(NSArray<NSString *> *)tagsArray {
    _tagsMutableArray = [tagsArray mutableCopy];
    [self.tagModels removeAllObjects];
    [tagsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JDTagModel *tagModel = [[JDTagModel alloc] initWithName:obj font:self.tagFont];
        [self.tagModels addObject:tagModel];
    }];
    [self.collectionView reloadData];
}
//自动返回高
-(CGFloat)getAutoHeightWithDataArray:(NSArray<NSString *> *)tagsArray
{
    _tagsMutableArray = [tagsArray mutableCopy];
    [self.tagModels removeAllObjects];
    [tagsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JDTagModel *tagModel = [[JDTagModel alloc] initWithName:obj font:self.tagFont];
        [self.tagModels addObject:tagModel];
    }];
    [self.collectionView reloadData];
    
    return [self getAutoHeight];
}

-(CGFloat)getAutoHeight
{
    
    CGFloat  contentHeight = 30;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray   *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat minimumInteritemSpacing =5;
    CGFloat minimumLineSpacing = 9;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 15, 13, 15);
    
    CGFloat xOffset = sectionInset.left;
    CGFloat yOffset = sectionInset.top;
    CGFloat xNextOffset = sectionInset.left;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self collectionView:self.collectionView layout:self.collectionFlowLayout sizeForItemAtIndexPath:indexPath];
        
        xNextOffset += (minimumInteritemSpacing + itemSize.width);
        
        if (xNextOffset - minimumInteritemSpacing > [self collectionView].bounds.size.width - sectionInset.right) {
            xOffset = sectionInset.left;
            xNextOffset = (sectionInset.left + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [itemAttributes addObject:layoutAttributes];
        
        contentHeight = MAX(contentHeight, CGRectGetMaxY(layoutAttributes.frame));
    }
    
    contentHeight = MAX(contentHeight + sectionInset.bottom, self.collectionView.frame.size.height);
    return contentHeight;
}

- (void)selectTagAtIndex:(NSUInteger)index animate:(BOOL)animate {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                      animated:animate
                                scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate {
    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
}

#pragma mark - ......::::::: Edit :::::::......

- (NSUInteger)indexOfTag:(NSString *)tagName {
    __block NSUInteger index = NSNotFound;
    [self.tagsMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:tagName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)addTag:(NSString *)tagName {
    [self.tagsMutableArray addObject:tagName];
    JDTagModel *tagModel = [[JDTagModel alloc] initWithName:tagName font:self.tagFont];
    [self.tagModels addObject:tagModel];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index {
    if (index >= self.tagsMutableArray.count) {
        return;
    }
    
    [self.tagsMutableArray insertObject:tagName atIndex:index];
    JDTagModel *tagModel = [[JDTagModel alloc] initWithName:tagName font:self.tagFont];
    [self.tagModels insertObject:tagModel atIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeTagWithName:(NSString *)tagName {
    return [self removeTagAtIndex:[self indexOfTag:tagName]];
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index >= self.tagsMutableArray.count || index == NSNotFound) {
        return ;
    }
    
    [self.tagsMutableArray removeObjectAtIndex:index];
    [self.tagModels removeObjectAtIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
    [self.tagsMutableArray removeAllObjects];
    [self.tagModels removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - ......::::::: CollectionView DataSource :::::::......

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellID forIndexPath:indexPath];
    
    JDTagModel *tagModel = self.tagModels[indexPath.row];
    cell.tagModel = tagModel;
    cell.tagLabel.text = tagModel.name;
    cell.layer.cornerRadius = self.tagcornerRadius;
    cell.layer.masksToBounds = self.tagcornerRadius > 0;
    cell.contentInsets = self.tagInsets;
    cell.layer.borderWidth = self.tagBorderWidth;
    [self setCell:cell selected:tagModel.selected];
    
    return cell;
}

- (void)setCell:(JDTagCell *)cell selected:(BOOL)selected {
    
    if (selected) {
        //        cell.backgroundColor = self.tagSelectedBackgroundColor;
        //        cell.tagLabel.font = self.tagSelectedFont;
        //        cell.tagLabel.textColor = self.tagSelectedTextColor;
        //        cell.layer.borderColor = self.tagSelectedBorderColor.CGColor;
    }else {
        cell.backgroundColor = self.tagBackgroundColor;
        cell.tagLabel.font = self.tagFont;
        cell.tagLabel.textColor = self.tagTextColor;
        cell.layer.borderColor = self.tagBorderColor.CGColor;
    }
}

#pragma mark - ......::::::: UICollectionViewDelegate :::::::......

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:shouldSelectTagAtIndex:)]) {
        return [self.delegate tagsView:self shouldSelectTagAtIndex:indexPath.row];
    }
    
    return _allowsSelection;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:didDeSelectTagAtIndex:)]) {
        return [self.delegate tagsView:self shouldDeselectItemAtIndex:indexPath.row];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tagsView:didSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didSelectTagAtIndex:indexPath.row];
    }
    
    JDTagModel *tagModel = self.tagModels[indexPath.row];
    JDTagCell *cell = (JDTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.allowsMultipleSelection) {
        tagModel.selected = YES;
        [self setCell:cell selected:YES];
        return;
    }
    
    //修复单选情况下，无法取消选中的问题
    if (tagModel.selected) {
        cell.selected = NO;
        collectionView.allowsMultipleSelection = YES;
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        collectionView.allowsMultipleSelection = NO;
        return;
    }
    
    tagModel.selected = YES;
    [self setCell:cell selected:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:didDeSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didDeSelectTagAtIndex:indexPath.row];
    }
    
    JDTagModel *tagModel = self.tagModels[indexPath.row];
    JDTagCell *cell = (JDTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tagModel.selected = NO;
    [self setCell:cell selected:NO];
}

#pragma mark - ......::::::: UICollectionViewDelegateFlowLayout :::::::......

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDTagModel *tagModel = self.tagModels[indexPath.row];
    
    CGFloat width = tagModel.contentSize.width + self.tagInsets.left + self.tagInsets.right;
    if (width < self.mininumTagWidth) {
        width = self.mininumTagWidth;
    }
    if (width > self.maximumTagWidth) {
        width = self.maximumTagWidth;
    }
    
    return CGSizeMake(width, self.tagHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.contentInsets;
}

#pragma mark - ......::::::: Getter and Setter :::::::......

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JDEqualSpaceFlowLayout *flowLayout = [[JDEqualSpaceFlowLayout alloc] init];
        flowLayout.delegate = self;
        self.collectionFlowLayout = flowLayout;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JDTagCell class] forCellWithReuseIdentifier:kTagCellID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        WS(weakSelf);
    
#if __has_include("YYKit.h")
        
        [flowLayout addObserverBlockForKeyPath:@"autoHeight" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
            
            if (![newVal isEqualToString:oldVal]) {
                
                NSLog(@"NNNNNN==%@",newVal);
                if ([weakSelf.delegate respondsToSelector:@selector(tagsView:autoHeight:)]) {
                    [weakSelf.delegate tagsView:weakSelf autoHeight:[newVal floatValue]];
                }
            }
        }];
#else
        NSAssert(NO, @"请导入YYKit.h");
#endif
        
    }
    
    _collectionView.allowsSelection = _allowsSelection;
    _collectionView.allowsMultipleSelection = _allowsMultipleSelection;
    
    return _collectionView;
}

- (UIFont *)tagSelectedFont {
    if (!_tagSelectedFont) {
        return _tagFont;
    }
    
    return _tagSelectedFont;
}

- (UIColor *)tagSelectedBorderColor {
    if (!_tagSelectedBorderColor) {
        return _tagBorderColor;
    }
    
    return _tagSelectedBorderColor;
}

- (NSUInteger)selectedIndex {
    return self.collectionView.indexPathsForSelectedItems.firstObject.row;
}

- (NSMutableArray<JDTagModel *> *)tagModels {
    if (!_tagModels) {
        _tagModels = [[NSMutableArray alloc] init];
    }
    return _tagModels;
}

- (NSArray<NSString *> *)tagsArray {
    return [self.tagsMutableArray copy];
}

@end
