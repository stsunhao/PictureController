//
//  PhotoViewController.h
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CustomCollectionview.h"
#import "AssetModel.h"
#import "AlbumListViewController.h"

@protocol photoViewSelectImgDelegate <NSObject>

- (void)sendSelectImgArray:(NSMutableArray *)selectIMGArray tag:(int)tag;

@end

@interface PhotoViewController : UIViewController

@property(nonatomic,assign)id<photoViewSelectImgDelegate> selectDelegate;

@property(nonatomic,assign)int tag;

@property(nonatomic,assign)int pictureCount;//允许选择图片最大数量（暂时无用留待以后拓展）
@end
