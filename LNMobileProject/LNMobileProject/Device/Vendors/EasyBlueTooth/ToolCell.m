//
//  ToolCell.m
//  EasyBlueTooth
//
//  Created by nf on 2017/8/18.
//  Copyright © 2017年 chenSir. All rights reserved.
//

#import "ToolCell.h"

@interface ToolCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RSSILabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;

@end

@implementation ToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPeripheral:(EasyPeripheral *)peripheral
{
    _peripheral = peripheral ;
    
    self.nameLabel.text = peripheral.name ;
    self.RSSILabel.text = [NSString stringWithFormat:@"%@",peripheral.RSSI ];
//    NSArray *serviceArray = [peripheral.advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    self.servicesLabel.text = [NSString stringWithFormat:@"识别符：%@",peripheral.identifierString];
    
    if (peripheral.state == CBPeripheralStateConnected) {
//        self.stateLabel.text = @"已连接";
//        self.stateLabel.backgroundColor = [UIColor colorWithHexString:@"#008B56"];
        [self.stateLabel setHidden:NO];
    }else{
//        self.stateLabel.backgroundColor = [UIColor colorWithHexString:@"#008B56"];
//        self.stateLabel.text = @"未连接";
        [self.stateLabel setHidden:YES];
    }
    [self layoutSubviews];
}

+ (CGFloat)cellHeight
{
    return 80.0f ;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
