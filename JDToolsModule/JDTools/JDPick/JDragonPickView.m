//
//  JDragonPickView.m
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//


#define MONTH_ROW_MULTIPLIER 340
#define DEFAULT_MINIMUM_YEAR 1
#define DEFAULT_MAXIMUM_YEAR 99999
#define DATE_COMPONENT_FLAGS NSMonthCalendarUnit | NSYearCalendarUnit
#define PickMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define PickMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define PICKRGBCOLOR(HEX)     [UIColor colorWithRed:((((HEX)>>16)&0xFF))/255. green:((((HEX)>>8)&0xFF))/255.  blue:((((HEX)>>0)&0xFF))/255. alpha:1]
#define JDToobarHeight 54
#import "JDragonPickView.h"
#import "JDPopupViewPage.h"
#import "UIView+Blur.h"
#import "JDToolsModuleHeader.h"

#define kDistrictFileName [NSString stringWithFormat:@"centerDistrict.json"]

@interface JDragonPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,copy   ) NSString                 *plistName;
@property (nonatomic,strong ) NSArray                  *plistArray;
@property (nonatomic,assign ) BOOL                     isLevelArray;
@property (nonatomic,assign ) BOOL                     isLevelString;
@property (nonatomic,assign ) BOOL                     isLevelDic;
@property (nonatomic,strong ) NSDictionary             *levelTwoDic;
@property (nonatomic,strong ) UIToolbar                *toolbar;
@property (nonatomic,strong ) UIPickerView             *pickerView;
@property (nonatomic,strong ) UIDatePicker             *datePicker;
@property (nonatomic,assign ) UIDatePickerMode         systemDateMode;
@property (nonatomic,assign ) NSDate                   *defaulDate;
@property (nonatomic,assign ) BOOL                     isHaveNavControler;
@property (nonatomic,assign ) NSInteger                pickeviewHeight;
@property (nonatomic,copy   ) NSString                 *resultString;
@property (nonatomic,strong ) NSMutableArray           *componentArray;
@property (nonatomic,strong ) NSMutableArray           *dicKeyArray;
@property (nonatomic,copy   ) NSMutableArray           *state;
@property (nonatomic,copy   ) NSMutableArray           *city;
@property (nonatomic,strong ) UILabel                  *toolCenterLab;
@property (nonatomic,strong ) NSString                 *title;
@property (nonatomic,assign ) JDragonPickerStyle       pickerStyle;
@property (nonatomic,strong ) NSArray *provinces, *cities, *areas;
@property (nonatomic, strong) JDragonLocation          *locate;

@property (nonatomic        ) int                      monthComponent;
@property (nonatomic        ) int                      yearComponent;
@property (nonatomic,strong ) NSArray                  * yearArr;
@property (nonatomic,strong ) NSArray                  * mounthArr;


@property (strong, nonatomic)JDPopupViewPage *popupViewPage;
@property (strong, nonatomic)UIVisualEffectView *visualEffectView;

@end

@implementation JDragonPickView


@synthesize provinces,cities,areas;
-(JDragonLocation*)showLocation
{
    if (_showLocation==nil)
    {
        _showLocation = [[JDragonLocation alloc]init];
    }
    return _showLocation;
}
-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self enableBlur:true];
        self.blurStyle = UIViewBlurExtraLightStyle;
          [self setUpToolBar];
//        UIVisualEffectView
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] init];
        visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        visualEffectView.frame = self.pickerView.frame;
        self.visualEffectView = visualEffectView;
        [self insertSubview:visualEffectView atIndex:0];
