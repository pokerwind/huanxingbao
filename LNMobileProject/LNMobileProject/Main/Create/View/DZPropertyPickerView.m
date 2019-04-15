//
//  DZPropertyPickerView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPropertyPickerView.h"

#import "DZPropertyViewCell.h"

#import "DZGetAttrListModel.h"

@interface DZPropertyPickerView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DZPropertyPickerView
static NSString *identifier = @"DZPropertyViewCell";

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZPropertyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZPropertyViewCell viewFormNib];
    }
    DZAttrListModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

- (NSString *)selectedResults{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (DZAttrListModel *model in self.dataArray) {
        if (model.selectedValue) {
            [dict setObject:model.selectedValue forKey:model.attr_id];
        }
    }
    
    if (dict.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in dict.allKeys) {
            NSString *str = [NSString stringWithFormat:@"%@:%@", key, dict[key]];
            [array addObject:str];
        }
        NSString *result = [array componentsJoinedByString:@","];
        return result;  
    }else{
        return nil;
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
