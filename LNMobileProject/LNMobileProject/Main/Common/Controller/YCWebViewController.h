//
//  WebViewController.h
//  MobileProject
//
//  Created by 云网通 on 16/3/10.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNBaseVC.h"

@interface YCWebViewController : LNBaseVC<UIWebViewDelegate>
@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString * noticeID;

@property(copy, nonatomic) NSString *web_title;
@property(copy, nonatomic) NSString *web_url;
@property(copy, nonatomic) NSString *isShare;
@property(copy, nonatomic) NSString *article_id;

@property(copy, nonatomic) NSString *thumb_img;
@property(copy, nonatomic) NSString *desc;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end
