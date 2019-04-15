//
//  DZPayPassSettingVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/11/9.（创建用户及时间）
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZPayPassSettingVC.h"

#import <JKCountDownButton.h>

#import "GetVerifyAPI.h"

@interface DZPayPassSettingVC ()

@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation DZPayPassSettingVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置支付密码";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isPresent) {
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
    
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
- (IBAction)countbuttonClick:(JKCountDownButton *)sender {
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    GetVerifyAPI *getApi = [[GetVerifyAPI alloc] initWithPhone:self.mobileTextField.text type:6];
    [SVProgressHUD showWithStatus:@"发送中"];
    [getApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *    model = request.responseJSONObject;
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"已发送，请注意查收"];
            sender.enabled = NO;
            sender.backgroundColor = HEXCOLOR(0xcdcdcd);
            //button type要 设置成custom 否则会闪动
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                countDownButton.backgroundColor = HEXCOLOR(0xff7722);
                return @"获取验证码";
                
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (IBAction)submitButtonClick {
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (!self.codeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (!self.passTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入支付密码"];
        return;
    }
    if (!self.confirmTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入支付密码"];
        return;
    }
    
    NSDictionary *params = @{@"mobile":self.mobileTextField.text, @"sms_code":self.codeTextField.text, @"password":self.passTextField.text, @"confirm_password":self.confirmTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/payPassword" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [DPMobileApplication sharedInstance].loginUser.pay_password = @"1";
            [[DPMobileApplication sharedInstance] updateUserInfo];
            if (self.isPresent) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ---- 私有方法 ----
- (void)getData{
    
}

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    //    Maronsy
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        _leftItem.tintColor = HEXCOLOR(0xff7722);
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _leftItem;
}

@end
