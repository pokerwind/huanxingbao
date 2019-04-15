//
//  DZAuthenticationVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAuthenticationVC.h"

#import "DZAuthenticationSubmitResultVC.h"

@interface DZAuthenticationVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIImage *photo;

@end

@implementation DZAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    if (!self.numberTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码"];
        return;
    }
    if (!self.nameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入本人姓名"];
        return;
    }
    if (!self.photo) {
        [SVProgressHUD showErrorWithStatus:@"请上传证件照片"];
        return;
    }
    
    NSDictionary *params = @{@"idcard_num":self.numberTextField.text, @"truename":self.nameTextField.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[DEFAULT_HTTP_HOST stringByAppendingString:@"/index.php/Api/ShopCenterApi/verifyIdCard"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(self.photo,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"photo"
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
            [SVProgressHUD dismiss];
            DZAuthenticationSubmitResultVC *vc = [DZAuthenticationSubmitResultVC new];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nvc animated:YES completion:^{
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    [task resume];
}

- (IBAction)addButtonAction {
    [self callActionSheetFunc];
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.photo = image;
    [self.addButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x33a3f9);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

@end
