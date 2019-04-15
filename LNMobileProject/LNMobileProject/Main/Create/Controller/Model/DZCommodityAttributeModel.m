//
//  DZCommodityAttributeModel.m
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCommodityAttributeModel.h"
#import "KBXTFocusOnMeStatusPhotosView.h"
@implementation DZCommodityAttributeModel
{
    CGFloat _cellHeight;
}
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
                   /**
             1.10间距是 每个cell的 10间距
             2.60间距是 每个cell的 头像，名字，发布时间，年级，等视图的间距
             3.textH是 每个cell的 文字间距+10是文字的顶部与底部都有5的距离
             4.45间距是 每个cell的 底部间距赞评论等
             */
            ///算几张图片几张图的高
            CGFloat H = [KBXTFocusOnMeStatusPhotosView sizeWithCount:_values.count];
            
            _cellHeight = H;
        
    }
    return _cellHeight;
}

@end
