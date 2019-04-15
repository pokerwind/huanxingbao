//
//  DZOrderCommentVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOrderCommentVC.h"

#import "TggStarEvaluationView.h"
#import "DZCommentPicCell.h"
#import "UITextView+ZWPlaceHolder.h"

#import "DZShopDetailModel.h"

@interface DZOrderCommentVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressTitleLabel;
@property (strong, nonatomic) TggStarEvaluationView *qualityStarView;
@property (strong, nonatomic) TggStarEvaluationView *serviceStarView;
@property (strong, nonatomic) TggStarEvaluationView *expressStarView;
@property (strong, nonatomic) UILabel *qualityCountLabel;
@property (strong, nonatomic) UILabel *serviceCountLabel;
@property (strong, nonatomic) UILabel *expressCountLabel;
@property (nonatomic) NSInteger qualityCount;
@property (nonatomic) NSInteger serviceCount;
@property (nonatomic) NSInteger expressCount;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) NSMutableArray *photoArray;

@end

@implementation DZOrderCommentVC
static NSString *identifier = @"DZCommentPicCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    
    [self.scrollView addSubview:self.qualityStarView];
    [self.scrollView addSubview:self.serviceStarView];
    [self.scrollView addSubview:self.expressStarView];
    [self.scrollView addSubview:self.qualityCountLabel];
    [self.scrollView addSubview:self.serviceCountLabel];
    [self.scrollView addSubview:self.expressCountLabel];
    self.qualityCount = 5;
    self.serviceCount = 5;
    self.expressCount = 5;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.contentTextView.placeholder = @"描述在10-500个字写下交易体会，可以帮助其他进货小伙伴参考";
    self.contentTextView.zw_placeHolderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCommentPicCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    [self setSubViewsLayout];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void)setSubViewsLayout{
    [self.qualityStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(140);
        make.centerY.mas_equalTo(self.qualityTitleLabel);
        make.left.mas_equalTo(self.qualityTitleLabel.mas_right).with.offset(12);
    }];
    [self.serviceStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.qualityStarView);
        make.centerY.mas_equalTo(self.serviceTitleLabel);
        make.left.mas_equalTo(self.serviceTitleLabel.mas_right).with.offset(12);
    }];
    [self.expressStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.qualityStarView);
        make.centerY.mas_equalTo(self.expressTitleLabel);
        make.left.mas_equalTo(self.expressTitleLabel.mas_right).with.offset(12);
    }];
    [self.qualityCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qualityStarView.mas_right);
        make.centerY.mas_equalTo(self.qualityStarView);
    }];
    [self.serviceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serviceStarView.mas_right);
        make.centerY.mas_equalTo(self.serviceStarView);
    }];
    [self.expressCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expressStarView.mas_right);
        make.centerY.mas_equalTo(self.expressStarView);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    if (self.qualityCount == 0 || self.serviceCount == 0 || self.expressCount == 0) {
        [SVProgressHUD showInfoWithStatus:@"打分最低为1颗星"];
        return;
    }
    if (!self.contentTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入评价内容"];
        return;
    }

    NSDictionary *params = @{@"order_sn":self.order_sn,
                             @"token":[DPMobileApplication sharedInstance].loginUser.token,
                             @"content":self.contentTextView.text.length?self.contentTextView.text:@"", @"rank":@(self.qualityCount), @"express_rank":@(self.expressCount), @"service_rank":@(self.serviceCount)
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[DEFAULT_HTTP_HOST stringByAppendingString:@"Api/UserCenterApi/setOrderComment"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        for (int i = 0; i <[self.photoArray count]; i++) {//循环...
            UIImage *loc_image = [self.photoArray objectAtIndex:i];
            NSData *dataObj = UIImageJPEGRepresentation(loc_image, 1);
            [formData appendPartWithFileData:dataObj name:[NSString stringWithFormat:@"photo[%d]", i] fileName:[NSString stringWithFormat:@"%dfile.jpg",i+1] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印上传进度
        NSLog(@"%@", uploadProgress);
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"努力上传中..."];
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSDictionary *resultDict = responseObject;
        if ([responseObject[@"status"] boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
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
}

- (void)deleteButtonClick:(UIButton *)btn{
    [self.photoArray removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
}

#pragma mark - ---- 代理相关 ----
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
- (void)getData{
    NSDictionary *params = @{@"shop_id":self.shopId};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/shop_home" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopDetailNetModel *model = [DZShopDetailNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.data.shop_logo]]];
            self.nickLabel.text = model.data.shop_name;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

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

#pragma mark - --- getters 和 setters ----
- (TggStarEvaluationView *)qualityStarView{
    if (!_qualityStarView) {
        _qualityStarView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            if (count > 5) {
                count = 5;
            }
            self.qualityCountLabel.text = [NSString stringWithFormat:@"%ld星", count];
            self.qualityCount = count;
        }];
        _qualityStarView.starCount = 5;
    }
    return _qualityStarView;
}

- (TggStarEvaluationView *)serviceStarView{
    if (!_serviceStarView) {
        _serviceStarView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            if (count > 5) {
                count = 5;
            }
            self.serviceCountLabel.text = [NSString stringWithFormat:@"%ld星", count];
            self.serviceCount = count;
        }];
        _serviceStarView.starCount = 5;
    }
    return _serviceStarView;

}

- (TggStarEvaluationView *)expressStarView{
    if (!_expressStarView) {
        _expressStarView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            if (count > 5) {
                count = 5;
            }
            self.expressCountLabel.text = [NSString stringWithFormat:@"%ld星", count];
            self.expressCount = count;
        }];
        _expressStarView.starCount = 5;
    }
    return _expressStarView;

}

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (UILabel *)qualityCountLabel{
    if (!_qualityCountLabel) {
        _qualityCountLabel = [UILabel new];
        _qualityCountLabel.font = [UIFont systemFontOfSize:13];
        _qualityCountLabel.textColor = HEXCOLOR(0x333333);
        _qualityCountLabel.text = @"5星";
    }
    return _qualityCountLabel;
}

- (UILabel *)serviceCountLabel{
    if (!_serviceCountLabel) {
        _serviceCountLabel = [UILabel new];
        _serviceCountLabel.font = [UIFont systemFontOfSize:13];
        _serviceCountLabel.textColor = HEXCOLOR(0x333333);
        _serviceCountLabel.text = @"5星";
    }
    return _serviceCountLabel;
}

- (UILabel *)expressCountLabel{
    if (!_expressCountLabel) {
        _expressCountLabel = [UILabel new];
        _expressCountLabel.font = [UIFont systemFontOfSize:13];
        _expressCountLabel.textColor = HEXCOLOR(0x333333);
        _expressCountLabel.text = @"5星";
    }
    return _expressCountLabel;
}

@end
