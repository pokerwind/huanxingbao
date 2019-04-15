//
//  DZSearchResultFilterView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchResultFilterView.h"

@implementation DZSearchResultFilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.entityButton.layer.masksToBounds = YES;
    self.entityButton.layer.cornerRadius = 2;
    
    self.factoryButton.layer.masksToBounds = YES;
    self.factoryButton.layer.cornerRadius = 2;
    
    self.webButton.layer.masksToBounds = YES;
    self.webButton.layer.cornerRadius = 2;
    
    self.clearSubject = [RACSubject subject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)shopAction:(UIButton *)sender {
    NSInteger type = self.shop_type;
    [self clearShop];
    if (type == sender.tag) {
        [self clearButton:sender];
        self.shop_type = 0;
    } else {
        self.shop_type = sender.tag;
        [self setButton:sender];
    }
    

    
}

- (void)clearShop {
    NSArray *buttons = @[self.entityButton,self.factoryButton,self.webButton];
    [self clearButtons:buttons];
    self.shop_type = 0;
}

- (IBAction)sizeAction:(UIButton *)sender {
    NSString *oldSize = self.goods_size;
    [self clearSize];
    
    NSString *size = sender.currentTitle;
    if ([oldSize isEqualToString:size]) {
        [self clearButton:sender];
        self.goods_size = nil;
    }  else {
        [self setButton:sender];
        self.goods_size = size;
    }
    
//    if ([size isEqualToString:@"全部"]) {
//        self.goods_size = nil;
//    } else {
//        self.goods_size = size;
//    }
}

- (IBAction)resetAction:(id)sender {
    [self clearShop];
    [self clearSize];
    self.startPriceTextFileld.text = @"";
    self.endPriceTextField.text = @"";
    self.batchNumTextField.text = @"";
    [self.clearSubject sendNext:nil];
}


- (void)clearSize {
//    NSArray *buttons = @[self.sizeButton1,self.sizeButton2,self.sizeButton3,self.sizeButton4,self.sizeButton5,self.sizeButton6,self.sizeButton7,self.sizeButton8,self.sizeButton9,self.sizeButton10,self.sizeButton11];
//    [self clearButtons:buttons];
    
    self.goods_size = nil;
}




- (void)setButton:(UIButton *)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = OrangeColor;
}

- (void)clearButton:(UIButton *)button {
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.backgroundColor = HEXCOLOR(0xf0f0f0);
}


- (void)clearButtons:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.backgroundColor = HEXCOLOR(0xf0f0f0);
    }
}

@end
