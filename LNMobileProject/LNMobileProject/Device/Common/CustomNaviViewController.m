//
//  CustomNaviViewController.m
//  Could
//
//  Created by hahaha on 15/5/15.
//  Copyright (c) 2015年 hahaha. All rights reserved.
//

#import "CustomNaviViewController.h"
#import "UIColor+Hex.h"

@interface CustomNaviViewController ()

@end

@implementation CustomNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault ];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    //选择自己喜欢的颜色
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.navigationBar setTitleTextAttributes:dict];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.view addGestureRecognizer:recognizer];

    self.scrolls=NO;
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    //先加载数据，再加载动画特效
    [self popViewControllerAnimated:YES];
}


+(UIBarButtonItem*)customButtonWithTitle:(NSString*)titles withImage:(UIImage*)image withBlock:(void (^)(UIButton *btn))block{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        button.frame = CGRectMake(0.0, 0.0, 40, 20);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:image forState:UIControlStateNormal];;
        [button setTitle:titles forState:UIControlStateNormal];
        
    }
    else
    {
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        float widthIs =
        [titles
         boundingRectWithSize:CGSizeMake(220, 27)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{ NSFontAttributeName:button.titleLabel.font }
         context:nil]
        .size.width;
        [button setTitleColor:[UIColor colorWithHexString:@"#008B56"] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, widthIs, 21);

        [button setTitle:titles forState:UIControlStateNormal];
    }
    
//    [button.titleLabel setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1]];
//    [button setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
    block(button);
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    

    return btn;
}
+(UIBarButtonItem*)customButtonWithTitle:(NSString*)titles withImage:(UIImage*)image WithTitle:(NSString*)str withBlock:(void (^)(UIButton *btn))block{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel* titleLab=[[UILabel alloc]init];
    UIImageView* iView=[[UIImageView alloc]init];
    if (image) {
        button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        //button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[button setImage:image forState:UIControlStateNormal];;
        //[button setTitle:titles forState:UIControlStateNormal];
        
        iView.frame=CGRectMake((button.frame.size.width-image.size.width)/2, 0, image.size.width, image.size.height);
        [iView setImage:image];
        [button addSubview:iView];
        
        titleLab.frame=CGRectMake(0, image.size.height+2, button.frame.size.width, 12);
        titleLab.font=[UIFont systemFontOfSize:11];
        titleLab.textColor=[UIColor colorWithHexString:@"313131"];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=str;
        [button addSubview:titleLab];
    }
//    else
//    {
//        
//        [button.titleLabel setFont:[UIFont fontWithName:@"Microsoft Yahei" size:16]];
//        float widthIs =
//        [titles
//         boundingRectWithSize:CGSizeMake(220, 27)
//         options:NSStringDrawingUsesLineFragmentOrigin
//         attributes:@{ NSFontAttributeName:button.titleLabel.font }
//         context:nil]
//        .size.width;
//        
//        button.frame=CGRectMake(0, 0, widthIs, 21);
//        
//        [button setTitle:titles forState:UIControlStateNormal];
//    }
    
    [button.titleLabel setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1]];
    [button setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
    block(button);
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    return btn;
}

+(UIBarButtonItem*)addBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   
        button.frame = CGRectMake(0.0, 0.0, [UIImage imageNamed:@"fanhuiBtn"].size.width, [UIImage imageNamed:@"fanhuiBtn"].size.height);
        [button setBackgroundImage:[UIImage imageNamed:@"fanhuiBtn"] forState:UIControlStateNormal];;
    
        
        
    [button.titleLabel setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1]];
    [button setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backs) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    return btn;
}


-(void)backs
{
//    __weak __typeof(&*self)weakSelf = self;
    //[self popViewControllerAnimated:YES];
    [self popViewControllerAnimated:YES];
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
