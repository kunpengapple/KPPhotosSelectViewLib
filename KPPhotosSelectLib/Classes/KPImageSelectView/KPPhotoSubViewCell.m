//
//  KPPhotoSubViewCell.m
//  KPPhotosSelectDemo
//
//  Created by linian on 2018/6/30.
//  Copyright © 2018年 linian. All rights reserved.
//

#import "KPPhotoSubViewCell.h"
#import "KPPhotoModel.h"
@interface KPPhotoSubViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@end


@implementation KPPhotoSubViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self.contentView addSubview:self.imageView];
    
}

- (void)setModel:(KPPhotoModel *)model {
    _model =  model;
    _imageView.image = model.image;
}

- (void)layoutSubviews {
    self.imageView.frame  = self.bounds;
}
#pragma mark - < 懒加载 >
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end
