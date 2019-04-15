//
//  CommodityAttributeController.m
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "CommodityAttributeController.h"
#import "DZCommodityAttributeCell.h"
#import "DZCommodityAttributeModel.h"
@interface CommodityAttributeController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation CommodityAttributeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myAlbumView];
    [self attributeView];
}

- (void)attributeView
{
    NSArray *data = @[
                         @{
                             @"attr_id": @"28",
                             @"attr_name": @"风格",
                             @"values": @[
                                        @"日韩",
                                        @"欧美",
                                        @"大众",
                                        @"运动风",
                                        @"中国风",
                                        @"复古",
                                        @"淑女",
                                        @"性感"
                                        ]
                         },
                         @{
                             @"attr_id": @"44",
                             @"attr_name": @"季节",
                             @"_values": @[
                                         @"春夏",
                                         @"秋冬"
                                         ]
                         },
                         @{
                             @"attr_id": @"36",
                             @"attr_name": @"面料",
                             @"values": @[
                                        @"涤纶",
                                        @"呢料",
                                        @"针织",
                                        @"雪纺蕾丝",
                                        @"棉麻",
                                        @"皮草",
                                        @"牛仔",
                                        @"卫衣料",
                                        @"羽绒"
                                        ]
                         },
                         @{
                             @"attr_id": @"29",
                             @"attr_name": @"厚度",
                             @"values": @[
                                        @"透",
                                        @"偏薄",
                                        @"适中",
                                        @"偏厚",
                                        @"加厚",
                                        @"加绒"
                                        ]
                         }
                         ];
    self.data = [DZCommodityAttributeModel objectArrayWithKeyValuesArray:data];

    //注册接口
//    NSDictionary *params = @{
//                             @"cat_id":self.cat_id
//                             };
//    
//    LNetWorkAPI *API = [[LNetWorkAPI alloc] initWithUrl:@"/index.php/Api/GoodsEditApi/getAttrList" parameters:params];
//    [API startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//        NSLog(@"data---%@",request.responseJSONObject);
//        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
//        if ([model.status  isEqual: @"0"]) {
//            [SVProgressHUD showErrorWithStatus:model.info];
//        }else if ([model.status  isEqual: @"1"])
//        {
//            [SVProgressHUD showSuccessWithStatus:model.info];
//            ///注册成功
//
//        }
//    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//        //error.domain
//    }];
}


#pragma mark -- 懒加载 --
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-KNavigationBarH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    return _tableView;
}
- (void)myAlbumView
{
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"属性";
}

#pragma mark -- tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
//设置标识
static NSString *indentify = @"CommodityAttributeController";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZCommodityAttributeCell *cell =  [tableView dequeueReusableCellWithIdentifier:indentify];
    if(cell == nil)
    {
        cell = [[DZCommodityAttributeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZCommodityAttributeModel *frame = self.data [indexPath.row];
    return frame.cellHeight;
}


@end
