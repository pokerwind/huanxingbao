
//
//  GoodsInfoView.m
//  ChoseGoodsType
//
//  Created by 澜海利奥 on 2018/1/30.
//  Copyright © 2018年 江萧. All rights reserved.
//

#import "GoodsInfoView.h"
#import "Header.h"
#import "SizeAttributeModel.h"
@interface GoodsInfoView()
@property(nonatomic, strong)UIImageView *goodsImage;
@property(nonatomic, strong)UILabel *goodsTitleLabel;

@end
@implementation GoodsInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //商品图片
        _goodsImage = [[UIImageView alloc] init];
        _goodsImage.image = [UIImage imageNamed:@"JSLOGO"];
        _goodsImage.contentMode =  UIViewContentModeScaleAspectFill;
        _goodsImage.clipsToBounds  = YES;
        [self addSubview:_goodsImage];
        [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(15);
            make.top.mas_equalTo(self).mas_offset(15);
            make.width.mas_equalTo(kSize(80));
            make.height.mas_equalTo(kSize(80));
        }];
//    _goodsImage.sd_layout.leftSpaceToView(self,kSize(15)).topSpaceToView(self,kSize(15)).widthIs(kSize(80)).heightIs(kSize(80));
        //关闭按钮
        _closeButton = [JXUIKit buttonWithBackgroundColor:[UIColor whiteColor] imageForNormal:@"guanbi" imageForSelete:@"guanbi"];
        [self addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self);
            make.width.height.mas_equalTo(kSize(40));
            make.top.mas_equalTo(self);
        }];
//        _closeButton.sd_layout.rightSpaceToView(self, 0).widthIs(kSize(40)).heightIs(kSize(40)).topSpaceToView(self, 0);
        //标题
        _goodsTitleLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:15] text:@"标题"];
        [self addSubview:_goodsTitleLabel];
        [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsImage.mas_right).mas_offset(kSize(10));
            make.right.mas_equalTo(_closeButton.mas_left).mas_offset(-kSize(10));
            make.height.mas_equalTo(kSize(80/3));
            make.top.mas_equalTo(_goodsImage);
        }];
//        _goodsTitleLabel.sd_layout.leftSpaceToView(_goodsImage, kSize(10)).rightSpaceToView(_closeButton, kSize(10)).heightIs(kSize(20)).topEqualToView(_goodsImage);
        
        //价格
        _goodsPriceLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:KBtncol textAlignment:NSTextAlignmentLeft numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@"197"];
        [self addSubview:_goodsPriceLabel];
        
        [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsImage.mas_right).mas_offset(kSize(10));
            make.right.mas_equalTo(_closeButton.mas_left).mas_offset(-kSize(10));
            make.height.mas_equalTo(kSize(80/3));
            make.top.mas_equalTo(_goodsTitleLabel.mas_bottom);
        }];
//        _goodsPriceLabel.sd_layout.leftSpaceToView(_goodsImage, kSize(10)).rightSpaceToView(_closeButton, kSize(10)).heightIs(kSize(20)).topSpaceToView(_goodsTitleLabel, 0);
        
        //库存
        _goodsCountLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@"库存"];
        [self addSubview:_goodsCountLabel];
        
        [_goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_goodsImage.mas_right).mas_offset(kSize(10));
            make.right.mas_equalTo(_closeButton.mas_left).mas_offset(-kSize(10));
            make.height.mas_equalTo(kSize(80/3));
            make.top.mas_equalTo(_goodsPriceLabel.mas_bottom);
        }];
//        _goodsCountLabel.sd_layout.leftSpaceToView(_goodsImage, kSize(10)).rightSpaceToView(_closeButton, kSize(10)).heightIs(kSize(20)).topSpaceToView(_goodsPriceLabel, 0);
        
        
        
//        //选择提示文字
//        _promatLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@""];
//        [self addSubview:_promatLabel];
        
//        [_promatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(_goodsImage).mas_offset(kSize(10));
//            make.right.mas_equalTo(_closeButton.mas_left).mas_offset(-kSize(10));
//            make.height.mas_equalTo(kSize(10));
//            make.top.mas_equalTo(_goodsCountLabel.mas_bottom);
//        }];
//        _promatLabel.sd_layout.leftSpaceToView(_goodsImage, kSize(10)).rightSpaceToView(_closeButton, kSize(10)).heightIs(kSize(20)).topSpaceToView(_goodsCountLabel, 0);
        
    }
    return self;
}
-(void)initData:(GoodsModel *)model
{
    _model = model;
//    [_goodsImage setImage:[UIImage imageNamed:model.imageId]];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.imageId]]]; placeholderImage:[UIImage imageNamed:@"avatar_grey"];
    _goodsTitleLabel.text = model.title;
    _goodsCountLabel.text = [NSString stringWithFormat:@"库存：%@",model.totalStock];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.price.minPrice];
    NSMutableAttributedString *attritu = [[NSMutableAttributedString alloc]initWithString:_goodsPriceLabel.text];
    [attritu addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick), NSForegroundColorAttributeName: [UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0),
                             NSFontAttributeName: [UIFont systemFontOfSize:13]
                             } range:[_goodsPriceLabel.text rangeOfString:[NSString stringWithFormat:@"¥%@",model.price.minOriginalPrice]]];
    _goodsPriceLabel.attributedText = attritu;
}

//根据选择的属性组合刷新商品信息
-(void)resetData:(SizeAttributeModel *)sizeModel
{
    //如果有图片就显示图片，没图片就显示默认图
    if (sizeModel.imageId.length>0) {
        [_goodsImage setImage:[UIImage imageNamed:sizeModel.imageId]];
    }else
        [_goodsImage setImage:[UIImage imageNamed:_model.imageId]];
    
    _goodsCountLabel.text = [NSString stringWithFormat:@"库存：%@",sizeModel.stock];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@ ¥%@",sizeModel.price,sizeModel.originalPrice];
    NSMutableAttributedString *attritu = [[NSMutableAttributedString alloc]initWithString:_goodsPriceLabel.text];
    [attritu addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick), NSForegroundColorAttributeName: [UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0),
                             NSFontAttributeName: [UIFont systemFontOfSize:13]
                             } range:[_goodsPriceLabel.text rangeOfString:[NSString stringWithFormat:@"¥%@",sizeModel.originalPrice]]];
    _goodsPriceLabel.attributedText = attritu;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
