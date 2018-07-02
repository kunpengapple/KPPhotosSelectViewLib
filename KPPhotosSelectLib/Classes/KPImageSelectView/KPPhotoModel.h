//
//  KPPhotoModel.h
//  KPPhotosSelectDemo
//
//  Created by linian on 2018/6/30.
//  Copyright © 2018年 linian. All rights reserved.
//

#import  <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, KPPhotoModelType)   {
    KPPhotoModelType_NormalImage = 0,
    KPPhotoModelType_addImage = 1
};

@interface KPPhotoModel : NSObject
@property (nonatomic ,strong)UIImage *image;
@property (nonatomic ,assign)KPPhotoModelType type;
@end
