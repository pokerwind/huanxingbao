//
//  DZNewsPublishCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZNewsPublishCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) RACSubject *deleteSubject;
@property (nonatomic, assign) NSInteger row;
@end
