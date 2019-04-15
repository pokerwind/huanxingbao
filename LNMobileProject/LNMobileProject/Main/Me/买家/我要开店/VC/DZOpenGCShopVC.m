//
//  DZOpenGCShopVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/22.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOpenGCShopVC.h"
#import "DZProvinceSelectionVC.h"
#import "DZCitySelectionVC.h"
#import "DZUploadCertificationVC.h"
#import "DZAddressSelectionAVC.h"

#import "DZPhotoExampleView.h"

#import "DZGetCategoryListModel.h"
#import "DZDistrictSelectionVC.h"

@interface DZOpenGCShopVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, DZDistrictSelectionVCDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(nonatomic,assign) BOOL isavatar;
@property(nonatomic,assign) BOOL isphoto;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *selectCityButton;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *dituxuanzedizhiButton;
@property (weak, nonatomic) IBOutlet UILabel *dianpudizhiLabel;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIImagePickerController *avatarPicker;//店铺头像
@property (strong, nonatomic) UIImagePickerController *photoPicker;

@property (strong, nonatomic) NSArray *catagoryArray;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property(nonatomic,strong) NSString *district;
@property (strong, nonatomic) NSString *categoryId;
@property(nonatomic,strong) NSDictionary *dictiaoary;
@property (nonatomic) BOOL selectedImage;//是否已上传头像
@property (strong, nonatomic) NSString *provinceID;
@property (strong, nonatomic) NSString *cityID;
@property(nonatomic,strong) NSString *districtID;

@property(nonatomic,strong) NSString *shop_id;

@property(nonatomic,strong) NSString *lat; //纬度
@property(nonatomic,strong) NSString *lng; //经度

@end

@implementation DZOpenGCShopVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"店铺管理";
    self.isavatar = NO;
    self.isphoto = NO;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.phoneTextField.text = [DPMobileApplication sharedInstance].loginUser.mobile;
    [self.dituxuanzedizhiButton addTarget:self action:@selector(dituxuanzeAction) forControlEvents:UIControlEventTouchUpInside];
    [self getCategoryData];
    
    if ([DPMobileApplication sharedInstance].loginUser.is_shop) {
        [self getEditShopInfo];
    }
}
- (void)dituxuanzeAction {
    NSLog(@"地图选择");
    DZAddressSelectionAVC *address = [DZAddressSelectionAVC new];
    address.block = ^(NSString * _Nonnull lat, NSString * _Nonnull lng, NSString * _Nonnull adds) {
        self.lat = lat;
        self.lng = lng;
        self.dianpudizhiLabel.text = [NSString stringWithFormat:@"经度：%@ 纬度:%@",self.lng,self.lat];
    };
    [self.navigationController pushViewController:address animated:YES];
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
    vc.isUtilCity = NO;
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
        DZCategoryListModel *model = self.catagoryArray[selectedIndex];
        self.categoryId = model.cat_id;
    } cancelBlock:nil origin:self.view];
}

