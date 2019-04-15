//
//  DZOpenSTShopVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/22.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOpenSTShopVC.h"
#import "DZProvinceSelectionVC.h"
#import "DZCitySelectionVC.h"
#import "DZUploadCertificationVC.h"

#import "DZPhotoExampleView.h"

#import "DZGetCategoryListModel.h"

@interface DZOpenSTShopVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, DZCitySelectionVCDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *selectCityButton;
@property (weak, nonatomic) IBOutlet UITextField *marketTextField;
@property (weak, nonatomic) IBOutlet UITextField *floorTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *handCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *expressCountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *replaceGuaranteeSwitch;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIImagePickerController *avatarPicker;//店铺头像
@property (strong, nonatomic) UIImagePickerController *photoPicker;

@property (strong, nonatomic) NSArray *catagoryArray;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *categoryId;

@property (nonatomic) BOOL selectedImage;//是否已上传头像

@end

@implementation DZOpenSTShopVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费开店";
    
    self.phoneTextField.text = [DPMobileApplication sharedInstance].loginUser.mobile;
    
    [self getCategoryData];
    
    if ([DPMobileApplication sharedInstance].loginUser.is_shop) {
        [self getEditShopInfo];
    }
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)avatarButtonAction:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", @"拍照", nil];
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

- (IBAction)exampleButtonAction:(UIButton *)sender {
    DZPhotoExampleView *view = [DZPhotoExampleView viewFormNib];
    view.shopExampleView.hidden = NO;
    view.photo1ImageView.hidden = YES;
//    view.photo2ImageView.hidden = YES;
    view.photo3ImageView.hidden = YES;
    view.label1.hidden = YES;
//    view.label2.hidden = YES;
    view.label3.hidden = YES;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].delegate.window);
    }];
}

- (IBAction)uploadButtonAction:(UIButton *)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", @"拍照", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1001;
    [self.actionSheet showInView:self.view];
}

- (IBAction)selectCityButtonAction:(id)sender {
    DZProvinceSelectionVC *vc = [DZProvinceSelectionVC new];
    vc.districtDelegateVC = self;
    vc.isUtilCity = YES;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)selectCategoryButtonAction:(UIButton *)sender {
    if (!self.catagoryArray.count) {
        [SVProgressHUD showErrorWithStatus:@"亲～获取类别失败"];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (DZCategoryListModel *model in self.catagoryArray) {
        [array addObject:model.cat_name_mobile];
    }
    [ActionSheetStringPicker showPickerWithTitle:@"经营类别" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *result = array[selectedIndex];
        [self.categoryButton setTitle:result forState:UIControlStateNormal];
        DZCategoryListModel *model = self.catagoryArray[selectedIndex];
        self.categoryId = model.cat_id;
    } cancelBlock:nil origin:self.view];
}

- (IBAction)submitButtonAction {
    if (!self.selectedImage) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像~"];
        return;
    }
    if (!self.photoImageView.image) {
        [SVProgressHUD showErrorWithStatus:@"请上传实拍图~"];
        return;
    }
    if (!self.shopNameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺名称~"];
        return;
    }
    if (!self.contactTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺联系人~"];
        return;
    }
    if (!self.phoneTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话~"];
        return;
    }
    if (!self.province) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市~"];
        return;
    }
    if (!self.marketTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入您所在的批发市场~"];
        return;
    }
    if (!self.floorTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入您所在的楼层~"];
        return;
    }
    if (!self.numberTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的档口编号~"];
        return;
    }
    if (!self.categoryId) {
        [SVProgressHUD showErrorWithStatus:@"请选择主营类别~"];
        return;
    }
    if (!self.handCountTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入拿货起批数量~"];
        return;
    }
    if (!self.expressCountTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入打包起批数量~"];
        return;
    }
    
    [SVProgressHUD show];
    NSString *allow_return = self.replaceGuaranteeSwitch.on ? @"1":@"0";
    NSDictionary *params = @{@"shop_type":@"1", @"shop_name":self.shopNameTextField.text, @"contacts_name":self.contactTextField.text, @"user_mobile":self.phoneTextField.text, @"province":self.province, @"city":self.city, @"market_name":self.marketTextField.text, @"floor_number":self.floorTextField.text, @"room_number":self.numberTextField.text, @"category_id":self.categoryId, @"basic_amount":self.expressCountTextField.text, @"retail_amount":self.handCountTextField.text, @"allow_return":allow_return};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@index.php/Api/ShopEditApi/addShopStep1",DEFAULT_HTTP_HOST] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(self.avatarImageView.image,1);
        NSData *photoData = UIImageJPEGRepresentation(self.photoImageView.image,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        NSString *photoName = [NSString stringWithFormat:@"%@2.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"shop_logo"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:photoData
                                    name:@"shop_real_pic"
                                fileName:photoName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%@", uploadProgress);
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"努力上传中..."];
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        if ([responseObject[@"status"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            [DPMobileApplication sharedInstance].loginUser.shop_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"shop_id"]];
            [[DPMobileApplication sharedInstance] updateUserInfo];
            
            DZUploadCertificationVC *vc = [DZUploadCertificationVC new];
            vc.shopId = responseObject[@"data"][@"shop_id"];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    [task resume];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZCitySelectionVCDelegate ----
- (void)didSelectionProvince:(NSString *)province city:(NSString *)city{
    self.province = province;
    self.city = city;
    [self.selectCityButton setTitle:[NSString stringWithFormat:@"%@%@", province, city] forState:UIControlStateNormal];
}

#pragma mark - ---- 私有方法 ----
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                
                return;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 1:
                
                return;
            case 2:
                
                return;
        }
    }
    if (actionSheet.tag == 1000) {
        // 跳转到相机或相册页面
        self.avatarPicker = [[UIImagePickerController alloc] init];
        self.avatarPicker.delegate = self;
        self.avatarPicker.allowsEditing = YES;
        self.avatarPicker.sourceType = sourceType;
        [self presentViewController:self.avatarPicker animated:YES completion:nil];
    }else{
        self.photoPicker = [[UIImagePickerController alloc] init];
        self.photoPicker.delegate = self;
        self.photoPicker.sourceType = sourceType;
        [self presentViewController:self.photoPicker animated:YES completion:nil];
    }
}

- (void)getEditShopInfo{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopEditApi/getEditShopInfo"];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        NSDictionary *resultDict = request.responseJSONObject;
        if (model.isSuccess) {
            [SVProgressHUD dismiss];
            self.shopNameTextField.text = resultDict[@"data"][@"shop_name"];
            self.contactTextField.text = resultDict[@"data"][@"contacts_name"];
            self.handCountTextField.text = resultDict[@"data"][@"retail_amount"];
            self.expressCountTextField.text = resultDict[@"data"][@"basic_amount"];
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (picker == self.avatarPicker) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];// ;
        self.avatarImageView.image = image;
        self.selectedImage = YES;
    }else{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.photoImageView.image = image;
    }
}

- (void)getCategoryData{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsCategoryApi/getCategoryList" parameters:nil];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetCategoryListModel *model = [DZGetCategoryListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.catagoryArray = model.data;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (NSArray *)catagoryArray{
    if (!_catagoryArray) {
        _catagoryArray = [NSArray array];
    }
    return _catagoryArray;
}

@end
