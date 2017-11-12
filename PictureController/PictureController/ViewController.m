//
//  ViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoViewController.h"
#import "AlbumListViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,photoViewSelectImgDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self UIType:pictureBtn backgroundColor:[UIColor redColor] frame:CGRectMake(0, 20+44, 100, 40) title:@"访问相册"];
    [self.view addSubview:pictureBtn];
    [pictureBtn addTarget:self action:@selector(pictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)UIType:(UIButton *)view backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame title:(NSString *)title
{
    view.backgroundColor = backgroundColor;
    view.frame = frame;
    [view setTitle:title forState:UIControlStateNormal];
}

- (void)pictureBtnClick{
//    UIImagePickerController *imageController = [[UIImagePickerController alloc]init];
//    imageController.allowsEditing = YES;
//    imageController.delegate = self;
//    UIImagePickerControllerSourceTypePhotoLibrary,
//    UIImagePickerControllerSourceTypeCamera,
//    UIImagePickerControllerSourceTypeSavedPhotosAlbum
//    imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    [self presentViewController:imageController animated:YES completion:nil];
    PhotoViewController *pvc = [[PhotoViewController alloc]init];
    pvc.selectDelegate = self;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:pvc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}

#pragma mark - photoViewSelectImgDelegate
- (void)sendSelectImgArray:(NSMutableArray *)selectIMGArray{
    for (int i = 0; i < [selectIMGArray count]; i ++) {
        ALAsset *assets = [selectIMGArray objectAtIndex:i];
        NSLog(@"%@",assets.defaultRepresentation.filename);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