//        [self sendSubviewToBack:visualEffectView];
    }
    return self;
}
-(instancetype)initPickviewWithCityPlist:(NSString*)cityPlistName isHaveNavController:(BOOL)isHaveNavControler titleStr:(NSString*)str
{
    
    self=[super init];
    if (self) {
        _plistName=cityPlistName;
        self.pickerStyle = JDragonPickWithStateAndCityAndDistrict;
        self.plistArray=[self getPlistArrayByplistName:cityPlistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        [self  setToolbarCenterTitleStr:str];
        [self setSeletedPick];
    }
    return self;
}

-(void)setSeletedPick
{
    self.locate = self.showLocation;
    if (self.pickerStyle==JDragonPickWithStateAndCityAndDistrict) {
        
        if([self.locate.province isEqualToString:@""]||self.locate.provinceID==nil)
        {
            self.locate.provinceID = [NSString  stringWithFormat:@"%@",[[provinces objectAtIndex:0] objectForKey:@"id"]] ;
            self.locate.province = [[provinces objectAtIndex:0] objectForKey:@"province"];
        }
        if([self.locate.city isEqualToString:@""]||self.locate.city==nil)
        {
            self.locate.cityID = [NSString  stringWithFormat:@"%@",[[cities objectAtIndex:0] objectForKey:@"id"]] ;
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        }
       
    for (int i=0; i<provinces.count; i++) {
        if ([[provinces[i] objectForKey:@"province"] isEqualToString:self.locate.province]) {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
            cities =  [[provinces objectAtIndex:i]objectForKey:@"cities"];
            [self.pickerView reloadComponent:1];
            self.locate.province = [[provinces objectAtIndex:i] objectForKey:@"province"];
            self.locate.provinceID = [NSString  stringWithFormat:@"%@",[[provinces objectAtIndex:i] objectForKey:@"id"]] ;
            break;
        }
    }
    for (int i=0; i<cities.count; i++) {
        
        if ([[cities[i] objectForKey:@"city"] isEqualToString:self.locate.city]) {
            [self.pickerView selectRow:i inComponent:1 animated:YES];
            self.locate.city = [[cities objectAtIndex:i] objectForKey:@"city"];
            self.locate.cityID = [NSString  stringWithFormat:@"%@",[[cities objectAtIndex:i] objectForKey:@"id"]] ;
            break;
        }
    }
   
        [self.pickerView  reloadAllComponents];
    }
    NSLog(@"省＝＝ %@",self.locate.province);
    NSLog(@"市 区＝＝ %@",self.locate.city);
}
#pragma mark---------------默认地区选择picker-------------------

-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str{
    
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        [self  setToolbarCenterTitleStr:str];
    }
    return self;
}
#pragma mark---------------数组选择picker-------------------

