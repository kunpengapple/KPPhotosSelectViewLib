//
//  KPImageSelectedView.h
//  KPPhotosSelectDemo
//
//  Created by linian on 2018/6/30.
//  Copyright © 2018年 linian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPImageSelectedView ,KPPhotoModel;
@protocol KPPhotoViewDelegate <NSObject>
@optional

// 代理返回 选择、移动顺序、删除之后的图片结果
- (void)photoView:(KPImageSelectedView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList;

// 当view更新高度时调用
- (void)photoView:(KPImageSelectedView *)photoView updateFrame:(CGRect)frame;

/**
 当前删除的模型
 
 @param photoView self
 @param model 模型
 @param index 下标
 */
- (void)photoView:(KPImageSelectedView *)photoView currentDeleteModel:(KPPhotoModel *)model currentIndex:(NSInteger)index;
@end

@interface KPImageSelectedView : UIView

@property (weak, nonatomic) id<KPPhotoViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *imageArray;

/**  是否显示添加的cell，需手动刷新视图[self.collectionView reloadData] 默认 YES  */
@property (assign, nonatomic) BOOL showAddCell;

/**  每行个数 默认 3  */
@property (assign, nonatomic) NSInteger lineCount;
/**  每个item间距 默认 3  */
@property (assign, nonatomic) CGFloat spacing;
/**  添加图片 */
- (void)addImagesWithArray:(NSArray *)imageArray;
/**  删除某个模型  */
- (void)deleteModelWithIndex:(NSInteger)index;
@end
