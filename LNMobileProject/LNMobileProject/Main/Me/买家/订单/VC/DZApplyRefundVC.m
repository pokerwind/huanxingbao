//
//  DZApplyRefundVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZApplyRefundVC.h"

#import "DZCommentPicCell.h"
#import "DZReasonView.h"
#import "UITextView+ZWPlaceHolder.h"

@interface DZApplyRefundVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) NSMutableArray *photoArray;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZReasonView *reasonView;
@property (strong, nonatomic) NSArray *reasonArray;

@property (nonatomic) NSInteger refund_type;
@property (strong, nonatomic) NSString *reason;

@end

@implementation DZApplyRefundVC
static NSString *identifier = @"DZCommentPicCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    
    self.refund_type = 1;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.reasonTextView.placeholder = @"说明理由：详细的内容能让商家更清楚你的情况";
    self.reasonTextView.zw_placeHolderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCommentPicCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    if (!self.canReturnGood) {
        self.goodButton.hidden = YES;
    }
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)moneyButtonAction {
    self.moneyButton.backgroundColor = HEXCOLOR(0xff7722);
    self.goodButton.backgroundColor = HEXCOLOR(0xb7b7b7);
    self.refund_type = 1;
}
- (IBAction)goodButtonActionj {
    self.moneyButton.backgroundColor = HEXCOLOR(0xb7b7b7);
    self.goodButton.backgroundColor = HEXCOLOR(0xff7722);
    self.refund_type = 2;
}
- (IBAction)reasonButtonAction {
    if (!self.reasonArray.count) {
        [SVProgressHUD showErrorWithStatus:@"获取退货原因失败"];
        return;
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.reasonView];
    [UIView animateWithDuration:.3 animations:^{
        self.reasonView.frame = CGRectMake(self.reasonView.x, SCREEN_HEIGHT - self.reasonView.height, self.reasonView.width, self.reasonView.height);
    }];
}

- (void)reasonViewCloseButtonAction{
    [UIView animateWithDuration:.3 animations:^{
        self.reasonView.frame = CGRectMake(self.reasonView.x, SCREEN_HEIGHT, self.reasonView.width, self.reasonView.height);
    } completion:^(BOOL finished) {
        [self.reasonView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (IBAction)submitButtonAction {
    if (!self.reason) {
        [SVProgressHUD showErrorWithStatus:@"请选择退款原因"];
        return;
    }
    if (!self.reasonTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细描述"];
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确认要申请退货退款吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{@"order_sn":self.order_sn, @"goods_id":self.goods_id, @"order_goods_id":self.order_goods_id, @"description":self.reasonTextView.text, @"order_sn":self.order_sn,
            @"refund_type":@(self.refund_type),
            @"reason":self.reason,
            @"token":[DPMobileApplication sharedInstance].loginUser.token
                                 };
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //接收类型不一致请替换一致text/html或别的
        //接收类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        
        NSURLSessionDataTask *task = [manager POST:[DEFAULT_HTTP_HOST stringByAppendingString:@"Api/UserCenterApi/setOrderRefund"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            for (int i = 0; i <[self.photoArray count]; i++) {//循环...
                UIImage *loc_image = [self.photoArray objectAtIndex:i];
                NSData *dataObj = UIImageJPEGRepresentation(loc_image, 1);
                [formData appendPartWithFileData:dataObj name:[NSString stringWithFormat:@"images[%d]", i] fileName:[NSString stringWithFormat:@"%dfile.jpg",i+1] mimeType:@"image/jpeg"];
            }
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印上传进度
            NSLog(@"%@", uploadProgress);
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"努力上传中..."];
        } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
            //上传成功
            NSDictionary *resultDict = responseObject;
            if ([responseObject[@"status"] boolValue]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSubmitRefund)]) {
                    [self.delegate didSubmitRefund];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            //上传失败
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
        
        [task resume];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)deleteButtonClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.photoArray removeObjectAtIndex:btn.tag];
        [self.collectionView reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reasonViewCloseButtonAction];
    self.reason = self.reasonArray[indexPath.row];
    [self.reasonButton setTitle:self.reasonArray[indexPath.row] forState:UIControlStateNormal];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = self.reasonArray[indexPath.row];
    cell.textLabel.textColor = HEXCOLOR(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - ---- UICollectionViewDelegate ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.photoArray.count) {
        [self callActionSheetFunc];
    }
}
#pragma mark - ---- UICollectionViewDataSource ----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZCommentPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item < self.photoArray.count) {
        UIImage *img = self.photoArray[indexPath.item];
        cell.picImageView.image = img;
        cell.deleteButton.hidden = NO;
        cell.deleteButton.tag = indexPath.item;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.picImageView.image = [UIImage imageNamed:@"btn_addgood"];
        cell.deleteButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    
                    return;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                [SVProgressHUD showInfoWithStatus:@"请您设置允许APP访问您的相机->设置->隐私->相机"];
            }else{
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{
                    
                }];
            }
        }else{
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];// [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photoArray addObject:image];
    [self.collectionView reloadData];
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/refundReason" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.reasonArray = request.responseJSONObject[@"data"];
            
            NSDictionary *params2 =@{@"order_sn":self.order_sn, @"goods_id":self.goods_id};
            LNetWorkAPI *api2 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getRefundPrice" parameters:params2];
            [api2 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                NSString *status = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [SVProgressHUD dismiss];
                    self.moneyTextField.text = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"data"][@"all_amount"]];
                }else{
                    [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSArray *)reasonArray{
    if (!_reasonArray) {
        _reasonArray = [NSArray array];
    }
    return _reasonArray;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }
    return _maskView;
}

- (DZReasonView *)reasonView{
    if (!_reasonView) {
        _reasonView = [DZReasonView viewFormNib];
        _reasonView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 290);
        [_reasonView.closeButton addTarget:self action:@selector(reasonViewCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _reasonView.tableView.delegate = self;
        _reasonView.tableView.dataSource = self;
    }
    return _reasonView;
}

@end
