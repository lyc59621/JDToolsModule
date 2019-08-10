//
//  JDShareManager.m
//  JDMovie
//
//  Created by JDragon on 2018/9/27.
//  Copyright © 2018 JDragon. All rights reserved.
//

#import "JDShareManager.h"
#import "JDBaseModuleHeader.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>


#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//不同宽度的和320宽度的缩放比
#define WIDTH_SCALE (SCREEN_WIDTH/320.f)
#define HEIGHT_SCALE  (SCREEN_HEIGHT/568.f)

static NSMutableDictionary *_shareParams;
static NSString *shareUrl;


@implementation JDShareManager
+(void)ShareNormalParams:(NSDictionary*)params WithType:(NSInteger)type ActionResult:(SSDKShareStateChangedHandler)resultBlock
{

    
    
    
    
}
+(void)ShareNormalParams:(NSDictionary*)params ActionResult:(SSDKShareStateChangedHandler)resultBlock
{
    NSDictionary  *dd = [params copy];
    NSString  *scheme = dd[@"scheme"];
    if ([scheme isEqualToString:@"JDmovie://"]) {
         [JDShareManager ShareTextActionWithTitle:dd[@"title"] ShareContent:dd[@"content"]  ShareUlr:dd[@"shareUrl"]  imageURL:dd[@"imageUrl"] Result:resultBlock];
        return;
    }
     NSMutableDictionary  *dic = [[NSMutableDictionary alloc]initWithDictionary:dd];
    [dic setValue:@"common" forKey:@"type"];
    [JDRequest startRequestWithUrl:@"/share" withExtendArguments:dic withCompletionBlockWithSuccess:^(JDRequest * _Nonnull request) {
        DDLogVerbose(@"分享请求数据==%@",request.filtResponseObj);
         [JDShareManager ShareTextActionWithTitle:dic[@"title"] ShareContent:dic[@"content"]  ShareUlr:request.filtResponseObj[@"shareUrl"]  imageURL:dic[@"imageUrl"] Result:resultBlock];
    }];
}
+(void)ShareTextActionWithTitle:(NSString*)title ShareContent:(NSString*)content ShareUlr:(NSString*)url imageURL:(id)imageURL Result:(SSDKShareStateChangedHandler)resultBlock

{
    content = content.length>150?[content substringToIndex:149]:content;
    //设置分享参数
    shareUrl = url;
    myResultBlock = resultBlock;
    NSArray* imageArray = @[imageURL];
    //    UIImage *iconImage = [UIImage imageNamed:@"AppIcon"];
    _shareParams = [[NSMutableDictionary alloc]init];
//    [_shareParams SSDKSetupWeChatParamsByText:[NSString stringWithFormat:@"%@",content] title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    [_shareParams SSDKSetupWeChatParamsByText:[NSString stringWithFormat:@"%@",content]  title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
//    [_shareParams SSDKSetupWeChatParamsByText:[NSString stringWithFormat:@"%@",content]  title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatFav];
//    [_shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",content,url] title:title image:imageArray url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
//    [_shareParams SSDKSetupQQParamsByText:[NSString stringWithFormat:@"%@",content]  title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//    [_shareParams SSDKSetupQQParamsByText:[NSString stringWithFormat:@"%@",content] title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    [_shareParams SSDKSetupWeChatParamsByText:[NSString stringWithFormat:@"%@",content] title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [_shareParams SSDKSetupQQParamsByText:[NSString stringWithFormat:@"%@",content] title:title url:[NSURL URLWithString:url] audioFlashURL:nil videoFlashURL:nil thumbImage:imageURL images:imageArray type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [_shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",content,url]  title:title images:imageArray video:nil url:[NSURL URLWithString:url]  latitude:0 longitude:0 objectID:nil isShareToStory:true type:SSDKContentTypeAuto];
    
    [_shareParams SSDKSetupWeChatParamsByText:[NSString stringWithFormat:@"%@",content] title:title url:[NSURL URLWithString:url] thumbImage:imageURL image:imageURL musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [JDShareManager createCustomUIAction];
}



+(void)createCustomUIAction
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //透明蒙层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    grayView.tag = 60000;
    UITapGestureRecognizer *tapGrayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShareAction)];
    [grayView addGestureRecognizer:tapGrayView];
    grayView.userInteractionEnabled = YES;
    [window addSubview:grayView];
    
    //分享控制器
    UIView *shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];//250*HEIGHT_SCALE
    shareBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
