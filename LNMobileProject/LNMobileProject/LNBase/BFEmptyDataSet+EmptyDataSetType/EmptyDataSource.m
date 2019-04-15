//
//  EmptyDataSource.m
//  BFEmptyDataSet
//
//  Created by LiuNiu-MacMini-YQ on 16/8/16.
//  Copyright © 2016年 qtone_yzt. All rights reserved.
//

#import "EmptyDataSource.h"
#import "LNMacros.h"
#define BFColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation EmptyDataSource


#pragma mark - BFEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"results_tips6"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIView *)view{
    NSString *text = @"哎呀,加载失败了...";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:BFColor(0, 174, 239, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIView *)view{
    NSString *text = @"请检查您的网络设置或点击重试";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13],
                                 NSForegroundColorAttributeName:BFColor(74, 74, 74, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIView *)view
{
    return BFColor(250, 250, 250, 1);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIView *)view
{
    return 5.0f;
}


#pragma mark - customViewForEmptyDataSet
- (UIView *)customViewForEmptyDataSet:(UIView *)view{
    UIView *emptyView;
    switch (view.emptyDataType) {
        case EmptyDataTypeLoading:
            emptyView = [self loadView:view];
            break;
        case EmptyDataTypeConnectError:
            emptyView = [self connetErrorView:view];
            break;
        case EmptyDataTypeLogin:
            emptyView = [self loginView:view];
            break;
        case EmptyDataTypeList:
            emptyView = [self emptyListView:view];
            break;
        default:
            break;
    }
    return emptyView;
}

- (UIView *)loadView:(UIView *)view{
    UIView *customView=[[UIView alloc] init];
    customView.backgroundColor= BgColor;//HEXCOLOR(0xFFFFFF);
    
    UIImageView *activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_loading"]];
    activityView.contentMode =UIViewContentModeScaleAspectFill;
    [customView addSubview:activityView];
   
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.3;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    [activityView.layer addAnimation:animation forKey:@"jjjj"];
    
    
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [customView addSubview:activityView];
//    [activityView startAnimating];
    
    UILabel *label=[[UILabel alloc] init];
    label.text=  @"正在加载数据";
    label.textColor=HEXCOLOR(0x585858);
    label.textAlignment=NSTextAlignmentCenter;
    [customView addSubview:label];
    
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(activityView.superview);
        make.centerY.equalTo(activityView.superview).offset(-20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(activityView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    return customView;
}

- (UIView *)connetErrorView:(UIView *)view{
    UIView *customView=[[UIView alloc] init];
    customView.backgroundColor= BgColor;//HEXCOLOR(0xFFFFFF);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_remote"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [customView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc] init];
    label.text = @"网络连接失败";
    label.textColor=HEXCOLOR(0x585858);
    label.textAlignment=NSTextAlignmentCenter;
    [customView addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.superview);
        make.centerY.equalTo(imageView.superview).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    return customView;
}

- (UIView *)emptyListView:(UIView *)view{
//    empty_book
    UIView *customView=[[UIView alloc] init];
    customView.backgroundColor= BgColor;//HEXCOLOR(0xFFFFFF);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_null"]];
    [customView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc] init];
    label.text = @"数据列表为空";
    label.textColor=HEXCOLOR(0x585858);
    label.textAlignment=NSTextAlignmentCenter;
    [customView addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.superview);
        make.centerY.equalTo(imageView.superview).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    return customView;
}

- (UIView *)loginView:(UIView *)view{
    UIView *customView=[[UIView alloc] initWithFrame:view.bounds];
    customView.backgroundColor = BgColor;//HEXCOLOR(0xEFEFEF);
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, (customView.frame.size.height-24)*0.5, customView.frame.size.width, 24)];
    label.text=@"这是自定义的登录视图";
    label.textColor=[UIColor blueColor];
    label.textAlignment=NSTextAlignmentCenter;
    [customView addSubview:label];
    return customView;
}

@end
