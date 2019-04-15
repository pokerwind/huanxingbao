//
//  DZCircleDetailViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZCircleDetailViewController.h"
#import "JSCircleDetailModel.h"
#import "DZPraiseListViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import<ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <LinkedME_iOS/LMLinkProperties.h>
#import <LinkedME_iOS/LMUniversalObject.h>

@interface DZCircleDetailViewController ()<UIWebViewDelegate>
/*
 * webView
 */
@property (nonatomic,strong)UIWebView *webView;

/*
 * 评论按钮
 */
@property (nonatomic,strong)UIButton *commentBtn;

/*
 * 点赞按钮
 */
@property (nonatomic,strong)UIButton *praiseBtn;

/*
 * 点赞数量
 */
@property (nonatomic,copy)NSString *praiseNum;

/*
 * 评论数量
 */
@property (nonatomic,copy)NSString *commentNum;

/*
 * 是否点赞过
 */
@property (nonatomic,copy)NSString *has_like;

@property(nonatomic,strong) LMUniversalObject *linkedUniversalObject;

@end

@implementation DZCircleDetailViewController

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gooddetail_icon_other_b"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    self.webView.delegate = self;
    //self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
   
    [self getData];
}

- (void)rightBtnClick:(UIButton *)btn
{
    [self share];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 代理相关 ----

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    
    //重写contentSize,防止左右滑动
    
    CGSize size = webView.scrollView.contentSize;
    
    size.width= webView.scrollView.frame.size.width;
    
    webView.scrollView.contentSize= size;
    
    [SVProgressHUD dismiss];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:error.description];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"article_id":self.article_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/check_like_status" parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        JSCircleDetailModel *model = [JSCircleDetailModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.has_like = request.responseJSONObject[@"data"][@"has_like"];
            self.praiseNum = request.responseJSONObject[@"data"][@"like_count"];
            self.commentNum = request.responseJSONObject[@"data"][@"comment_count"];
            
            [self layoutCell];
//            NSString* resultString = request.responseJSONObject[@"data"][@"content"];
//            [self.webView loadHTMLString:resultString baseURL:nil];
//            [self addObserverForWebViewContentSize];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KNavigationBarH - 44);
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Api/ArticleApi/articleContent?article_id=%@",DEFAULT_HTTP_HOST,self.article_id]]]];
        }
    return _webView;
}



//- (void)addObserverForWebViewContentSize{
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
//}
//
//- (void)removeObserverForWebViewContentSize{
//  [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}

//以下是监听结果回调事件：

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{//在这里边添加你的
//    [self layoutCell];
}
//设置footerView的合理位置

- (void)layoutCell{
    //取消监听，因为这里会调整contentSize，避免无限递
//    [self removeObserverForWebViewContentSize];
//    CGSize contentSize = self.webView.scrollView.contentSize;
    UIView *vi = [[UIView alloc]init];
    vi.backgroundColor = [UIColor whiteColor];
    vi.userInteractionEnabled = YES;
    vi.frame = CGRectMake(0, KScreenHeight- KNavigationBarH - 44, KScreenWidth, 44);
    [self.view addSubview:vi];
//    self.webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [vi addSubview:lineView];
    lineView.frame = CGRectMake(0, 0, KScreenWidth, 0.5);
    
    UIButton *conmentBtn = [[UIButton alloc]init];
    
    self.commentBtn = conmentBtn;
    [vi addSubview:conmentBtn];
    
    [conmentBtn setImage:[UIImage imageNamed:@"JScommunityMessage"] forState:UIControlStateNormal];
    [conmentBtn setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
    
    [conmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(vi).mas_offset(-25);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(vi);
    }];
    
    [conmentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *praiseBtn = [[UIButton alloc]init];
    self.praiseBtn = praiseBtn;
    [vi addSubview:praiseBtn];
    if ([self.has_like integerValue] == 0) {
        //未点过赞
        [praiseBtn setImage:[UIImage imageNamed:@"JScommunityPraise"] forState:UIControlStateNormal];
    }else{
        //已点过赞
        [praiseBtn setImage:[UIImage imageNamed:@"JSPraised"] forState:UIControlStateNormal];
    }
    
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@",self.praiseNum] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %@",self.commentNum] forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
    
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(conmentBtn.mas_left).mas_offset(-20);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(vi);
    }];
    
    [praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //重新监听
//    [self addObserverForWebViewContentSize];
}

