//
//  JDPayCenterCell.m
//  JDMovie
//
//  Created by JDragon on 2018/9/12.
//  Copyright © 2018年 JDragon. All rights reserved.
//

#import "JDPayCenterCell.h"
#if __has_include("JDragonTableManager.h")
#import "JDragonTableManager.h"
#endif


#if __has_include("JDragonTableManager.h")
@interface  JDPayCenterCell()<JDTableManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleV;

@end;
#endif

@interface  JDPayCenterCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleV;

@end;

@implementation JDPayCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)PrepareToWithAppear:(NSObject *)data WithCurentVC:(UIViewController *)curentVC WithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *dic = (NSDictionary*)data;
    NSString  *img =  [dic valueForKey:@"image"];

    self.imgV.image = [UIImage imageNamed:img];
    self.titleV.text = [dic valueForKey:@"title"];
}

@end
