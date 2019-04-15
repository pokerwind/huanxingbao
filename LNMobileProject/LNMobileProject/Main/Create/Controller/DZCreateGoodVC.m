//
//  DZCreateGoodVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCreateGoodVC.h"
#import "HXPhotoManager.h"
#import "HXPhotoViewController.h"

#import "DZCreateGoodAddCell.h"
#import "DZColorPickerView.h"
#import "DZSizePickerView.h"
#import "CommodityAttributeController.h"
#import "DZCategoryPickerView.h"
#import "DZPropertyPickerView.h"
#import "UITextView+ZWPlaceHolder.h"

#import "DZGetColorListModel.h"
#import "DZGetCategoryListModel.h"
#import "DZGetAttrListModel.h"
#import "DZGetGoodsEditInfoModel.h"

@interface DZCreateGoodVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, DZColorPickerViewDelegate, DZSizePickerViewDelegate, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) NSInteger coverIndex;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UITextField *handPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *expressPriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *propertyButton;
@property (weak, nonatomic) IBOutlet UISwitch *supportSwitch;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZColorPickerView *colorPickerView;
@property (strong, nonatomic) DZSizePickerView *sizePickerView;
@property (strong, nonatomic) DZCategoryPickerView *categoryPickerView;
@property (strong, nonatomic) DZPropertyPickerView *propertyPickerView;
@property (strong, nonatomic) NSArray *selectedColorArray;
@property (strong, nonatomic) NSArray *selectedSizeArray;
@property (strong, nonatomic) DZCategoryListModel *selectedCategoryModel;

@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) NSArray *propertyArray;

@property (strong, nonatomic) DZGetGoodsEditInfoModel *model;//编辑模式下商品数据

@property (strong, nonatomic) HXPhotoManager *manager;

@property (nonatomic, strong) NSMutableArray *deletedImageArray;//编辑模式下删除的图片id
@property (nonatomic) NSInteger initialImageCount;//编辑模式下初始图片数量

@end

@implementation DZCreateGoodVC
static NSString *AddCellIdentifier = @"DZCreateGoodAddCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditMode) {
        self.title = @"编辑商品";
        
    }else{
        self.title = @"上传新产品";
    }
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.descTextView.placeholder = @"商品描述必须如实发布，不能含有虚报材料成分，如真皮草100%原材料成分等，违者扣分处罚。";
    self.descTextView.zw_placeHolderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCreateGoodAddCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:AddCellIdentifier];
    // 添加通知监听见键盘弹出/退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)colorButtonAction {
    [self closeKeyBoard];
    [self showColorPickerView];
}

- (IBAction)sizeButtonAction {
    [self closeKeyBoard];
    [self showSizePickerView];
}

- (IBAction)categoryButtonAction {
    [self closeKeyBoard];
    if (!self.categoryArray || !self.categoryArray.count) {
        [SVProgressHUD showErrorWithStatus:@"获取分类列表失败"];
        [self getCategoryData];
        
        return;
    }
    
    if (!self.categoryPickerView.dataArray) {    
        self.categoryPickerView.dataArray = self.categoryArray;
    }
    
    [self showCategoryPickerView];
}

- (IBAction)propertyButtonAction {
    [self closeKeyBoard];
    if (!self.selectedCategoryModel) {
        [SVProgressHUD showErrorWithStatus:@"请先选择分类~"];
        return;
    }
    if (!self.propertyArray || !self.propertyArray.count) {
        [SVProgressHUD showErrorWithStatus:@"获取属性列表失败"];
        return;
    }
    
    self.propertyPickerView.dataArray = self.propertyArray;
    [self showPropertyPickerView];
}

