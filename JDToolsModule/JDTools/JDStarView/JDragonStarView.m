//
//  JDragonStarView.m
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import "JDragonStarView.h"


#define starBundlename @"JDragonBundle.bundle"
#define starBundlePath   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: starBundlename]
#define starBundle        [NSBundle bundleWithPath: starBundlePath]
@interface JDragonStarView ()

@property(nonatomic,assign) float  starWeight;
@property(nonatomic,strong) NSMutableArray  *starArr;
@property(nonatomic,assign) float  spaceWight;


@property(nonatomic,strong) UIImage  *normalImage;
@property(nonatomic,strong) UIImage  *halfImage;
@property(nonatomic,strong) UIImage  *selectImage;
@end

@implementation JDragonStarView

@synthesize starWeight,spaceWight,starArr;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    if (!starArr) {
        starArr = [NSMutableArray arrayWithCapacity:10];
    }
    starWeight=self.bounds.size.height;
    spaceWight = 5; //星级大-默认
    self.normalImage = [JDragonStarView createImageWithColor:[UIColor  grayColor]];
    self.halfImage = [JDragonStarView createImageWithColor:[UIColor  blackColor]];
    self.selectImage =  [JDragonStarView createImageWithColor:[UIColor  redColor]];
    UIImageView  *imageView ;
    for (int i = 0; i < 5; i++) {
        imageView = [[UIImageView alloc] initWithImage:self.normalImage];
        imageView.frame = CGRectMake(self.bounds.origin.x+((i)*starWeight)+5*i, self.bounds.origin.y, starWeight, starWeight);
        [self addSubview:imageView];
        [starArr addObject:imageView];
    }
}
-(void)setFaceViewSpaceWight:(float)space
{
    spaceWight = space;
    for (int i = 0; i < starArr.count; i++)
    {
        UIImageView  * imageView = starArr[i];
        imageView.frame = CGRectMake(self.bounds.origin.x+((i)*starWeight)+5*i, self.bounds.origin.y, starWeight, starWeight);
    }
}
-(void)rsetNromalImage:(UIImage*)normalImage halfImage:(UIImage*)halfImage selectImage:(UIImage*)selectImage
{
    self.normalImage = normalImage;
    self.halfImage = halfImage;
    self.selectImage = selectImage;
    [self setNorimageView];
}
-(void)setNorimageView
{
    for (int i = 0; i < starArr.count; i++)
    {
        UIImageView  * imageView = starArr[i];
        imageView.image = self.normalImage;
        imageView.frame = CGRectMake(self.bounds.origin.x+((i)*starWeight)+5*i, self.bounds.origin.y, starWeight, starWeight);
    }
}
-(void)setStarCountWith:(float)count andUserEnabled:(BOOL)isEnabled
{
    self.userInteractionEnabled = isEnabled;
    int  index = floorf(count);
    float  num = count - index;
    UIImageView *im ;
    for(int i = 0;i < 5 ; i++){
        im = starArr[i];
        UIImage   *img = self.selectImage;
        if (i==index) {
            if (num>0) {
                
                img = self.halfImage;
            }
            else
            {
                img = self.normalImage;
            }
        }else
            if (i>index) {
                
                img = self.normalImage;
            }
        im.image =img;
    }
}
#pragma mark - 点击的坐标
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIImageView *im ;
    //    CGFloat xx = touchPoint.x/(starWeight+5);
    for(int i = 0;i < 5 ; i++){
        im = starArr[i];
        if ((touchPoint.x > 0)&&(touchPoint.x < starWeight*7)&&(touchPoint.y > 0)&&(touchPoint.y < starWeight)) {
            
            if (im.frame.origin.x > touchPoint.x) {
                im.image = self.normalImage;
            }else
                if (im.center.x > touchPoint.x) {
                    
                    im.image =self.halfImage;
                }else
                {
                    im.image =self.selectImage;
                }
        }
    }
}
#pragma mark - 滑动的坐标
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIImageView *im ;
    for(int i = 0;i < 5 ; i++) {
        im = starArr[i];
        //        NSLog(@"_all[%i] = (%f,%f)",i,im.frame.origin.x,im.frame.origin.y);
        if ((touchPoint.x>= 0)&&(touchPoint.x < starWeight*7)&&(touchPoint.y > 0)&&(touchPoint.y < starWeight)) {
            
            if (im.frame.origin.x > touchPoint.x) {
                im.image = self.normalImage;
            }else
                if (im.center.x > touchPoint.x) {
                    im.image = self.halfImage;
                }else
                {
                    im.image = self.selectImage;
                }
        }
    }
}


+(UIImage *)createImageWithColor: (UIColor *)color;
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
