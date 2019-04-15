//
//  DZGCInfoVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/10/19.
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZGCInfoVC.h"
#import "DZShopDetailVC.h"
#import "DZProvinceSelectionVC.h"
#import "DZFreightTemplateVC.h"
#import "DZLevelIntroVC.h"

#import "UITextView+ZWPlaceHolder.h"

#import "DZGetEditShopInfoModel.h"
#import "DZGetCategoryListModel.h"

@interface DZGCInfoVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage1;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage2;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage3;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage4;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage5;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *handCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *expressCountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *supportSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *categoryId;

@property (nonatomic, strong) DZGetEditShopInfoModel *model;
@property (strong, nonatomic) NSArray *catagoryArray;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic) BOOL isPhotoModified;//是否修改了实拍图

@end

@implementation DZGCInfoVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"店铺信息";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.infoTextView.placeholder = @"请输入店铺公告（140字以内）";
    [self.coverImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageViewTap)]];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    
    [self getData];
    [self getCategoryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView
#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];// [info objectForKey:UIImagePickerControllerOriginalImage];
    self.coverImageView.image = image;
    self.isPhotoModified = YES;
}

- (void)didSelectionProvince:(NSString *)province city:(NSString *)city{
    self.province = province;
    self.city = city;
    [self.provinceButton setTitle:[NSString stringWithFormat:@"%@%@", province, city] forState:UIControlStateNormal];
}

#pragma mark - ---- 用户交互事件 ----
- (void)rightItemClick{
    DZShopDetailVC *vc = [DZShopDetailVC new];
    vc.shopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)coverImageViewTap{
    [self callActionSheetFunc];
}

