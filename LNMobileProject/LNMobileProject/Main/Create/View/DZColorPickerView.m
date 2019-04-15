//
//  DZColorPickerView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZColorPickerView.h"

#import "DZColorPickerCell.h"

#import "DZGetColorListModel.h"
#import "DPMobileApplication.h"

@interface DZColorPickerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *colorArray;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation DZColorPickerView

static NSString *identifier = @"DZColorPickerCell";
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZColorPickerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    [self getData];
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/getColorList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetColorListModel *model = [DZGetColorListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.colorArray = model.data;
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DZColorModel *model = self.colorArray[indexPath.item];
    model.isSelected = !model.isSelected;
    if (indexPath.item == 0) {
        for (int i = 1; i < self.colorArray.count; i++) {
            DZColorModel *model = self.colorArray[i];
            model.isSelected = NO;
        }
    }else{
        DZColorModel *model = self.colorArray[0];
        model.isSelected = NO;
    }
    [self.collectionView reloadData];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colorArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZColorPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    DZColorModel *model = self.colorArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

- (IBAction)addColorButtonAction {
    if (!self.colorTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新颜色"];
        return;
    }
    NSDictionary *params = @{@"spec_id":@"1", @"value":self.colorTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/shopSpecAdd" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self getData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (IBAction)submitButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedColors:)]) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (DZColorModel *model in self.colorArray) {
            if (model.isSelected) {
                [array addObject:model];
            }
        }
        
        if (!array.count) {
            [SVProgressHUD showErrorWithStatus:@"没有选择任何颜色"];
            return;
        }
        [self.delegate didSelectedColors:array];
    }
}

- (NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [NSArray array];
    }
    return _colorArray;
}

@end