- (IBAction)submitButtonAction {
    if (!self.photoArray.count) {
        [SVProgressHUD showErrorWithStatus:@"请上传产品实拍图"];
        return;
    }
    if (!self.titleTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入商品标题"];
        return;
    }
    if (!self.handPriceTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入拿货价"];
        return;
    }
    if (!self.expressPriceTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入打包价"];
        return;
    }
    if (!self.selectedColorArray || !self.selectedColorArray.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择颜色"];
        return;
    }
    if (!self.selectedSizeArray || !self.selectedSizeArray.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择尺码"];
        return;
    }
    if (!self.selectedCategoryModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择分类"];
        return;
    }
    NSMutableArray *attrArray = [NSMutableArray array];
    for (DZGoodsEditAttrModel *model in self.model.data.selected_attr) {
        [attrArray addObject:[NSString stringWithFormat:@"%@:%@", model.attr_id, model.attr_value]];
    }
    if (!self.propertyPickerView.selectedResults && !attrArray.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择属性"];
        return;
    }
    
    NSMutableArray *colorIds = [NSMutableArray array];
    for (DZColorModel *model in self.selectedColorArray) {
        [colorIds addObject:model.id];
    }
    NSMutableArray *sizeIds = [NSMutableArray array];
    for (DZColorModel *model in self.selectedSizeArray) {
        [sizeIds addObject:model.id];
    }
    NSMutableArray *img_is_default = [NSMutableArray array];
    for (int i = 0; i < self.photoArray.count; i++) {
        if (i == self.coverIndex) {
            [img_is_default addObject:@"1"];
        }else{
            [img_is_default addObject:@"0"];
        }
    }
    
    NSDictionary *params;
    
    [SVProgressHUD show];
    if (self.isEditMode) {
        if (self.propertyPickerView.selectedResults.length) {
            NSString *del_img_id = @"";
            if (self.deletedImageArray.count) {
                del_img_id = [self.deletedImageArray componentsJoinedByString:@","];
            }
            
            params = @{@"goods_id":self.goodId, @"goods_name":self.titleTextField.text, @"goods_description":self.descTextView.text.length?self.descTextView.text:@"", @"pack_price":self.expressPriceTextField.text, @"shop_price":self.handPriceTextField.text, @"cat_id":self.selectedCategoryModel.cat_id, @"weight":self.weightTextField.text.length?self.weightTextField.text:@"0", @"img_is_default":img_is_default, @"color":colorIds, @"size":sizeIds, @"attr":self.propertyPickerView.selectedResults, @"is_made":self.supportSwitch.on?@"1":@"0", @"del_img_id":del_img_id};
        }else{
            NSString *del_img_id = @"";
            if (self.deletedImageArray.count) {
                del_img_id = [self.deletedImageArray componentsJoinedByString:@","];
            }
            
            NSMutableArray *attrArray = [NSMutableArray array];
            for (DZGoodsEditAttrModel *model in self.model.data.selected_attr) {
                [attrArray addObject:[NSString stringWithFormat:@"%@:%@", model.attr_id, model.attr_value]];
            }
            NSString *attrStr = [attrArray componentsJoinedByString:@","];
            params = @{@"goods_id":self.goodId, @"goods_name":self.titleTextField.text, @"goods_description":self.descTextView.text.length?self.descTextView.text:@"", @"pack_price":self.expressPriceTextField.text, @"shop_price":self.handPriceTextField.text, @"cat_id":self.selectedCategoryModel.cat_id, @"weight":self.weightTextField.text.length?self.weightTextField.text:@"0", @"img_is_default":img_is_default, @"color":colorIds, @"size":sizeIds, @"attr":attrStr, @"is_made":self.supportSwitch.on?@"1":@"0", @"del_img_id":del_img_id};
        }
    }else{
        params = @{@"goods_name":self.titleTextField.text, @"goods_description":self.descTextView.text.length?self.descTextView.text:@"", @"pack_price":self.expressPriceTextField.text, @"shop_price":self.handPriceTextField.text, @"cat_id":self.selectedCategoryModel.cat_id, @"weight":self.weightTextField.text.length?self.weightTextField.text:@"0", @"img_is_default":img_is_default, @"color":colorIds, @"size":sizeIds, @"attr":self.propertyPickerView.selectedResults, @"is_made":self.supportSwitch.on?@"1":@"0"};
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@/index.php/Api/GoodsEditApi/goodsAddEdit",DEFAULT_HTTP_HOST] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        int start = (int)(self.initialImageCount - self.deletedImageArray.count);
        for (int i = start; i <[self.photoArray count]; i++) {//循环...
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
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            if (self.isEditMode) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didModifyGood)]) {
                    [self.delegate didModifyGood];
                }
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(didAddGood)]) {
                    [self.delegate didAddGood];
                }
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:resultDict[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    [task resume];
}

