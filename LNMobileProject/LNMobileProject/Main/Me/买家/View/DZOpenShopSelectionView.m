//
//  DZOpenShopSelectionView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/22.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOpenShopSelectionView.h"
#import "DZShopSelectionCell.h"

@interface DZOpenShopSelectionView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *rootTableView;


@end

@implementation DZOpenShopSelectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    
//    self.button1.layer.borderWidth = 1;
//    self.button1.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
//    self.buton2.layer.borderWidth = 1;
//    self.buton2.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
    self.rootTableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.rootTableView registerNib:[UINib nibWithNibName:@"DZShopSelectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DZShopSelectionCellID"];
    self.rootTableView.scrollEnabled = NO;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    CGFloat height = 50;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].width, height * dataArray.count + 60);
    });
    self.rootTableView.dataSource = self;
    self.rootTableView.delegate = self;
    [self.rootTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZShopSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DZShopSelectionCellID" forIndexPath:indexPath];
    NSString *name = _dataArray[indexPath.row][@"name"];
    cell.nameLabel.text = name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"111");
    NSString *type = _dataArray[indexPath.row][@"shop_type_id"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectShopType:)]) {
        [self.delegate didSelectShopType:type.integerValue];
    }
    
}

@end
