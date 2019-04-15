//
//  DZPersonalInfoVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPersonalInfoVC.h"

@interface DZPersonalInfoVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation DZPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.nickTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.vipLabel.hidden = YES;
    
    [self fillData];
}

- (void)fillData{
    self.nickTextField.text = [DPMobileApplication sharedInstance].loginUser.nickname;
    if ([DPMobileApplication sharedInstance].loginUser.head_pic.length) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, [DPMobileApplication sharedInstance].loginUser.head_pic]]];
    }
//    self.dateLabel.text = [DPMobileApplication sharedInstance].loginUser.register_time;
    self.dateLabel.text = [DPMobileApplication sharedInstance].loginUser.user_level;
//    self.vipLabel.text = [DPMobileApplication sharedInstance].loginUser.user_level;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void) textFieldDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 15;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)rightItemAction{
    if (!self.nickTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    
    NSDictionary *params = @{@"nickname":self.nickTextField.text,@"token":[DPMobileApplication sharedInstance].loginUser.token};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@Api/UserCenterApi/editUserInfo",DEFAULT_HTTP_HOST] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(self.avatarImageView.image,1);
        
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
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[DPMobileApplication sharedInstance] updateUserInfo];
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    [task resume];
}

- (IBAction)infoButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{//头像
            [self callActionSheetFunc];
            break;
        }
        case 1:{//会员等级
            
            break;
        }
        case 2:{//
            
            break;
        }
        default:
            break;
    }
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
    self.avatarImageView.image = image;
    
//    [self updateImage:image];
    
}

/*
- (void)updateImage:(UIImage *)image {
    self.avatarImageView.image = image;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //调用接口上传头像?  需要压缩一下？要不然太大。
        UIImage * newImage = [self compressImage:image];
        
//        SPUser* user = [[SPUser alloc]init];
        
        NSMutableArray* images =  [[NSMutableArray alloc]init];
        
//        [SPCommonUtils saveImage:newImage WithName:avatar];
        
        if (newImage) {
            [images addObject:newImage];
        }
        
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{

        });
    });
}

-(UIImage *)compressImage:(UIImage *)image {
    CGFloat oldWidth =image.size.width;
    CGFloat oldHeight = image.size.height;
    //CGFloat whRatio = oldWidth / oldHeight;
    CGFloat resizeRatio;
    if (oldWidth > oldHeight) {
        resizeRatio = 300 / oldWidth;
    } else {
        resizeRatio = 300 / oldHeight;
    }
    CGFloat newWidth = oldWidth * resizeRatio;
    CGFloat newHeight = oldHeight * resizeRatio;
    
    UIImage *resizeImage = [self OriginImage:image scaleToSize:CGSizeMake(newWidth, newHeight)];
    
    NSData * imageData = UIImageJPEGRepresentation(resizeImage, 0.7);
    UIImage * newImage = [UIImage imageWithData:imageData];
    return newImage;
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
 */

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x333333);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

@end
