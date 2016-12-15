//
//  AlbumListViewController.h
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/13.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol albumSendNametype <NSObject>

- (void)sendAlbumType:(NSString *)albumName;

@end

@interface AlbumListViewController : UIViewController
@property(nonatomic,assign)id<albumSendNametype> delegate;

@end