- (IBAction)resetButtonAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定重置吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //重置上传的图片
        self.coverIndex = 0;
        [self.photoArray removeAllObjects];
        [self.collectionView reloadData];
        
        if (self.model) {
            [self.deletedImageArray removeAllObjects];
            for (DZGoodsEditImgModel *model in self.model.data.img_list) {
                [self.deletedImageArray addObject:model.img_id];
            }
        }
        //标题
        self.titleTextField.text = nil;
        //描述
        self.descTextView.text = nil;
        //拿货价
        self.handPriceTextField.text = nil;
        //打包价
        self.expressPriceTextField.text = nil;
        //颜色
        self.selectedColorArray = [NSArray array];
        [self.colorButton setTitle:@"请选择" forState:UIControlStateNormal];
        //尺码
        self.selectedSizeArray = [NSArray array];
        [self.sizeButton setTitle:@"请选择" forState:UIControlStateNormal];
        //商品分类
        self.selectedCategoryModel = nil;
        [self.categoryButton setTitle:@"请选择" forState:UIControlStateNormal];
        //商品属性
        for (DZAttrListModel *model in self.propertyPickerView.dataArray) {
            model.selectedValue = nil;
        }
        [self.propertyButton setTitle:@"请选择" forState:UIControlStateNormal];
        if (self.model) {
            self.model.data.selected_attr = nil;
        }
        //重量
        self.weightTextField.text = nil;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)categoryPickerCancelButtonAction{
    [self hideCategoryPickerView];
}

- (void)categoryPickerFinishButtonAction{
    [self hideCategoryPickerView];
    self.selectedCategoryModel = self.categoryPickerView.selectedModel;
    [self.categoryButton setTitle:self.selectedCategoryModel.cat_name_mobile forState:UIControlStateNormal];
    [self getPropertyData];
    [self.propertyButton setTitle:@"请选择" forState:UIControlStateNormal];
}

- (void)propertyPickerFinishButtonAction{
    [self hidePropertyPickerView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (DZAttrListModel *model in self.propertyPickerView.dataArray) {
        if (model.selectedValue) {
            [array addObject:model.selectedValue];
        }
    }
    
    if (array.count) {
        NSString *resultStr = [array componentsJoinedByString:@","];
        [self.propertyButton setTitle:resultStr forState:UIControlStateNormal];
    }
}

- (void)showColorPickerView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.colorPickerView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideColorPickerView)]];
    [UIView animateWithDuration:.3 animations:^{
        self.colorPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - self.colorPickerView.height, self.colorPickerView.width, self.colorPickerView.height);
    }];
}

- (void)hideColorPickerView{
    [UIView animateWithDuration:.2 animations:^{
        self.colorPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, self.colorPickerView.width, self.colorPickerView.height);
    }completion:^(BOOL finished) {
        [self.colorPickerView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (void)showSizePickerView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.sizePickerView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSizePickerView)]];
    [UIView animateWithDuration:.3 animations:^{
        self.sizePickerView.frame = CGRectMake(0, SCREEN_HEIGHT - self.sizePickerView.height, self.sizePickerView.width, self.sizePickerView.height);
    }];
}

- (void)hideSizePickerView{
    [UIView animateWithDuration:.2 animations:^{
        self.sizePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, self.sizePickerView.width, self.sizePickerView.height);
    }completion:^(BOOL finished) {
        [self.sizePickerView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (void)showCategoryPickerView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.categoryPickerView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCategoryPickerView)]];
    [UIView animateWithDuration:.3 animations:^{
        self.categoryPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - self.categoryPickerView.height, self.categoryPickerView.width, self.categoryPickerView.height);
    }];
}

- (void)hideCategoryPickerView{
    [UIView animateWithDuration:.2 animations:^{
        self.categoryPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, self.categoryPickerView.width, self.categoryPickerView.height);
    }completion:^(BOOL finished) {
        [self.categoryPickerView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (void)showPropertyPickerView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.propertyPickerView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePropertyPickerView)]];
    [UIView animateWithDuration:.3 animations:^{
        self.propertyPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - self.propertyPickerView.height, self.propertyPickerView.width, self.propertyPickerView.height);
    }];
}

- (void)hidePropertyPickerView{
    [UIView animateWithDuration:.2 animations:^{
        self.propertyPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, self.propertyPickerView.width, self.propertyPickerView.height);
    }completion:^(BOOL finished) {
        [self.propertyPickerView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UIPageViewControllerDelegate ----
- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original{
    for (HXPhotoModel *model in photos) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result,NSDictionary*info) {
            [self.photoArray addObject:result];
            [self.collectionView reloadData];
        }];
    }
}

#pragma mark - ---- DZSizePickerViewDelegate ----
- (void)didSelectedSizes:(NSArray *)sizes{
    [self hideSizePickerView];
    self.selectedSizeArray = sizes;
    NSMutableArray *array = [NSMutableArray array];
    for (DZColorModel *model in sizes) {
        [array addObject:model.item];
    }
    NSString *result = [array componentsJoinedByString:@","];
    [self.sizeButton setTitle:result forState:UIControlStateNormal];
}

