//
//  DZNoticeDetailVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/11/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZNoticeDetailVC.h"

@interface DZNoticeDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DZNoticeDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公告详情";
    
    self.webView.delegate = self;
    
    [self getData];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UIWebView
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:error.description];
}

#pragma mark - ---- 事件响应 ----

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"article_id":self.article_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.titleLabel.text = request.responseJSONObject[@"data"][@"title"];
            self.timeLabel.text = request.responseJSONObject[@"data"][@"addtime"];
            NSString* resultString = request.responseJSONObject[@"data"][@"content"];
            [SVProgressHUD show];
            
            NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                               "<head> \n"
                               "<style type=\"text/css\"> \n"
                               "\n"
                               "</style> \n"
                               "</head> \n"
                               "<body>"
                               "<script type='text/javascript'>"
                               "window.onload = function(){\n"
                               "var $img = document.getElementsByTagName('img');\n"
                               "for(var p in  $img){\n"
                               " $img[p].style.width = '100%%';\n"
                               "$img[p].style.height ='auto'\n"
                               "}\n"
                               "}"
                               "</script>%@"
                               "</body>"
                               "</html>",resultString];
            
            
            [self.webView loadHTMLString:htmls baseURL:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
#pragma mark - ---- 公有方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    
}
- (void) setSubViewsFrame{
    
}
#pragma mark - --- getters 和 setters ----

@end