- (void)commentBtnClick:(UIButton *)btn
{
   DZPraiseListViewController *praiseVc =  [[DZPraiseListViewController alloc]init];
    praiseVc.artid = self.article_id;
    [self.navigationController pushViewController:praiseVc animated:YES];
}

- (void)praiseBtnClick:(UIButton *)btn
{
    [self praiseRequest];
}


#pragma mark - ---- 私有方法 ----
- (void)praiseRequest{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleUserApi/articleLike" parameters:@{@"article_id":self.article_id}];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([[request.responseJSONObject objectForKey:@"status"] integerValue] == 1) {
            [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@",[request.responseJSONObject objectForKey:@"data"]] forState:UIControlStateNormal];
            [self.praiseBtn setImage:[UIImage imageNamed:@"JSPraised"] forState:UIControlStateNormal];
        } else {
            [SVProgressHUD showInfoWithStatus:[request.responseJSONObject objectForKey:@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
- (void)shudutuiguangAction:(NSDictionary *)dic {
    //分享
    self.linkedUniversalObject = [[LMUniversalObject alloc] init];
    self.linkedUniversalObject.title = @"标题";//标题
    LMLinkProperties *linkProperties = [[LMLinkProperties alloc] init];
    linkProperties.channel = @"微信";//渠道(微信,微博,QQ,等...)
    linkProperties.feature = @"Share";//特点
    linkProperties.tags=@[@"LinkedME",@"Demo"];//标签
    linkProperties.stage = @"Live";//阶段
//    [linkProperties addControlParam:@"parent_id" withValue:dic[@"parent_id"]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识
    [linkProperties addControlParam:@"View" withValue:dic[@"url"]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识

    //    [linkProperties addControlParam:@"LinkedME" withValue:@"Demo"];//自定义参数，用于在深度链接跳转后获取该数据，这里标识是Demo
    //开始请求短链
    
    [self.linkedUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *err) {
        NSString *liveURLStr = @"";
        if (url) {
            NSLog(@"[LinkedME Info] SDK creates the url is:%@", url);
            //拼接连接1
            //            [H5_LIVE_URL stringByAppendingString:arr[page][@"form"]];
            //            [H5_LIVE_URL stringByAppendingString:@"?linkedme="];
            liveURLStr = [NSString stringWithFormat:@"%@?linkedme=%@",dic[@"url"],url];
            //前面是Html5页面,后面拼上深度链接https://xxxxx.xxx (html5 页面地址) ?linkedme=(深度链接)
            //https://www.linkedme.cc/h5/feature?linkedme=https://lkme.cc/AfC/mj9H87tk7
            //            liveURLStr = [liveURLStr stringByAppendingString:];
            //            liveURLStr = url;
            //            liveURLStr = url;
        } else {
            liveURLStr = dic[@"url"];
            //            LINKEDME_SHORT_URL = H5_LIVE_URL;
        }
        
        /*分享分享*/
        //1、创建分享参数
        NSArray* imageArray = @[FULL_URL(dic[@"thumb_img"])];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:dic[@"introduce"]
                                             images:imageArray
                                                url:[NSURL URLWithString:liveURLStr]
                                              title:dic[@"title"]
                                               type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
            //[shareParams SSDKEnableUseClientShare];
            //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
            [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            NSArray *items = nil;
            items = @[@(SSDKPlatformTypeQQ),
                      @(SSDKPlatformTypeWechat),
                      ];
            [ShareSDK showShareActionSheet:self.view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:items
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
        
        
        
    }];
}
- (void)share {
    
    [SVProgressHUD show];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/DeepLinkApi/click_share_article" parameters:@{@"article_id":[NSString stringWithFormat:@"%@",self.article_id]}];
    __weak typeof(self) weakSelf = self;
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"status"] integerValue] == 1) {
            [weakSelf shudutuiguangAction:dict[@"data"]];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络获取失败"];
    }];
}

- (void)dealloc
{
}

@end
