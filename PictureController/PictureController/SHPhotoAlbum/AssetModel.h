//
//  AssetModel.h
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetModel : NSObject
@property(nonatomic,copy)NSString *flag;
@property(nonatomic,strong)NSData *orignImgData;//右上角选中图标
@property(nonatomic,strong)ALAsset *asset;//图片对象
@end