#pragma mark - ---- DZColorPickerViewDelegate ----
- (void)didSelectedColors:(NSArray *)colors{
    [self hideColorPickerView];
    self.selectedColorArray = colors;
    NSMutableArray *array = [NSMutableArray array];
    for (DZColorModel *model in colors) {
        [array addObject:model.item];
    }
    NSString *result = [array componentsJoinedByString:@","];
    [self.colorButton setTitle:result forState:UIControlStateNormal];
}

#pragma mark - ---- UICollectionViewDelegate ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.photoArray.count) {
        [self callActionSheetFunc];
    }else{
        self.coverIndex = indexPath.item;
        [self.collectionView reloadData];
    }
}
#pragma mark - ---- UICollectionViewDataSource ----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZCreateGoodAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.photoArray.count) {
        UIImage *img = self.photoArray[indexPath.item];
        cell.coverImageView.image = img;
        cell.deleteButton.hidden = NO;
        cell.deleteButton.tag = indexPath.item;
        [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.item == self.coverIndex) {
            cell.coverTagImageView.hidden = NO;
        }else{
            cell.coverTagImageView.hidden = YES;
        }
    }else{
        cell.coverImageView.image = [UIImage imageNamed:@"btn_add_realimg"];
        cell.deleteButton.hidden = YES;
        cell.coverTagImageView.hidden = YES;
    }
    
    return cell;
}

- (void)cellDeleteButtonAction:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btn.tag < self.model.data.img_list.count) {
            DZGoodsEditImgModel *model = self.model.data.img_list[btn.tag];
            [self.deletedImageArray addObject:model.img_id];
            [self.model.data.img_list removeObjectAtIndex:btn.tag];
        }
        [self.photoArray removeObjectAtIndex:btn.tag];
        if (self.coverIndex == btn.tag) {
            self.coverIndex = 0;
        }
        [self.collectionView reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ---- 私有方法 ----
- (void)keyboardAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        CGFloat height = [value CGRectValue].size.height;
        if (self.colorPickerView.superview) {
            [UIView animateWithDuration:.3 animations:^{
                self.colorPickerView.frame = CGRectMake(self.colorPickerView.x, SCREEN_HEIGHT - height - self.colorPickerView.height, self.colorPickerView.width, self.colorPickerView.height);
            }];
        }else if (self.sizePickerView.superview){
            [UIView animateWithDuration:.3 animations:^{
                self.sizePickerView.frame = CGRectMake(self.sizePickerView.x, SCREEN_HEIGHT - height - self.sizePickerView.height, self.sizePickerView.width, self.sizePickerView.height);
            }];
        }
    }else{
        if (self.colorPickerView.superview) {
            [UIView animateWithDuration:.3 animations:^{
                self.colorPickerView.frame = CGRectMake(self.colorPickerView.x, SCREEN_HEIGHT  - self.colorPickerView.height, self.colorPickerView.width, self.colorPickerView.height);
            }];
        }else if (self.sizePickerView.superview){
            [UIView animateWithDuration:.3 animations:^{
                self.sizePickerView.frame = CGRectMake(self.sizePickerView.x, SCREEN_HEIGHT  - self.sizePickerView.height, self.sizePickerView.width, self.sizePickerView.height);
            }];
        }
    }
}

- (void)closeKeyBoard{
    [self.view endEditing:YES];
}

