//
//  WebViewController.m
//  MobileProject
//
//  Created by 云网通 on 16/3/10.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "YCWebViewController.h"

@interface YCWebViewController (){
    
}

//@property (assign,nonatomic) BOOL naviBarHidden;
@property (strong,nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (strong,nonatomic)NSString *currentURL;
@end

@implementation YCWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;

    if (_web_title) {
        self.customTitleLabel.text = _web_title;
    }
    if (self.title) {
        self.customTitleLabel.text = self.title;
    }
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.webView setDelegate: self];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
//    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.webView.scrollView.bounces=NO;
    [self.view addSubview: self.webView];
    if (self.noticeID) {
//        //如果有通知id，则用post获取网页内容，再载入。
//        
//        NSDictionary *dict = @{@"id":self.noticeID};
//        NSString *code = [dict mj_JSONString];
//        
//        NSDictionary *parameters = @{@"code":code};
//        
////        // 请求的manager
////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////        /*
////         * desc  : 提交POST请求
////         * param :  URLString - 请求地址
////         *          parameters - 请求参数
////         *          success - 请求成功回调的block
////         *          failure - 请求失败回调的block
////         */
////        [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, @"login"] parameters:parameters
////              success:^(AFHTTPRequestOperation *operation, id responseObject) {
////                  NSLog(@"login success!!!");
////                  // 解析服务器返回来的json数据（AFNetworking默认解析json数据）
////                  if (responseObject != nil) {
////                      NSDictionary *respObj = responseObject;
////                      NSString *result = [respObj objectForKey:@"result"];
////                      if (result && [result isEqualToString:@"ok"]) {
////                          NSLog(@"the result :%@", result);
////                      }
////                  }
////              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////                  NSLog(@"err:%@", error);
////              }];
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain",nil];
//        [manager POST:[NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,@"Article/ArticleApi/noticeDetail"] parameters:@{@"code":code} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSData *data = responseObject;
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//            [self.webView loadHTMLString:str baseURL:nil];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            
//        }];
        
//        [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            //NSLog(@"dic  ==== %@",dic);
//            success(dic, tokenDic);
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //NSLog(@"error %ld",(long)error.code);
//            failure(error);
//        }];
//        
//        NoticeDetailAPI *detailAPI = [[NoticeDetailAPI alloc] initWithID:self.noticeID];
//        
//        [detailAPI startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//            id result = request.responseJSONObject;
//            NSLog(@"result %@",result);
//        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//            NSLog(@"error: %@",error.domain);
//        }];
        
    } else if(self.content) {
        [self.webView loadHTMLString:self.content baseURL:nil];
    } else  {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_web_url]];
        [self.webView loadRequest:request];
    }
    

//    self.naviBarHidden = self.navigationController.navigationBarHidden;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = self.naviBarHidden;
    [SVProgressHUD dismiss];
    //[self hideLoading];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
    //[self showLoading:@"加载中"];
    NSLog(@"webViewDidStartLoad");
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //[self hideLoading];
    [SVProgressHUD dismiss];
    NSLog(@"webViewDidFinishLoad");
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if ([title notBlank]) {
        self.navigationItem.title = title;
    }
//    if(!self.title) {
//        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];    
//    }

    // 取消用户编辑
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout ='none';"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[self hideLoading];
    [SVProgressHUD dismiss];
    NSLog(@"didFailLoadWithError:%@", error);
}

- (IBAction)leftArrowAction:(UIButton *)sender {
    if(self.webView.canGoBack){
        NSLog(@"canGoback");
        [self.webView goBack];
    }else{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
#pragma mark - ---- 私有方法 ----
@end
