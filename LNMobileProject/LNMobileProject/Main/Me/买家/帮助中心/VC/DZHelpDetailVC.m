//
//  DZHelpDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/4.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHelpDetailVC.h"

@interface DZHelpDetailVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DZHelpDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    self.webView.delegate = self;
    //self.webView.scalesPageToFit = YES;
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 代理相关 ----
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:error.description];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"article_id":self.article_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.title = request.responseJSONObject[@"data"][@"title"];
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
        
            //[self.webView loadHTMLString:resultString baseURL:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----

@end
