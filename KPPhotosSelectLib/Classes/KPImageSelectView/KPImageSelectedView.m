//
//  KPImageSelectedView.m
//  KPPhotosSelectDemo
//
//  Created by linian on 2018/6/30.
//  Copyright © 2018年 linian. All rights reserved.
//

#import "KPImageSelectedView.h"
#import "KPSelectViewCollectionView.h"
#import "KPPhotoSubViewCell.h"
#import "KPPhotoModel.h"


static NSString *HXPhotoSubViewCellId = @"photoSubViewCellId";
@interface KPImageSelectedView ()<KPCollectionViewDataSource,KPCollectionViewDelegate,HXPhotoSubViewCellDelegate,KPCollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;

@property (strong, nonatomic) KPSelectViewCollectionView *collectionView;
@property (strong, nonatomic) KPPhotoModel *addModel;
@property (assign, nonatomic) NSInteger numOfLinesOld;

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) KPPhotoSubViewCell *addCell;

@property (assign, nonatomic) BOOL tempShowAddCell;

@end

@implementation KPImageSelectedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.spacing = 3;
        self.lineCount = 3;
        self.numOfLinesOld = 0;
        [self setup];
    }
    return self;
}
- (void)setup {
    self.tag = 9999;
//    self.showAddCell = YES;
    //    [self.dataList addObject:self.addModel];
    
    self.flowLayout.minimumLineSpacing = 3;
    self.flowLayout.minimumInteritemSpacing = 3;
    self.collectionView = [[KPSelectViewCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.tag = 8888;
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = self.backgroundColor;
    [self.collectionView registerClass:[KPPhotoSubViewCell class] forCellWithReuseIdentifier:HXPhotoSubViewCellId];
    [self.collectionView registerClass:[KPPhotoSubViewCell class] forCellWithReuseIdentifier:@"addCell"];
    [self addSubview:self.collectionView];

}


- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray =  imageArray;
    [self.dataList removeAllObjects];
    for (UIImage *image in imageArray) {
        KPPhotoModel *imageModel = [[KPPhotoModel alloc] init];
        imageModel.image = image;
        imageModel.type = 0;
        [self.dataList addObject:imageModel];
    }
    if (self.dataList.count >= 9) {
        self.tempShowAddCell = NO;
    }else{
        self.tempShowAddCell = YES;
    }
    [self.collectionView reloadData];
    [self setupNewFrame];
}
/**  添加图片 */
- (void)addImagesWithArray:(NSArray *)imageArray {
    for (UIImage *image in imageArray) {
        KPPhotoModel *imageModel = [[KPPhotoModel alloc] init];
        imageModel.image = image;
        imageModel.type = 0;
        [self.dataList addObject:imageModel];
    }
    if (self.dataList.count >= 9) {
        self.tempShowAddCell = NO;
    }else{
        self.tempShowAddCell = YES;
    }
    [self.collectionView reloadData];
    [self setupNewFrame];
}

- (NSArray *)dataSourceArrayOfCollectionView:(KPSelectViewCollectionView *)collectionView {
    return self.dataList;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tempShowAddCell) {
        if (indexPath.item == self.dataList.count) {
            return self.addCell;
        }
    }
    KPPhotoSubViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HXPhotoSubViewCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataList[indexPath.item];
    cell.backgroundColor = [UIColor blueColor];

    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.tempShowAddCell ? self.dataList.count + 1 : self.dataList.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tempShowAddCell) {
        if (indexPath.item == self.dataList.count) {
//            [self goPhotoViewController];
            return;
        }
    }
   
}
- (void)deleteModelWithIndex:(NSInteger)index {
    if (index < 0) {
        index = 0;
    }
//    if (index > self.manager.afterSelectedArray.count - 1) {
//        index = self.manager.afterSelectedArray.count - 1;
//    }
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (cell) {
        [self cellDidDeleteClcik:cell];
    }else {
//        NSSLog(@"删除失败 - cell为空");
    }
}
- (void)dragCellCollectionView:(KPSelectViewCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    self.dataList = [NSMutableArray arrayWithArray:newDataArray];
}
- (void)dragCellCollectionViewCellEndMoving:(KPSelectViewCollectionView *)collectionView {
    if ([self.delegate respondsToSelector:@selector(photoView:imageChangeComplete:)]) {
        [self.delegate photoView:self imageChangeComplete:self.dataList.mutableCopy];
    }
}
/**
 cell删除按钮的代理
 
 @param cell 被删的cell
 */
- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    KPPhotoModel *model = self.dataList[indexPath.item];
    
    UIView *mirrorView = [cell snapshotViewAfterScreenUpdates:NO];
    mirrorView.frame = cell.frame;
    [self.collectionView insertSubview:mirrorView atIndex:0];
    cell.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        mirrorView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        KPPhotoSubViewCell *myCell = (KPPhotoSubViewCell *)cell;
        myCell.imageView.image = nil;
        [mirrorView removeFromSuperview];
    }];
    [self.dataList removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    [self changeSelectedListModelIndex];
    if (self.showAddCell) {
        if (!self.tempShowAddCell) {
            self.tempShowAddCell = YES;
            [self.collectionView reloadData];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(photoView:currentDeleteModel:currentIndex:)]) {
        [self.delegate photoView:self currentDeleteModel:model currentIndex:indexPath.item];
    }
    if ([self.delegate respondsToSelector:@selector(photoView:imageChangeComplete:)]) {
        [self.delegate photoView:self imageChangeComplete:self.dataList.mutableCopy];
    }
    model.image = nil;
    model.type = 0;
    model = nil;
    [self setupNewFrame];
}
/**
 更新高度
 */
- (void)setupNewFrame {
    double x = self.frame.origin.x;
    double y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    
    CGFloat itemW = (width - self.spacing * (self.lineCount - 1)) / self.lineCount;
    if (itemW > 0) {
        self.flowLayout.itemSize = CGSizeMake(itemW, itemW);
    }
    
    NSInteger dataCount = self.tempShowAddCell ? self.dataList.count + 1 : self.dataList.count;
    NSInteger numOfLinesNew = 0;
    if (self.lineCount != 0) {
        numOfLinesNew = (dataCount / self.lineCount) + 1;
    }
    
    if (dataCount % 3 == 0) {
        numOfLinesNew -= 1;
    }
    self.flowLayout.minimumLineSpacing = 3;
    
    if (numOfLinesNew != self.numOfLinesOld) {
        CGFloat newHeight = numOfLinesNew * itemW + self.spacing * (numOfLinesNew - 1);
        if (newHeight < 0) {
            newHeight = 0;
        }
        self.frame = CGRectMake(x, y, width, newHeight);
        self.numOfLinesOld = numOfLinesNew;
        if (newHeight <= 0) {
            self.numOfLinesOld = 0;
        }
        if ([self.delegate respondsToSelector:@selector(photoView:updateFrame:)]) {
            [self.delegate photoView:self updateFrame:self.frame];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger dataCount = self.tempShowAddCell ? self.dataList.count + 1 : self.dataList.count;
    NSInteger numOfLinesNew = (dataCount / self.lineCount) + 1;
    [self setupNewFrame];
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (dataCount == 1) {
        CGFloat itemW = (width - self.spacing * (self.lineCount - 1)) / self.lineCount;
        if ((int)height != (int)itemW) {
            self.frame = CGRectMake(x, y, width, itemW);
        }
    }
    if (dataCount % self.lineCount == 0) {
        numOfLinesNew -= 1;
    }
    CGFloat cWidth = self.frame.size.width;
    CGFloat cHeight = self.frame.size.height;
    self.collectionView.frame = CGRectMake(0, 0, cWidth, cHeight);
    if (cHeight <= 0) {
        self.numOfLinesOld = 0;
        [self setupNewFrame];
        CGFloat cWidth = self.frame.size.width;
        CGFloat cHeight = self.frame.size.height;
        self.collectionView.frame = CGRectMake(0, 0, cWidth, cHeight);
    }
}
- (void)dealloc {
//    NSSLog(@"dealloc");
}



- (void)setShowAddCell:(BOOL)showAddCell {
    _showAddCell = showAddCell;
    self.tempShowAddCell = showAddCell;
}
#pragma mark -- lazyLoading
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (KPPhotoSubViewCell *)addCell {
    if (!_addCell) {
        _addCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        _addCell.backgroundColor =[UIColor redColor];
        _addCell.model = self.addModel;
      
    }
    return _addCell;
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    
    }
    return _dataList;
}
- (KPPhotoModel *)addModel {
    if (!_addModel) {
        _addModel = [[KPPhotoModel alloc] init];
//        _addModel.type = HXPhotoModelMediaTypeCamera;
        //        if (self.manager.UIManager.photoViewAddImageName) {
        //            _addModel.thumbPhoto = [HXPhotoTools hx_imageNamed:self.manager.UIManager.photoViewAddImageName];
        //        }else {
        _addModel.image = [UIImage imageNamed:@"compose_pic_add"];
        _addModel.type = KPPhotoModelType_addImage;
        //        }
    }
    return _addModel;
}
@end