- (void)fillEditData{
    DZGetGoodsEditInfoModel *model = self.model;
    self.titleTextField.text = model.data.goods_name;
    self.descTextView.text = model.data.goods_description;
    self.handPriceTextField.text = model.data.shop_price;
    self.expressPriceTextField.text = model.data.pack_price;
    self.weightTextField.text = model.data.weight;
    if ([model.data.is_made boolValue]) {
        self.supportSwitch.on = YES;
    }else{
        self.supportSwitch.on = NO;
    }
    
    NSMutableArray *imgStrArray = [NSMutableArray array];
    for (DZGoodsEditImgModel *models in model.data.img_list) {
        [imgStrArray addObject:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, models.image_path]];
    }
    
    __block NSInteger successCount = 0;
    __weak typeof(self) weakP = self;
    if (imgStrArray.count) {
        [SVProgressHUD show];
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
        self.initialImageCount = imgStrArray.count;
        // 开始任务
        [downloadTask resume];
    }
    
    //颜色
    NSMutableArray *colorArray = [NSMutableArray array];
    for (DZGoodsEditColorModel *models in model.data.selected_color) {
        DZColorModel *color = [DZColorModel new];
        color.id = models.color_id;
        color.item = models.color_name;
        [colorArray addObject:color];
    }
    self.selectedColorArray = colorArray;
    NSMutableArray *colorNameArray = [NSMutableArray array];
    for (DZColorModel *model in self.selectedColorArray) {
        [colorNameArray addObject:model.item];
    }
    if (colorNameArray.count) {
        NSString *result = [colorNameArray componentsJoinedByString:@","];
        [self.colorButton setTitle:result forState:UIControlStateNormal];
    }
    //尺码
    NSMutableArray *sizeArray = [NSMutableArray array];
    for (DZGoodsEditSizeModel *models in model.data.selected_size) {
        DZColorModel *size = [DZColorModel new];
        size.id = models.size_id;
        size.item = models.size_name;
        [sizeArray addObject:size];
    }
    self.selectedSizeArray = sizeArray;
    NSMutableArray *sizeNameArray = [NSMutableArray array];
    for (DZColorModel *model in self.selectedSizeArray) {
        [sizeNameArray addObject:model.item];
    }
    if (sizeNameArray.count) {
        NSString *result = [sizeNameArray componentsJoinedByString:@","];
        [self.sizeButton setTitle:result forState:UIControlStateNormal];
    }
    //商品分类
    self.selectedCategoryModel = [DZCategoryListModel new];
    self.selectedCategoryModel.cat_name_mobile = model.data.cat_name;
    self.selectedCategoryModel.cat_id = model.data.cat_id;
    [self.categoryButton setTitle:model.data.cat_name forState:UIControlStateNormal];
    //商品属性
    NSMutableArray *attNameArray = [NSMutableArray new];
    for (DZGoodsEditAttrModel *models in model.data.selected_attr) {
        [attNameArray addObject:models.attr_value];
    }
    if (attNameArray.count) {
        NSString *attStr = [attNameArray componentsJoinedByString:@","];
        [self.propertyButton setTitle:attStr forState:UIControlStateNormal];
    }
    
    [self getPropertyData];
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
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{
                    
                }];
            }
        }else{
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.delegate = self;
            vc.manager = self.manager;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }
        
    }
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];// [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photoArray addObject:image];
    [self.collectionView reloadData];
}

- (void)getData{
    [self getCategoryData];
    
    if (self.isEditMode) {
        NSDictionary *params = @{@"goods_id":self.goodId};
        LNetWorkAPI *infoApi = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/goodsEditInfo" parameters:params];
        [SVProgressHUD show];
        [infoApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            self.model = [DZGetGoodsEditInfoModel objectWithKeyValues:request.responseJSONObject];
            if (self.model.isSuccess) {
                [self fillEditData];
            }else{
                [SVProgressHUD showErrorWithStatus:self.model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

- (void)getCategoryData{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsCategoryApi/getCategoryList" parameters:nil];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetCategoryListModel *model = [DZGetCategoryListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.categoryArray = model.data;
        }
    } failure:nil];
}

- (void)getPropertyData{
    NSDictionary *params = @{@"cat_id":self.selectedCategoryModel.cat_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/getAttrList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetAttrListModel *model = [DZGetAttrListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.propertyArray = model.data;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        _leftItem.tintColor = HEXCOLOR(0xff7722);
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _leftItem;
}

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    }
    return _maskView;
}

- (DZColorPickerView *)colorPickerView{
    if (!_colorPickerView) {
        _colorPickerView = [DZColorPickerView viewFormNib];
        _colorPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        _colorPickerView.delegate = self;
    }
    return _colorPickerView;
}

- (DZSizePickerView *)sizePickerView{
    if (!_sizePickerView) {
        _sizePickerView = [DZSizePickerView viewFormNib];
        _sizePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        _sizePickerView.delegate = self;
    }
    return _sizePickerView;
}

- (DZCategoryPickerView *)categoryPickerView{
    if (!_categoryPickerView) {
        _categoryPickerView = [DZCategoryPickerView viewFormNib];
        _categoryPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        [_categoryPickerView.cancelButton addTarget:self action:@selector(categoryPickerCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_categoryPickerView.finishButton addTarget:self action:@selector(categoryPickerFinishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _categoryPickerView;
}

- (DZPropertyPickerView *)propertyPickerView{
    if (!_propertyPickerView) {
        _propertyPickerView = [DZPropertyPickerView viewFormNib];
        _propertyPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400);
        [_propertyPickerView.finishButton addTarget:self action:@selector(propertyPickerFinishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _propertyPickerView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = NO;
        _manager.photoMaxNum = 20;
    }
    return _manager;
}

- (NSMutableArray *)deletedImageArray{
    if (!_deletedImageArray) {
        _deletedImageArray = [NSMutableArray array];
    }
    return _deletedImageArray;
}

- (void)dealloc{
    
}

@end
