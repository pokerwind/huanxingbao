//
//  DZDZSellerProblemOrderDetailVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/9/28.（创建用户及时间）
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZSellerProblemOrderDetailVC.h"
#import "DZProblemOrderHistoryVC.h"
#import "DZOrderDetailVC.h"

#import "DZCommentPicCell.h"
#import "DZPayPassInputView.h"

#import "DZGetRefundInfoModel.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseCollectionViewCell.h"
#import "MSSBrowseLocalViewController.h"

@interface DZSellerProblemOrderDetailVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (strong, nonatomic) DZGetRefundInfoModel *model;
@property (strong, nonatomic) NSMutableArray *photoArray;

@property (nonatomic, strong) DZPayPassInputView *passInputView;
@property (nonatomic, strong) UIView *mask;

@end

@implementation DZSellerProblemOrderDetailVC
static NSString *identifier = @"DZCommentPicCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退货退款详情";
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCommentPicCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    if ([self.shop_state isEqualToString:@"1"]) {//待审核
        self.otherButton.hidden = YES;
        if ([self.refund_type isEqualToString:@"1"]) {//退款
            [self.acceptButton setTitle:@"同意退款" forState:UIControlStateNormal];
            [self.rejectButton setTitle:@"拒绝退款" forState:UIControlStateNormal];
        }else{//退货退款
            [self.acceptButton setTitle:@"同意退货退款" forState:UIControlStateNormal];
            [self.rejectButton setTitle:@"拒绝退货退款" forState:UIControlStateNormal];
        }
    }else if ([self.shop_state isEqualToString:@"2"]){//卖家已同意
        self.acceptButton.hidden = YES;
        self.rejectButton.hidden = YES;
        [self.otherButton setTitle:@"提醒退货" forState:UIControlStateNormal];
    }else if ([self.shop_state isEqualToString:@"3"] || [self.shop_state isEqualToString:@"4"]){//完成的订单
        self.acceptButton.hidden = YES;
        self.rejectButton.hidden = YES;
        [self.otherButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }else if ([self.shop_state isEqualToString:@"10"]){
        self.acceptButton.hidden = YES;
        self.rejectButton.hidden = YES;
        [self.otherButton setTitle:@"确认收货并退款" forState:UIControlStateNormal];
    }
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ---- 代理相关 ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 加载本地图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for (int i = 0;i < [self.photoArray count];i++) {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        // browseItem.bigImageLocalPath 建议传本地图片的路径来减少内存使用
        browseItem.bigImage = self.photoArray[i];
        // 大图赋值
        UIImageView *igv = [UIImageView new];
        igv.image = self.photoArray[i];
        browseItem.smallImageView = igv;
        // 小图
        [browseItemArray addObject:browseItem];
        
    }
    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.item];
    [bvc showBrowseViewController];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZCommentPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.picImageView.image = self.photoArray[indexPath.row];
    
    return cell;
}

#pragma mark - ---- 用户交互事件 ----
- (IBAction)copyNumberButtonClick {
    [SVProgressHUD showSuccessWithStatus:@"退款单号复制成功！"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.numberLabel.text;
}

- (IBAction)watchHistoryButtonClick {
    DZProblemOrderHistoryVC *vc = [DZProblemOrderHistoryVC new];
    vc.order_sn = self.order_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)orderDetailButtonClick {
    DZOrderDetailVC *vc = [DZOrderDetailVC new];
    vc.isPreviewMode = YES;
    vc.order_sn = self.order_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)acceptButtonClick {
    NSString *refundType;
    if ([self.refund_type isEqualToString:@"1"]) {//退款
        refundType = @"1";
        [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
        [[UIApplication sharedApplication].keyWindow addSubview:self.passInputView];
        [self.mask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.73, SCREEN_HEIGHT * 0.234));
        }];
        [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo([UIApplication sharedApplication].keyWindow);
            make.centerY.mas_equalTo([UIApplication sharedApplication].keyWindow).multipliedBy(0.9);
        }];
        [self.passInputView.passTextField becomeFirstResponder];
        self.passInputView.tag = 1;
    }else{//退货退款
        refundType = @"2";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"同意申请吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{@"order_sn":self.order_sn, @"refund_type":refundType};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)rejectButtonClick {
    NSString *refundType;
    if ([self.refund_type isEqualToString:@"1"]) {//退款
        refundType = @"3";
    }else{//退货退款
        refundType = @"4";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"拒绝申请吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{@"order_sn":self.order_sn, @"refund_type":refundType};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeStatus)]) {
                    [self.delegate didChangeStatus];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)otherButtonClick {
    if ([self.otherButton.titleLabel.text isEqualToString:@"提醒退货"]) {
        NSDictionary *params = @{@"refund_id":self.model.data.refund_id};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/reminderRefundOrder" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else if ([self.otherButton.titleLabel.text isEqualToString:@"删除订单"]){//删除订单
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{@"order_sn":self.order_sn};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/delRefundOrder" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteOrder:)]) {
                        [self.delegate didDeleteOrder:self.order_sn];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else if ([self.otherButton.titleLabel.text isEqualToString:@"确认收货并退款"]){
        [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
        [[UIApplication sharedApplication].keyWindow addSubview:self.passInputView];
        [self.mask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.73, SCREEN_HEIGHT * 0.234));
        }];
        [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo([UIApplication sharedApplication].keyWindow);
            make.centerY.mas_equalTo([UIApplication sharedApplication].keyWindow).multipliedBy(0.9);
        }];
        [self.passInputView.passTextField becomeFirstResponder];
        self.passInputView.tag = 2;
    }
}