-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str{
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        [self  setToolbarCenterTitleStr:str];
    }
    return self;
}
#pragma mark---------------日期选择picker-------------------

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str{
    self=[super init];
    if (self) {
        [self  setToolbarCenterTitleStr:str];
        _defaulDate=defaulDate;
        _systemDateMode = datePickerMode;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

- (instancetype)initLiveStartPicker:(NSDate *)defaultDate isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString *)str {
    self=[super init];
    if (self) {
        [self  setToolbarCenterTitleStr:str];
        _defaulDate=defaultDate;
        _systemDateMode = UIDatePickerModeDateAndTime;
        [self setupLiveStartPickerView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}
#pragma mark---------------年月选择picker-------------------

-(instancetype)initDatePickWithYear:(NSInteger)year withMounth:(NSInteger)mounth isHaveNavControler:(BOOL)isHaveNavControler titleStr:(NSString*)str
{
    self=[super init];
    if (self) {
        self.pickerStyle = JDragonDatePickerYearAndMonuth;
        self.locate = [[JDragonLocation alloc]init];
        [self setUpPickView];
        [self  setToolbarCenterTitleStr:str];
        [self  setYearMounthPicker];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
    
}

-(void)setYearMounthPicker
{
    NSMutableArray  *yArr = [NSMutableArray  arrayWithCapacity:10];
    NSMutableArray  *mArr = [NSMutableArray  arrayWithCapacity:10];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    
    NSDate   *date=[NSDate  date];
    
    NSString  *str = [formatter  stringFromDate:date];
    
    [formatter setDateFormat:@"MM"];
    
    int   mstr = [formatter stringFromDate:date].intValue  -1;
    
    
    NSInteger   year = str.integerValue + 1;
    
    for (int  i=0; i<10; i++) {
        
        NSInteger y = year-i;
        
        NSString  *ystr = [NSString  stringWithFormat:@"%ld年",(long)y];
        
        [yArr addObject:ystr];
        
    }
    self.yearArr = [[yArr  reverseObjectEnumerator] allObjects];
    
    for (int  i=1; i<13; i++) {
        
        NSString  *MounthStr = [NSString  stringWithFormat:@"%ld月",(long)i];
        
        [mArr addObject:MounthStr];
        
    }
    self.mounthArr = [NSArray  arrayWithArray:mArr];
    
    if (self.locate.year==nil) {
        
        [self.pickerView selectRow:self.yearArr.count-2 inComponent:0 animated:YES];
        self.locate.year =  self.yearArr[self.yearArr.count-2];
    }
    if (self.locate.mounth==nil) {
        
        [self.pickerView selectRow:mstr inComponent:1 animated:YES];
        
        self.locate.mounth = self.mounthArr[mstr];
    }
}

#pragma mark----------------获取数组-----------------
-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{

    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
//    NSData *data=[NSData dataWithContentsOfFile:path];

    NSArray *array = [[NSArray alloc ]initWithContentsOfFile:path];

    if (self.pickerStyle==JDragonPickWithStateAndCityAndDistrict) {
        self.locate = [[JDragonLocation alloc]init];
        [self  setCityPickerWith:array];

    }else  {

    [self setArrayClass:array];

    }
    return array;
}

-(NSArray*)getDocumentArrByPath:(NSString*)path
{
    NSData *data=[NSData dataWithContentsOfFile:path];
    
    NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
    //    NSDictionary * dic=[[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray  *array = [dic objectForKey:@"data"];
    self.locate = [[JDragonLocation alloc]init];
    [self  setCityPickerWith:array];
    return array;
}
-(void)setCityPickerWith:(NSArray*)array
{
    provinces = array;
    cities =  [[provinces objectAtIndex:0]objectForKey:@"cities"];
    self.locate.province = [[provinces objectAtIndex:0] objectForKey:@"province"]; //省名市名
    self.locate.city = [[cities objectAtIndex:0]objectForKey:@"city"]; //
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
//            }
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+JDToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0, toolViewY, PickMainScreenWidth, toolViewH);
//    [self.toolbar jk_setRoundedCorners:UIRectCornerTopLeft radius:8];
//    [self.toolbar jk_setRoundedCorners:UIRectCornerTopRight radius:8];

}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.tag = 10101;
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
//    pickView.backgroundColor = RGBA(255, 255, 255, 1);
    pickView.frame=CGRectMake(0, JDToobarHeight, PickMainScreenWidth, 180);
    _pickeviewHeight=pickView.frame.size.height;
    self.visualEffectView.frame = self.pickerView.frame;
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
   
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    [datePicker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    if(datePickerMode==UIDatePickerModeDateAndTime)
    {
        [datePicker setMinimumDate:[NSDate date]];
        NSTimeInterval a_day = 24*60*60*30;
        NSDate *oneMonth = [NSDate dateWithTimeIntervalSinceNow:a_day];
        [datePicker setMaximumDate:oneMonth];
    }else
    {
        
        NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate*currentDate = [NSDate date];
        NSDateComponents*comps = [[NSDateComponents alloc]init];
        [comps setYear:-18];
        //设置最大时间为：当前时间推后十年
        NSDate*maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:-80];
        //设置最小时间为：当前时间前推十年
        NSDate*minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

        if (_defaulDate!=nil) {
            [datePicker setMaximumDate:_defaulDate];
        }else
        {
            [datePicker setMaximumDate:maxDate];
        }
        [datePicker setMinimumDate:minDate];
    }
    datePicker.backgroundColor=[UIColor clearColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, JDToobarHeight, PickMainScreenWidth, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
    self.visualEffectView.frame = datePicker.frame;
}

-(void) setupLiveStartPickerView {
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    [datePicker setCalendar:[NSCalendar currentCalendar]];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 *24];
    datePicker.backgroundColor=[UIColor clearColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, JDToobarHeight, PickMainScreenWidth, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}
#pragma mark------------------toolbar初始化 -----------------------------
-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolBarView];
}
-(void)setToolBarView
{
    UIView   *view = [[UIView alloc]initWithFrame:CGRectMake(0, JDToobarHeight-1, PickMainScreenWidth, 0.5)];
    view.backgroundColor = THEXCOLOR(0xc5c5c7);
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
    [self addSubview:view];
}
/**
 *  toolBar  默认样式
 *
 *  @return <#return value description#>
 */
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 10, PickMainScreenWidth/2, 20);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.tintColor = PICKRGBCOLOR(0X4a4a4a);
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
//    self.toolCenterLab  = [[UILabel  alloc]initWithFrame:CGRectMake(80, 10, PickMainScreenWidth-160, 20)];
//    self.toolCenterLab.textAlignment = NSTextAlignmentCenter;
//    self.toolCenterLab.font = [UIFont systemFontOfSize:14];
//    centerSpace.customView = self.toolCenterLab;
//    self.toolCenterLab.text = self.title;
    
    
    UIButton  *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(PickMainScreenWidth/2, 10, PickMainScreenWidth/2, 20);
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    button2.tintColor = PICKRGBCOLOR(0X007aff);
    [button2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button2 addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:button2];
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}
- (void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
    }
    self.toolCenterLab.backgroundColor = lineColor;
}

