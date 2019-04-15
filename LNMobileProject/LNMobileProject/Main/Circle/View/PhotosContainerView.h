//
//  PhotosContainerView.h
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosContainerViewDelegate <NSObject>

@optional

-(void)commentSelectedIndex:(NSInteger)index images:(NSArray*)images;

@end

@interface PhotosContainerView : UIView

- (instancetype)initWithMaxItemsCount:(NSInteger)count;

@property (nonatomic, strong) NSArray *photoNamesArray;

@property (nonatomic, assign) NSInteger maxItemsCount;

@property (nonatomic,weak) id<PhotosContainerViewDelegate> delegate;

@end