- (IBAction)submitButtonAction {
    if (!self.isavatar) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像~"];
        return;
    }
    if (!self.isphoto) {
        [SVProgressHUD showErrorWithStatus:@"请上传店铺招牌图~"];
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
    if (!self.addressTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入工厂所在详细地址~"];
        return;
    }
    if (!self.lat.length) {
        [SVProgressHUD showErrorWithStatus:@"请选择位置"];
        return;
    }
//    if (!self.categoryId) {
//        [SVProgressHUD showErrorWithStatus:@"请选择主营类别~"];
//        return;
//    }
    
    
    [SVProgressHUD show];
    NSDictionary *params = @{
                             @"shop_name":self.shopNameTextField.text, @"province":self.province,
        @"city":self.city,
        @"country":self.district,
                             @"province_id":self.provinceID,
                             @"city_id":self.cityID,
                             @"country_id":self.districtID,
        @"address":self.addressTextField.text, @"contacts_name":self.contactTextField.text,
                             @"user_mobile":self.phoneTextField.text,
                             @"lat":self.lat,
                             @"lng":self.lng,
                             @"token":[DPMobileApplication sharedInstance].loginUser.token
                             };
//    [dict setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:FULL_URL(@"/index.php//Api/ShopEditApi/saveEditShop") parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
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
        NSDictionary *resultDict = responseObject;
        if ([responseObject[@"status"] boolValue]) {
            if ([responseObject[@"status"] integerValue] == 1) {
//                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
//                [DPMobileApplication sharedInstance].loginUser.shop_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"shop_id"]];
//                [[DPMobileApplication sharedInstance] updateUserInfo];
//
//                DZUploadCertificationVC *vc = [DZUploadCertificationVC new];
//                vc.shopId = responseObject[@"data"][@"shop_id"];
//                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    [task resume];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZCitySelectionVCDelegate ----
- (void)didSelectionProvince:(NSString *)province city:(NSString *)city district:(NSString *)district AndIDProvinceID:(NSString *)provinceid cityID:(NSString *)cityID districtID:(NSString *)districtID{
    self.province = province;
    self.city = city;
    self.district = district;
    self.provinceID = provinceid;
    self.cityID = cityID;
    self.districtID = districtID;
    [self.selectCityButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", province, city,district] forState:UIControlStateNormal];
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
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.avatarImageView.image = image;
        self.selectedImage = YES;
    }else{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.photoImageView.image = image;
    }
}
#pragma mark-获取店铺类型
- (void)getCategoryData{
    if (self.guanlidianpu.length != 0) {
        NSDictionary *params = @{@"token":[DPMobileApplication sharedInstance].loginUser.token};        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopEditApi/getEditShopInfo" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            DZGetCategoryListModel *model = [DZGetCategoryListModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                self.dictiaoary = request.rawJSONObject;
                self.shopNameTextField.text = self.dictiaoary[@"data"][@"shop_name"];
                self.contactTextField.text = self.dictiaoary[@"data"][@"contacts_name"];
                self.phoneTextField.text = self.dictiaoary[@"data"][@"user_mobile"];
//                if () {
//                    <#statements#>
//                }
                NSString *shop_logo = self.dictiaoary[@"data"][@"shop_logo"];
                NSString *shop_real_pic = self.dictiaoary[@"data"][@"shop_real_pic"];
                if (shop_logo.length != 0) {
                    self.isavatar = YES;
                }
                if (shop_real_pic.length != 0) {
                    self.isphoto = YES;
                }
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:shop_logo] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
                
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:shop_real_pic] placeholderImage:nil];
                
                self.province = self.dictiaoary[@"data"][@"province"];
                self.city = self.dictiaoary[@"data"][@"city"];
                self.district = self.dictiaoary[@"data"][@"country"];
                if (self.province.length != 0) {
                    [self.selectCityButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", self.province, self.city,self.district] forState:UIControlStateNormal];
                    self.provinceID = self.dictiaoary[@"data"][@"province_id"];
                    self.cityID = self.dictiaoary[@"data"][@"city_id"];
                    self.districtID = self.dictiaoary[@"data"][@"country_id"];
                }
                self.addressTextField.text = self.dictiaoary[@"data"][@"address"];
                self.shop_id = self.dictiaoary[@"data"][@"shop_id"];
//
                self.contactTextField.text = self.dictiaoary[@"data"][@"contacts_name"];
                self.lat = self.dictiaoary[@"data"][@"lat"];
                self.lng = self.dictiaoary[@"data"][@"lng"];
                self.dianpudizhiLabel.text = [NSString stringWithFormat:@"经度：%@ 纬度:%@",self.lng,self.lat];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
//    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsCategoryApi/getCategoryList" parameters:nil];
//    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//        DZGetCategoryListModel *model = [DZGetCategoryListModel objectWithKeyValues:request.responseJSONObject];
//        if (model.isSuccess) {
//            self.catagoryArray = model.data;
//        }else{
//            [SVProgressHUD showErrorWithStatus:model.info];
//        }
//    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:error.domain];
//    }];
}

#pragma mark - --- getters 和 setters ----
- (NSArray *)catagoryArray{
    if (!_catagoryArray) {
        _catagoryArray = [NSArray array];
    }
    return _catagoryArray;
}

@end
