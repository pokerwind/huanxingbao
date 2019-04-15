//
//  DZProblemOrderDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZProblemOrderDetailVC.h"
#import "DZOrderDetailVC.h"
#import "DZProblemOrderHistoryVC.h"
#import "DZRefundDeliveryVC.h"

#import "DZCommentPicCell.h"

#import "DZGetRefundInfoModel.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseCollectionViewCell.h"
#import "MSSBrowseLocalViewController.h"
#import "DZCustomerServiceModel.h"
#import "ChatViewController.h"

@interface DZProblemOrderDetailVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *opreationButton;
@property (weak, nonatomic) IBOutlet UIButton *xiaoxiButton;


@property (strong, nonatomic) DZGetRefundInfoModel *model;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (nonatomic, strong) DZCustomerServiceModel *customerService;
@end

@implementation DZProblemOrderDetailVC
static NSString *identifier = @"DZCommentPicCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"退货退款详情";
    self.xiaoxiButton.hidden = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCommentPicCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    [self getData];
    [self loadCustomerServiceInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCustomerServiceInfo {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getServiceInfo"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZCustomerServiceNetModel *model = [DZCustomerServiceNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.customerService = model.data;
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)contactCustomerService {
    if (!self.customerService) {
        return;
    }
    if (![DPMobileApplication sharedInstance].isLogined) {
        //处理未登录情况
        return;
    }
    
    if ([EMClient sharedClient].currentUsername) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
        chatController.real_name = self.customerService.chat_nickname;
        chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
        chatController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatController animated:YES];
    } else {
        //没有环信用户名，重试登录？
        DZUserModel *user = [DPMobileApplication sharedInstance].loginUser;
        [[EMClient sharedClient] loginWithUsername:user.emchat_username
                                          password:user.emchat_password
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
                                                chatController.real_name = self.customerService.chat_nickname;
                                                chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
                                                chatController.hidesBottomBarWhenPushed = YES;
                                                [self.navigationController pushViewController:chatController animated:YES];
                                            }else {
                                                [SVProgressHUD showInfoWithStatus:@"客服正忙，请稍后尝试"];
                                            }
                                        }];
    }
    
}


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

- (IBAction)revokeButtonClick {
    if ([self.opreationButton.titleLabel.text isEqualToString:@"联系官方客服"]) {
        //[self chatWithInfo:self.model.data.emchat];
        [self contactCustomerService];
    }else if ([self.opreationButton.titleLabel.text isEqualToString:@"撤销申请"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"撤销申请？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{@"order_sn":self.order_sn};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/goBackRefundOrder" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didRevokeOrder)]) {
                        [self.delegate didRevokeOrder];
                    }
                    [SVProgressHUD showSuccessWithStatus:model.info];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else if ([self.opreationButton.titleLabel.text isEqualToString:@"去退货"]){
        DZRefundDeliveryVC *vc = [DZRefundDeliveryVC new];
        vc.order_sn = self.order_sn;
        vc.delegate = self.delegate;
        vc.removeVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.opreationButton.titleLabel.text isEqualToString:@"删除订单"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"删除订单？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{@"order_sn":self.order_sn};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/delRefundOrder" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didRevokeOrder)]) {
                        [self.delegate didRevokeOrder];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)orderDetailButtonClick {
    DZOrderDetailVC *vc = [DZOrderDetailVC new];
    vc.isPreviewMode = YES;
    vc.order_sn = self.order_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)phoneButtonClick {
    if (self.model.data.shop_mobile.length) {
        NSString *phone = [NSString stringWithFormat:@"telprompt://%@", self.model.data.shop_mobile];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"商家预留电话无效"];
    }
}

- (IBAction)messageButtonClick {
    [self chatWithInfo:self.model.data.emchat];
}

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

- (void)getData{
    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_goods_id":self.order_goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getRefundInfo" parameters:params];
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
            
            if ([self.model.data.refund_state integerValue] == 3) {
                [self.opreationButton setTitle:@"联系官方客服" forState:UIControlStateNormal];
            }else if ([self.model.data.refund_state integerValue] == 1){
                [self.opreationButton setTitle:@"撤销申请" forState:UIControlStateNormal];
            }else if ([self.model.data.refund_state integerValue] == 2 && [self.model.data.refund_type isEqualToString:@"退货退款"]){
                [self.opreationButton setTitle:@"去退货" forState:UIControlStateNormal];
            }else if ([self.model.data.refund_state integerValue] == 4){
                [self.opreationButton setTitle:@"删除订单" forState:UIControlStateNormal];
            }else{
                self.opreationButton.hidden = YES;
            }
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

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

@end
