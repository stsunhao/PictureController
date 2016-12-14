//
//  AlbumListViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/13.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "AlbumListViewController.h"

@interface AlbumListViewController ()

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)back{

}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
