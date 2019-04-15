//
//  DZUploadCertificationVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/23.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZUploadCertificationVC.h"
#import "DZBailIntroVC.h"

#import "DZPhotoExampleView.h"

@interface DZUploadCertificationVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton1;
@property (weak, nonatomic) IBOutlet UILabel *uploadTitle1;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton2;
@property (weak, nonatomic) IBOutlet UILabel *uploadTitle2;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton3;
@property (weak, nonatomic) IBOutlet UILabel *uploadTitle3;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic) NSInteger clickedUploadButtonIndex;
@property (nonatomic) BOOL upload1Selected;
@property (nonatomic) BOOL upload2Selected;
@property (nonatomic) BOOL upload3Selected;

@end

@implementation DZUploadCertificationVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传资质";
    
    if (self.type == 1) {
        [self switchType];
    }
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)uploadButtonAction:(UIButton *)sender {
    self.clickedUploadButtonIndex = sender.tag;
    
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

- (IBAction)exampleButtonAction {
    DZPhotoExampleView *view = [DZPhotoExampleView viewFormNib];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].delegate.window);
    }];
}

- (IBAction)submitButtonAction {
    if (self.type == 1) {//实体店
        if (!self.nameTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请填写营业执照名称~"];
            return;
        }
        if (!self.numberTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请填写营业执照注册号~"];
            return;
        }
        if (!self.upload1Selected) {
            [SVProgressHUD showErrorWithStatus:@"请上传营业执照~"];
            return;
        }
    }else{//工厂店
        if (!self.nameTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请填写公司名称~"];
            return;
        }
        if (!self.upload1Selected) {
            [SVProgressHUD showErrorWithStatus:@"请上传营业执照~"];
            return;
        }
        if (!self.upload2Selected) {
            [SVProgressHUD showErrorWithStatus:@"请上传厂房外景~"];
            return;
        }
        if (!self.upload3Selected) {
            [SVProgressHUD showErrorWithStatus:@"请上传车间/设备~"];
            return;
        }
    }
    
    NSString *shopType = self.type == 1? @"1":@"2";
    NSDictionary *params = @{@"shop_type":shopType, @"shop_id":self.shopId, @"company_name":self.nameTextField.text, @"reg_number":self.numberTextField.text, @"company_website":self.numberTextField.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[DEFAULT_HTTP_HOST stringByAppendingString:@"/index.php/Api/ShopEditApi/addShopStep2"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if (self.type == 1) {//实体店
            NSData *imgData = UIImageJPEGRepresentation(self.uploadButton1.imageView.image,1);
            [formData appendPartWithFileData:imgData
                                        name:@"license"
                                    fileName:@"name1.jpg"
                                    mimeType:@"image/jpeg"];
        }else{//工厂店
            NSData *imgData = UIImageJPEGRepresentation(self.uploadButton1.imageView.image,1);
            [formData appendPartWithFileData:imgData
                                        name:@"license"
                                    fileName:@"name1.jpg"
                                    mimeType:@"image/jpeg"];
            NSData *imgData2 = UIImageJPEGRepresentation(self.uploadButton2.imageView.image,1);
            [formData appendPartWithFileData:imgData2
                                        name:@"factory_pic"
                                    fileName:@"name2.jpg"
                                    mimeType:@"image/jpeg"];
            NSData *imgData3 = UIImageJPEGRepresentation(self.uploadButton3.imageView.image,1);
            [formData appendPartWithFileData:imgData3
                                        name:@"plant_pic"
                                    fileName:@"name3.jpg"
                                    mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%@", uploadProgress);
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"努力上传中..."];
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        if ([responseObject[@"status"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            [[DPMobileApplication sharedInstance] updateUserInfo];
            
            DZBailIntroVC *vc = [DZBailIntroVC new];
            vc.needSwitch = YES;
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
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = sourceType;
    [self presentViewController:photoPicker animated:YES completion:nil];
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.clickedUploadButtonIndex == 0) {
        [self.uploadButton1 setImage:image forState:UIControlStateNormal];
        self.upload1Selected = YES;
    }else if (self.clickedUploadButtonIndex == 1){
        [self.uploadButton2 setImage:image forState:UIControlStateNormal];
        self.upload2Selected = YES;
    }else{
        [self.uploadButton3 setImage:image forState:UIControlStateNormal];
        self.upload3Selected = YES;
    }
}

#pragma mark - --- getters 和 setters ----
- (void)switchType{
    self.nameLabel.text = @"营业执照名称";
    self.nameTextField.placeholder = @"请输入营业执照名称";
    self.numberLabel.text = @"营业执照注册号";
    self.numberTextField.placeholder = @"请输入营业执照注册号";
    self.uploadTitle2.hidden = YES;
    self.uploadButton2.hidden = YES;
    self.uploadTitle3.hidden = YES;
    self.uploadButton3.hidden = YES;
}

@end
