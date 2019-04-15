//
//  DZFeedbackVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/10/30.
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZFeedbackVC.h"

#import "UITextView+ZWPlaceHolder.h"

@interface DZFeedbackVC ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@end

@implementation DZFeedbackVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.contentTextView.placeholder = @"请输入您的宝贵意见";
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
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
- (IBAction)submitButtonClick {
    if (!self.contentTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的宝贵意见"];
        return;
    }
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的联系方式"];
        return;
    }
    NSDictionary *params = @{@"comment":self.contentTextView.text, @"mobile":self.mobileTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/feedBack" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
#pragma mark - ---- 私有方法 ----

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    
}

#pragma mark - --- getters 和 setters ----

@end
