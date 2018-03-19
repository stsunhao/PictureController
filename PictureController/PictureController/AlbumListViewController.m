//
//  AlbumListViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/13.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "AlbumListViewController.h"

#define Version(number) if ([[[UIDevice currentDevice] systemVersion] floatValue] >= number)
#define screenWidth self.view.frame.size.width
#define screecHeight self.view.frame.size.height

@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_albumTableView;
    NSMutableArray *_dataSource;
    
    ALAssetsLibrary *_assetsLibrary;
    ALAssetsFilter *_pictureType;
}
@end

@implementation AlbumListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pictureType = [ALAssetsFilter allPhotos];
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
        
        _dataSource = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"照片";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 40)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
     [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    [self createTableView];
    
    [self loadPicData];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createTableView{
    Version(8.0)
        _albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20 + 44, screenWidth, screecHeight-64) style:UITableViewStylePlain];
    else{
        _albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screecHeight-64) style:UITableViewStylePlain];
    }
    _albumTableView.delegate = self;
    _albumTableView.dataSource = self;
    [self.view addSubview:_albumTableView];
}

- (void)loadPicData{
    if (_dataSource.count > 0) {
        [_dataSource removeAllObjects];
    }
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            //相册中只留下图片
            [group setAssetsFilter:_pictureType];
            
//            if (group.numberOfAssets>0){
                [_dataSource addObject:group];
//            }
        }else{
            [_albumTableView reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"获取相册失败");
    }];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.imageView.image = [UIImage imageWithCGImage:[_dataSource[indexPath.row] posterImage]];
    cell.textLabel.text = [_dataSource[indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
    
    return cell;
}




#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate sendAlbumType:[_dataSource[indexPath.row] valueForProperty:ALAssetsGroupPropertyName]];
    CATransition *pushAnimation = [[CATransition alloc] init];
    pushAnimation.duration = .4;
    pushAnimation.type = kCATransitionPush;
    pushAnimation.subtype = kCATransitionFromRight;
    //将动画效果添加到视图层
    [self.navigationController.view.layer addAnimation:pushAnimation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}







@end
