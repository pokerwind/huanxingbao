//
//  DZCategoryPickerView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCategoryPickerView.h"

@interface DZCategoryPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *subDataArray;

@end

@implementation DZCategoryPickerView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.leftPickerView.dataSource = self;
    self.leftPickerView.delegate = self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dataArray.count;
    }else{
        return self.subDataArray.count;
    }
    return 4;
}

#pragma mark - UIPickerViewDataSource
- (nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        DZCategoryListModel *model = self.dataArray[row];
        return model.cat_name_mobile;
    }else{
        DZCategoryListModel *model = self.subDataArray[row];
        return model.cat_name_mobile;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        DZCategoryListModel *model = self.dataArray[row];
        self.subDataArray = model.child;
        
        [self.leftPickerView selectRow:0 inComponent:1 animated:YES];
        self.selectedModel = self.subDataArray[0];
        [self.leftPickerView reloadComponent:1];
    }else{
        self.selectedModel = self.subDataArray[row];
    }
}

- (NSArray *)subDataArray{
    if (!_subDataArray) {
        _subDataArray = [NSArray array];
    }
    return _subDataArray;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    DZCategoryListModel *model = self.dataArray[0];
    self.subDataArray = model.child;
    self.selectedModel = self.subDataArray[0];
    [self.leftPickerView reloadComponent:0];
    [self.leftPickerView reloadComponent:1];
}

@end