//    [shareBackView jk_setRoundedCorners:UIRectCornerTopLeft radius:8];
//    [shareBackView jk_setRoundedCorners:UIRectCornerTopRight radius:8];
    shareBackView.tag = 60001;
    [window addSubview:shareBackView];

    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] init];
    visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    visualEffectView.frame = shareBackView.bounds;
    [shareBackView addSubview:visualEffectView];
    
    
    UILabel  *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, kMainScreenWidth, 16)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"分享到";
    titleLab.font = KJD_FONT_Regular(14);
    titleLab.textColor  = HEXCOLOR(0x818181);
    
    [shareBackView addSubview:titleLab];
    
    //分享图标和标题数组
    NSArray *imageNameArr = @[@"bShareWechatX",@"bShareQqX",@"bShareSinaX",@"bShareCircleX"];
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *imageName in imageNameArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    NSArray *titlesArr = @[@"微信",@"QQ",@"微博",@"朋友圈"];
    
    NSMutableArray *titleNameArr = [NSMutableArray array];
    for (NSString *title in titlesArr) {
        [titleNameArr addObject:title];
    }
    //分享按钮
    CGFloat itemWidth =  KAdaptedWidth(44)+10;
    CGFloat itemHeight = itemWidth+25;
    CGFloat spaceX = (SCREEN_WIDTH-itemWidth*4-100)/5;
    CGFloat spaceY = 30;
    NSInteger rowCount = 4;
    
    UIView  *itemsV = [[UIView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(titleLab.frame)+20, kMainScreenWidth-100, itemHeight)];
    [shareBackView addSubview:itemsV];
    UIView  *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(itemsV.frame)+10, kMainScreenWidth, 0.7)];
    lineV.backgroundColor  =  HEXCOLOR(0xc5c5c7);
    [shareBackView addSubview:lineV];
    
    for (int i =0; i<titleNameArr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(spaceX + (i%rowCount)*(itemWidth+spaceX), 0, itemWidth, itemWidth);
        [iconBtn setImage:imagesArr[i] forState:UIControlStateNormal];
        iconBtn.tag = 2000 + i;
        [iconBtn addTarget:self action:@selector(shareItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemsV addSubview:iconBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemWidth+20, 20)];
        titleLabel.center = CGPointMake(CGRectGetMinX(iconBtn.frame)+itemWidth/2, CGRectGetMaxY(iconBtn.frame)+20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = HEXCOLOR(0x818181);
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.text = titleNameArr[i];
        [itemsV addSubview:titleLabel];
    }
    if (titleNameArr.count<=4) {
//        shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250*HEIGHT_SCALE/2 + 44);
       shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetMaxY(lineV.frame)+50);
    }
    UIButton  *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:KJD_FONT_Regular(16)];
    [cancelBtn setTitleColor:HEXCOLOR(0x4a4a4a) forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, shareBackView.size.height-50, kScreenWidth, 50);
    [shareBackView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelShareAction) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.35 animations:^{
        shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT-shareBackView.frame.size.height,shareBackView.frame.size.width, shareBackView.frame.size.height);
    }];

    
}
+(void)shareItemAction:(UIButton*)button
{
    [self removeShareView];
    NSInteger sharetype = 1;
    NSMutableDictionary *publishContent = _shareParams;
    [publishContent SSDKEnableUseClientShare];
    switch (button.tag) {
        case 2000:
        {
            sharetype =SSDKPlatformSubTypeWechatSession ;
        }
            break;
        case 2001:
        {
            sharetype =SSDKPlatformSubTypeQQFriend ;
        }
            break;
        case 2002:
        {
            sharetype = SSDKPlatformTypeSinaWeibo;
        }
            break;
        case 2003:
        {
            sharetype = SSDKPlatformSubTypeWechatTimeline;

            //复制
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
////            [pasteboard setString:@"http://www.JDmovie.com/download/"];
//             [pasteboard setString:shareUrl];
//            [MBProgressHUD showSuccessMessage:@"复制成功"];
//            return;
        }
    }
    if (sharetype == 0)
    {
        [self removeShareView];
    }else
    {
        //调用ShareSDK的无UI分享方法
        [ShareSDK share:sharetype parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (myResultBlock) {
                myResultBlock(state,userData,contentEntity,error);
            }
            [JDShareManager shareEnadActionWithState:state userData:userData Entity:contentEntity error:error];
        }];
    }
}
+(void)removeShareView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:60000];
    UIView *shareView = [window viewWithTag:60001];
    shareView.frame =CGRectMake(0, shareView.frame.origin.y, shareView.frame.size.width, shareView.frame.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        shareView.frame = CGRectMake(0, SCREEN_HEIGHT, shareView.frame.size.width, shareView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    
}
+(void)cancelShareAction{
    
    [self removeShareView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KNotiVideoPlayForShare" object:nil];
}
+(void)shareEnadActionWithState:(SSDKResponseState)state userData:(NSDictionary *)userData Entity:(SSDKContentEntity*)e error:(NSError*)error
{
    
    switch (state) {
            
        case SSDKResponseStateBegin:
        {
            break;
        }
        case SSDKResponseStateSuccess:
        {
            [MBProgressHUD showSuccessMessage:@"分享成功"];
            break;
        }
        case SSDKResponseStateFail:
        {
            [MBProgressHUD showErrorMessage:[NSString stringWithFormat:@"%@",error]];

            break;
        }
        case SSDKResponseStateCancel:
        {
            [MBProgressHUD showErrorMessage:@"分享取消"];
            break;
        }
//        case SSDKResponseStateBeginUPLoad: {
//            
//            break;
//        }
            case SSDKResponseStateUpload: {
                
                break;
            }
    }
}

@end
