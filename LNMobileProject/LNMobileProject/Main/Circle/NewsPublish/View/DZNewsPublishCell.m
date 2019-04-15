//
//  DZNewsPublishCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZNewsPublishCell.h"

@implementation DZNewsPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteAction:(id)sender {
    [self.deleteSubject sendNext:@(self.row)];
}

@end