-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, JDToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (self.pickerStyle==JDragonPickWithStateAndCityAndDistrict) {
        
        return 2;
    }
    if (self.pickerStyle == JDragonDatePickerYearAndMonuth) {
        
        return 2;
    }
    
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    if (self.pickerStyle==JDragonPickWithStateAndCityAndDistrict) {
        
        
        switch (component) {
            case 0:
                return [provinces count];
                break;
            case 1:
                return [cities count];
                break;
            case 2:
                return [areas count];
                break;
            default:
                return 0;
                break;
        }
    }
    
    else if (self.pickerStyle ==JDragonDatePickerYearAndMonuth){
     
        
        switch (component) {
            case 0:
                return [self.yearArr count];
                break;
            case 1:
                return [self.mounthArr count];
                break;
            default:
                return 0;
                break;
        }
        return 0;
    }
    else
    {
         NSArray *rowArray=[[NSArray alloc] init];
            if (_isLevelArray) {
                rowArray=_plistArray[component];
            }else if (_isLevelString){
                rowArray=_plistArray;
            }else if (_isLevelDic){
                NSInteger pIndex = [pickerView selectedRowInComponent:0];
                NSDictionary *dic=_plistArray[pIndex];
                for (id dicValue in [dic allValues]) {
                        if ([dicValue isKindOfClass:[NSArray class]]) {
                            if (component%2==1) {
                                rowArray=dicValue;
                            }else{
                                rowArray=_plistArray;
                            }
                    }
                }
            }
        return rowArray.count;
        }
}
#pragma mark UIPickerViewdelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
        pickerLabel.textColor = PICKRGBCOLOR(0x4a4a4a);
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    
    if (self.pickerStyle==JDragonPickWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                rowTitle = [[provinces objectAtIndex:row] objectForKey:@"province"];
                  break;
            case 1:
                rowTitle =[[cities objectAtIndex:row] objectForKey:@"city"];
                break;
            default:
                return  @"";
                break;
        }
        
    }
    else if (self.pickerStyle==JDragonDatePickerYearAndMonuth){
        
        
        switch (component) {
            case 0:
            
                rowTitle = [self.yearArr objectAtIndex:row] ;
                
                break;
            case 1:
                rowTitle =[self.mounthArr objectAtIndex:row];
                break;
            default:
                return  @"";
                break;
        }
        
    }
    else
    {
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
        if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
        
            if (bb.count>row) {
                    rowTitle=aa[row];
                }
            }
        }
    }
    }
    return rowTitle;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //设置选中行lab
    UILabel  *lab  = [pickerView viewForRow:row forComponent:component];
    
    if(self.pickerStyle==JDragonPickWithStateAndCityAndDistrict){
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.pickerView selectRow:row inComponent:0 animated:YES];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
                self.locate.province = [[provinces objectAtIndex:row] objectForKey:@"province"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                
                self.locate.provinceID = [NSString  stringWithFormat:@"%@",[[provinces objectAtIndex:row] objectForKey:@"id"]] ;
                self.locate.cityID = [NSString  stringWithFormat:@"%@",[[cities objectAtIndex:0] objectForKey:@"id"]] ;
                break;
            case 1:
                [self.pickerView selectRow:row inComponent:1 animated:YES];
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                self.locate.cityID = [NSString  stringWithFormat:@"%@",[[cities objectAtIndex:row] objectForKey:@"id"]] ;
                break;
            default:
                break;
        }
           NSLog(@"11111111stststtstst%@",self.locate.province);
    }
    else if (self.pickerStyle ==JDragonDatePickerYearAndMonuth){
        switch (component) {
            case 0:
                 self.locate.year = self.yearArr[row];
                self.locate.mounth = self.mounthArr[0];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
                break;
            case 1:
                self.locate.mounth = self.mounthArr[row];
                break;
                default:
                break;
                
        }
    }
    else {
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:75 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                          }
        }
    }else if (_isLevelDic){
        if (component==0) {
          _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46;
}
-(void)remove{
    
    [self.popupViewPage dismiss];
}
-(void)show
{
    self.popupViewPage = [JDPopupViewPage new];
    self.popupViewPage.layoutType = JDPopupLayoutTypeBottom;
    self.popupViewPage.dismissOnMaskTouched = YES;
    [self.popupViewPage presentContentView:self];
}
-(void)doneClick
{
    if (_pickerView) {
        
        if (_resultString) {
           
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                
                if (_state==nil) {
                     _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }
              _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
           }
        }
    }else if (_datePicker) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        if (_systemDateMode==UIDatePickerModeDateAndTime)
        {
             [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];  
        }else
        {
             [dateFormat setDateFormat:@"yyyy-MM-dd"];
            
        }
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [dateFormat setTimeZone:timeZone];
        _resultString=[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:_datePicker.date]];
        
    }
    if ([self.delegate respondsToSelector:@selector(toolbarDonBtnHaveClick:resultArea:)]) {
        [self.delegate toolbarDonBtnHaveClick:self resultArea:self.locate.city];
    }
    if(self.pickerStyle == JDragonPickWithStateAndCityAndDistrict){
        
        _resultString = [NSString stringWithFormat:@"%@ %@ ", self.locate.province, self.locate.city];
    }
    else if (self.pickerStyle == JDragonDatePickerYearAndMonuth) {
        
        NSString  *year = self.locate.year;
        NSString  *mounth = self.locate.mounth;
          _resultString = [NSString stringWithFormat:@"%@-%@",[year substringToIndex:year.length-1], [mounth substringToIndex:mounth.length-1]];
    }
    self.showLocation = self.locate;
    if ([self.delegate respondsToSelector:@selector(toolbarDonBtnHaveClick:resultString:)]) {
        [self.delegate toolbarDonBtnHaveClick:self resultString:_resultString];
    }
    
    if (self.plistArray.count > 0) {
        if ([self.delegate respondsToSelector:@selector(toolbarDonBtnHaveClick:selectedRow:resultString:)]) {
            [self.delegate toolbarDonBtnHaveClick:self selectedRow:[self.plistArray indexOfObject:_resultString] resultString:_resultString];
        }
    }
    
    
//    [self removeFromSuperview];
//     [self.win dissMiss];
    [self.popupViewPage dismiss];

}
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}
/**
 *  设置toolbar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
/**
 *  设置toolbar中间title标题
 */
-(void)setToolbarCenterTitleStr:(NSString*)str
{
    
    self.toolCenterLab.text = str;
    
    
}

/**
 *  设置选中行
 */
-(void)setSeletedRow:(NSInteger)row
{
    UIPickerView  *picker = (UIPickerView*)[self viewWithTag:10101];
   [picker  selectRow:row inComponent:0 animated:YES];
}


#pragma mark--------------------tools------------------

+ (void)insertCitysDataToPlist:(NSArray *)array
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"citys.plist"];
    NSArray *cityArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    if (cityArr==nil) {
        cityArr = array;
    }
    //写入文件
    [cityArr writeToFile:plistPath atomically:YES];
    
}
+ (NSArray*)getCitysPlistAction
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"citys.plist"];
    NSArray *cityArr = [[NSArray alloc ]initWithContentsOfFile:plistPath];
    return cityArr;
}
@end