- (IBAction)messageButtonClick {
    [self chatWithInfo:self.model.data.emchat];
}

- (void)inputViewCancelButtonClick{
    self.passInputView.passTextField.text = @"";
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
}

- (void)inputViewConfirmButtonClick{
    if (!self.passInputView.passTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付密码"];
        return;
    }
    
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
    
    if (self.passInputView.tag == 1) {
        NSDictionary *params = @{@"order_sn":self.order_sn, @"refund_type":@"1", @"password":self.passInputView.passTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeStatus)]) {
                    [self.delegate didChangeStatus];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else if (self.passInputView.tag == 2){
        NSDictionary *params = @{@"order_sn":self.order_sn, @"password":self.passInputView.passTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/finishOrderRfund" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteOrder:)]) {
                    [self.delegate didDeleteOrder:self.order_sn];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_goods_id":self.order_goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getRefundInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZGetRefundInfoModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            self.statusLabel.text = self.model.data.shop_state;
            self.shopNameLabel.text = self.model.data.shop_name;
            self.numberLabel.text = self.order_sn;
            self.dateLabel.text = self.model.data.add_time;
            self.operationLabel.text = self.model.data.refund_type;
            self.moneyLabel.text = self.model.data.amount;
            self.reasonLabel.text = self.model.data.reason;
            self.messageLabel.text = self.model.data.desc;
            
            [self fillImages];
        }else{
            [SVProgressHUD showErrorWithStatus:self.model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)fillImages{
    NSMutableArray *imgStrArray = [NSMutableArray array];
    for (NSString *img in self.model.data.images) {
        [imgStrArray addObject:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, img]];
    }
    
    __block NSInteger successCount = 0;
    __weak typeof(self) weakP = self;
    if (imgStrArray.count) {
        [SVProgressHUD showWithStatus:@"图片加载中"];
    }
    for (int i = 0; i < imgStrArray.count; i++) {
        NSURL* url = [NSURL URLWithString:imgStrArray[i]];
        // 得到session对象
        NSURLSession* session = [NSURLSession sharedSession];
        // 创建任务
        NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"下载失败:%@", error.domain]];
                return;
            }else{
                NSData *data = [NSData dataWithContentsOfURL:location];
                UIImage *img = [UIImage imageWithData:data];
                if (img) {
                    [self.photoArray addObject:img];
                    if (++successCount == imgStrArray.count) {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showSuccessWithStatus:@"图片加载完成"];
                        [weakP.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    }
                }else{                
                    if (imgStrArray.count && (i == imgStrArray.count - 1)){
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:@"图片下载失败"];
                    }
                }
            }
        }];
        // 开始任务
        [downloadTask resume];
    }
}

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    //    Maronsy
}

#pragma mark - --- getters 和 setters ----
- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (DZPayPassInputView *)passInputView{
    if (!_passInputView) {
        _passInputView = [DZPayPassInputView viewFormNib];
        _passInputView.backgroundColor = [UIColor whiteColor];
        _passInputView.layer.cornerRadius = 4;
        [_passInputView.cancelButton addTarget:self action:@selector(inputViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_passInputView.confirmButton addTarget:self action:@selector(inputViewConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passInputView;
}

- (UIView *)mask{
    if (!_mask) {
        _mask = [UIView new];
        _mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }
    return _mask;
}

@end
