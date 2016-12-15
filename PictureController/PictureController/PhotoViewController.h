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
#import "model.h"
#import "AlbumListViewController.h"

@protocol photoViewSelectImgDelegate <NSObject>

- (void)sendSelectImgArray:(NSMutableArray *)selectIMGArray;

@end

@interface PhotoViewController : UIViewController

@property(nonatomic,assign)id<photoViewSelectImgDelegate> selectDelegate;
@end