- (IBAction)provinceButtonClick {
    DZProvinceSelectionVC *vc = [DZProvinceSelectionVC new];
    vc.districtDelegateVC = self;
    vc.isUtilCity = YES;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)categoryButtonClick {
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

- (IBAction)templetButtonClick {
    DZFreightTemplateVC *vc = [DZFreightTemplateVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)submitButtonClick {
    if (!self.contactTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入店铺联系人"];
        return;
    }
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系电话"];
        return;
    }
    if (!self.addressTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    if (!self.handCountTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入拿货起批量"];
        return;
    }
    if (!self.expressCountTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入打包起批量"];
        return;
    }
    NSDictionary *params = @{@"contacts_name":self.contactTextField.text, @"user_mobile":self.mobileTextField.text, @"province":self.province, @"city":self.city, @"address":self.addressTextView.text, @"category_id":self.categoryId, @"retail_amount":self.handCountTextField.text, @"basic_amount":self.expressCountTextField.text, @"allow_return":self.supportSwitch.on?@"1":@"0", @"description":[NSString stringWithFormat:@"%@", self.infoTextView.text], @"company_website":self.urlTextField.text};
    if (self.isPhotoModified) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //接收类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@index.php/Api/ShopEditApi/saveEditShop",DEFAULT_HTTP_HOST] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            NSData *imageData =UIImageJPEGRepresentation(self.coverImageView.image,1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"shop_real_pic"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%@", uploadProgress);
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"努力上传中..."];
        } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
            //上传成功
            NSDictionary *resultDict = responseObject;
            if ([responseObject[@"status"] boolValue]) {
                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
        [task resume];
    }else{
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopEditApi/saveEditShop" parameters:params];
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
}

- (IBAction)levelIntroButtonClick {
    DZLevelIntroVC *vc = [DZLevelIntroVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params =nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopEditApi/getEditShopInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        self.model = [DZGetEditShopInfoModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            [SVProgressHUD dismiss];
            [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.model.data.shop_real_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            self.nameLabel.text = self.model.data.shop_name;
            self.shopTypeLabel.text = self.model.data.shop_type_name;
            NSString *type = self.model.data.shop_grade.type;
            if ([type isEqualToString:@"G1"]) {
                self.rankImage1.image = [UIImage imageNamed:@"icon_heart"];
                self.rankImage2.image = [UIImage imageNamed:@"icon_heart"];
                self.rankImage3.image = [UIImage imageNamed:@"icon_heart"];
                self.rankImage4.image = [UIImage imageNamed:@"icon_heart"];
                self.rankImage5.image = [UIImage imageNamed:@"icon_heart"];
            } else if ([type isEqualToString:@"G2"]) {
                self.rankImage1.image = [UIImage imageNamed:@"icon_dimon"];
                self.rankImage2.image = [UIImage imageNamed:@"icon_dimon"];
                self.rankImage3.image = [UIImage imageNamed:@"icon_dimon"];
                self.rankImage4.image = [UIImage imageNamed:@"icon_dimon"];
                self.rankImage5.image = [UIImage imageNamed:@"icon_dimon"];
            } if ([type isEqualToString:@"G3"]) {
                self.rankImage1.image = [UIImage imageNamed:@"icon_silvercrown"];
                self.rankImage2.image = [UIImage imageNamed:@"icon_silvercrown"];
                self.rankImage3.image = [UIImage imageNamed:@"icon_silvercrown"];
                self.rankImage4.image = [UIImage imageNamed:@"icon_silvercrown"];
                self.rankImage5.image = [UIImage imageNamed:@"icon_silvercrown"];
            } if ([type isEqualToString:@"G4"]) {
                self.rankImage1.image = [UIImage imageNamed:@"icon_goldcrown"];
                self.rankImage2.image = [UIImage imageNamed:@"icon_goldcrown"];
                self.rankImage3.image = [UIImage imageNamed:@"icon_goldcrown"];
                self.rankImage4.image = [UIImage imageNamed:@"icon_goldcrown"];
                self.rankImage5.image = [UIImage imageNamed:@"icon_goldcrown"];
            }
            switch ([self.model.data.shop_grade.num integerValue]) {
                case 1:{
                    self.rankImage5.hidden = YES;
                    self.rankImage4.hidden = YES;
                    self.rankImage3.hidden = YES;
                    self.rankImage2.hidden = YES;
                    break;
                }
                case 2:{
                    self.rankImage5.hidden = YES;
                    self.rankImage4.hidden = YES;
                    self.rankImage3.hidden = YES;
                    break;
                }
                case 3:{
                    self.rankImage5.hidden = YES;
                    self.rankImage4.hidden = YES;
                    break;
                }
                case 4:{
                    self.rankImage5.hidden = YES;
                    break;
                }
                default:
                    break;
            }
            self.companyLabel.text = self.model.data.company_name;
            [self.provinceButton setTitle:[NSString stringWithFormat:@"%@%@", self.model.data.province, self.model.data.city] forState:UIControlStateNormal];
            self.province = self.model.data.province;
            self.city = self.model.data.city;
            self.urlTextField.text = self.model.data.company_website;
            self.contactTextField.text = self.model.data.contacts_name;
            self.mobileTextField.text = self.model.data.user_mobile;
            self.addressTextView.text = self.model.data.address;
            [self.categoryButton setTitle:self.model.data.category_name forState:UIControlStateNormal];
            self.categoryId = self.model.data.category_id;
            self.handCountTextField.text = self.model.data.retail_amount;
            self.expressCountTextField.text = self.model.data.basic_amount;
            if ([self.model.data.allow_return isEqualToString:@"1"]) {
                self.supportSwitch.on = YES;
            }else{
                self.supportSwitch.on = NO;
            }
            if (self.model.data.license.length) {
                [self.licenseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.model.data.license]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            }
            if (self.model.data.factory_pic.length) {
                [self.outImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.model.data.factory_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            }
            if (self.model.data.plant_pic.length) {
                [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.model.data.plant_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            }
            self.infoTextView.text = self.model.data.desc;
        }else{
            [SVProgressHUD showErrorWithStatus:self.model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
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

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"进入店铺" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        _rightItem.tintColor = HEXCOLOR(0x27a2f8);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

- (NSArray *)catagoryArray{
    if (!_catagoryArray) {
        _catagoryArray = [NSArray array];
    }
    return _catagoryArray;
}

@end
