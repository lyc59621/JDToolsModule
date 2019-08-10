//
//  JDragonStarView.h
//  JDragonFrameWork
//
//  Created by long on 15/6/22.
//  Copyright (c) 2015年 姜锦龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDragonStarView : UIView


-(void)setFaceViewSpaceWight:(float)space;

-(void)rsetNromalImage:(UIImage*)normalImage halfImage:(UIImage*)halfImage selectImage:(UIImage*)selectImage;

-(void)setStarCountWith:(float)count andUserEnabled:(BOOL)isEnabled;
@end
