//
//  DZOrderDetailHeaderView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOrderDetailHeaderView.h"

@interface DZOrderDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DZOrderDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.messageLabel.hidden = YES;
    [self.addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLabelTap)]];
}

- (IBAction)copyButtonAction {
    [SVProgressHUD showSuccessWithStatus:@"订单号复制成功！"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.numberLabel.text;
}


/**
 复制地址
 */
- (IBAction)copyAddressBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@，%@，%@，000000",self.consigneeLabel.text,self.mobileLabel.text,self.addressLabel.text];
    [SVProgressHUD showSuccessWithStatus:@"地址复制成功！"];
}

- (void)addressLabelTap{
    [SVProgressHUD showSuccessWithStatus:@"收货地址复制成功！"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLabel.text;
}

- (void)fillData:(DZGetOrderDetailModel *)model{
    if ([model.data.order_status isEqualToString:@"0"]) {
        self.stateLabel.text = @"已取消";
    }else if ([model.data.order_status isEqualToString:@"1"]){
        self.stateLabel.text = @"待付款";
    }else if ([model.data.order_status isEqualToString:@"2"]){
        self.stateLabel.text = @"待发货";
    }else if ([model.data.order_status isEqualToString:@"3"]){
        self.stateLabel.text = @"待收货";
    }else if ([model.data.order_status isEqualToString:@"4"]){
        self.stateLabel.text = @"已完成";
    }
    
    self.numberLabel.text = model.data.order_sn;
    self.dateLabel.text = model.data.add_time;
    self.messageLabel.text = model.data.remark.length > 0?model.data.remark:@"没有留言";
    self.consigneeLabel.text = model.data.consignee;
    self.mobileLabel.text = model.data.mobile;
    self.addressLabel.text = model.data.address;
}

@end
