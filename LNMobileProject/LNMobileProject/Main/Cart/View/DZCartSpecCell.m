//
//  DZCartSpecCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartSpecCell.h"

@interface DZCartSpecCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UITextField *buyCountTextField;

@property (strong, nonatomic) DZCartSpecModel *model;

@end

@implementation DZCartSpecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyCountTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZCartSpecModel *)model{
    self.model = model;
    
    self.nameLabel.text = model.spec_name;
    self.totalCountLabel.text = model.store_count;
    self.buyCountTextField.text = model.has_number;
}

- (IBAction)addButtonAction {
    if ([self.model.has_number integerValue] < [self.model.store_count integerValue]) {
        NSInteger current = [self.model.has_number integerValue];
        self.model.has_number = [NSString stringWithFormat:@"%ld", ++current];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCartData)]) {
        [self.delegate refreshCartData];
    }
}

- (IBAction)reduceButtonAction {
    if ([self.model.has_number integerValue] > 0) {
        NSInteger current = [self.model.has_number integerValue];
        self.model.has_number = [NSString stringWithFormat:@"%ld", --current];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCartData)]) {
        [self.delegate refreshCartData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.model.has_number = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCartData)]) {
        [self.delegate refreshCartData];
    }
}

@end
