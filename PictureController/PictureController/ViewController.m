//
//  ViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self UIType:pictureBtn backgroundColor:[UIColor redColor] frame:CGRectMake(0, 20+44, 100, 40) title:@"访问相册"];
    [self.view addSubview:pictureBtn];
    [pictureBtn addTarget:self action:@selector(pictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self UIType:cancelBtn backgroundColor:[UIColor blueColor] frame:CGRectMake(120, 20+44, 100, 40) title:@"取消相册"];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
//    imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    [self presentViewController:imageController animated:YES completion:nil];
    
    PhotoViewController *pictureController = [[PhotoViewController alloc]init];
    [self.navigationController pushViewController:pictureController animated:YES];
}

- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
