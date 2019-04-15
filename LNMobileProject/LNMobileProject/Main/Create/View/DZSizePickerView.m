//
//  DZSizePickerView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSizePickerView.h"

#import "DZSizePickerCell.h"

#import "DZGetColorListModel.h"

@interface DZSizePickerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;

@property (strong, nonatomic) NSArray *sizeArray;

@end

@implementation DZSizePickerView
static NSString *identifier = @"DZSizePickerCell";

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZSizePickerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    [self getData];
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/getSizeList" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetColorListModel *model = [DZGetColorListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.sizeArray = model.data;
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DZColorModel *model = self.sizeArray[indexPath.item];
    model.isSelected = !model.isSelected;
    if (indexPath.item == 0) {
        for (int i = 1; i < self.sizeArray.count; i++) {
            DZColorModel *model = self.sizeArray[i];
            model.isSelected = NO;
        }
    }else{
        DZColorModel *model = self.sizeArray[0];
        model.isSelected = NO;
    }
    [self.collectionView reloadData];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sizeArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZSizePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    DZColorModel *model = self.sizeArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

- (IBAction)addButtonAction {
    if (!self.sizeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新尺码"];
        return;
    }
    NSDictionary *params = @{@"spec_id":@"2", @"value":self.sizeTextField.text};
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSizes:)]) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (DZColorModel *model in self.sizeArray) {
            if (model.isSelected) {
                [array addObject:model];
            }
        }
        
        if (!array.count) {
            [SVProgressHUD showErrorWithStatus:@"没有选择任何尺码"];
            return;
        }
        [self.delegate didSelectedSizes:array];
    }
}

- (NSArray *)sizeArray{
    if (!_sizeArray) {
        _sizeArray = [NSArray array];
    }
    return _sizeArray;
}

@end
