//
//  DZLevelIntroVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/10/30.
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZLevelIntroVC.h"

@interface DZLevelIntroVC ()

@property (weak, nonatomic) IBOutlet UIImageView *levelIgv1;
@property (weak, nonatomic) IBOutlet UIImageView *levelIgv2;
@property (weak, nonatomic) IBOutlet UIImageView *levelIgv3;
@property (weak, nonatomic) IBOutlet UIImageView *levelIgv4;
@property (weak, nonatomic) IBOutlet UIImageView *levelIgv5;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end

@implementation DZLevelIntroVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等级信息";
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView

#pragma mark - ---- 用户交互事件 ----

#pragma mark - ---- 私有方法 ----
- (void)getData{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/shopGrade"];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSDictionary *resultDict = request.responseJSONObject;
        NSString *status = [NSString stringWithFormat:@"%@", resultDict[@"status"]];
        if ([status isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSInteger num = [resultDict[@"data"][@"shop_level"][@"num"] integerValue];
            if (num == 1) {
                self.levelIgv5.hidden = YES;
                self.levelIgv4.hidden = YES;
                self.levelIgv3.hidden = YES;
                self.levelIgv2.hidden = YES;
            }else if (num == 2){
                self.levelIgv5.hidden = YES;
                self.levelIgv4.hidden = YES;
                self.levelIgv3.hidden = YES;
            }else if (num == 3){
                self.levelIgv5.hidden = YES;
                self.levelIgv4.hidden = YES;
            }else if (num == 4){
                self.levelIgv5.hidden = YES;
            }
            NSString *type = [NSString stringWithFormat:@"%@", resultDict[@"data"][@"shop_level"][@"type"]];
            if ([type isEqualToString:@"G4"]) {
                self.levelIgv5.image = [UIImage imageNamed:@"icon_goldcrown"];
            }else if ([type isEqualToString:@"G3"]){
                self.levelIgv5.image = [UIImage imageNamed:@"icon_silvercrown"];
            }else if ([type isEqualToString:@"G2"]){
                self.levelIgv5.image = [UIImage imageNamed:@"icon_dimon"];
            }
            self.pointLabel.text= [NSString stringWithFormat:@"%@分", resultDict[@"data"][@"next_upgrade"]];
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    
}

#pragma mark - --- getters 和 setters ----

@end
