//
//  PhotosContainerView.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "PhotosContainerView.h"
#import "UIView+SDAutoLayout.h"

@implementation PhotosContainerView
{
    NSMutableArray *_imageViewsArray;
}

- (instancetype)initWithMaxItemsCount:(NSInteger)count
{
    if (self = [super init]) {
        self.maxItemsCount = count;
    }
    return self;
}

- (void)setPhotoNamesArray:(NSArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _imageViewsArray.count);
    NSInteger startIndex = _imageViewsArray.count;
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIImageView *imageView = [UIImageView new];
            imageView.tag = startIndex + i + 10;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
            [imageView addGestureRecognizer:tapGesture];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if (idx < _photoNamesArray.count) {
            imageView.hidden = NO;
            if (_photoNamesArray.count == 1) {
                imageView.sd_layout.autoHeightRatio(9.0/16.0);
            }else {
                imageView.sd_layout.autoHeightRatio(1);
            }
            
            //imageView.image = [UIImage imageNamed:_photoNamesArray[idx]];
            
            NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,_photoNamesArray[idx]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            [temp addObject:imageView];
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
    }];
    if (_photoNamesArray.count == 1) {
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:1 verticalMargin:2 horizontalMargin:2 verticalEdgeInset:0 horizontalEdgeInset:0];
    }else{
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:2 horizontalMargin:2 verticalEdgeInset:0 horizontalEdgeInset:0];
    }
    
}

/**
 *  点击事件
 */
- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    if(self.delegate && [self.delegate respondsToSelector:@selector(commentSelectedIndex:images:)]){
        [self.delegate commentSelectedIndex:tapGestureRecognizer.view.tag - 10 images:self.photoNamesArray];
    }
}



@end
