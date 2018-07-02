//
//  KPPhotoSubViewCell.h
//  KPPhotosSelectDemo
//
//  Created by linian on 2018/6/30.
//  Copyright © 2018年 linian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HXPhotoSubViewCellDelegate <NSObject>

- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell;
@end
@class KPPhotoModel;

@interface KPPhotoSubViewCell : UICollectionViewCell
@property (weak, nonatomic) id<HXPhotoSubViewCellDelegate> delegate;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) KPPhotoModel *model;
@end
