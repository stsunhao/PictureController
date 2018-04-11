//
//  PhotoViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "PhotoViewController.h"

#define screenWidth self.view.frame.size.width
#define screecHeight self.view.frame.size.height
#define Version(number) if ([[[UIDevice currentDevice] systemVersion] floatValue] >= number)
#define Xscale ([(NSString*)[SessionStorage getItemWithKey:@"sitech_width"] floatValue]/320.f)
#define Yscale ([(NSString*)[SessionStorage getItemWithKey:@"sitech_height"] floatValue]/480.f)

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,albumSendNametype>
{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_collectionViewLayout;
    
    NSMutableArray *_dataSourceMarray;//相片数据源
    NSMutableArray *_groupMarray;//相册数据源
    
    ALAssetsFilter *_pictureType;//筛选相册中照片种类，是图片还是音频或视频
    ALAssetsLibrary *_assetsLibrary;//相册类实例化对象
    
    UIButton *_confirmBtn;//确认按钮
    UILabel *_picNumLabel;//图片个数文本
}

@property(nonatomic,strong)NSMutableArray *selectPicArray;
@end

@implementation PhotoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceMarray = [[NSMutableArray alloc]init];
        _groupMarray = [[NSMutableArray alloc]init];
        
        //照片种类实例化对象:照片类
        _pictureType = [ALAssetsFilter allPhotos];
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self createUI];
    [self loadPictureSource:@""];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    //当内容高度大于定义collectionview的frame高度时，直接滑到底部，便于用户选择
    if (_collectionView.contentSize.height > _collectionView.frame.size.height) {
        [_collectionView setContentOffset:CGPointMake(0, _collectionView.contentSize.height - _collectionView.frame.size.height) animated:NO];
    }
    if ([_selectPicArray count]>0) {
        [_selectPicArray removeAllObjects];
    }
    
}

- (void)createUI{
    self.view.backgroundColor  = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(38/255.0) green:(36/255.0) blue:(30/255.0) alpha:1.0];
    self.navigationController.navigationBar.alpha = 0.7;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"相机胶卷";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionViewLayout.itemSize = CGSizeMake(self.view.frame.size.width/4, screenWidth/4-1);
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0.f, 0, 9.f, 0);
    
    Version(8.0)
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20+44, screenWidth, screecHeight-20-44-49) collectionViewLayout:_collectionViewLayout];
    else{
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screecHeight-20-44-49) collectionViewLayout:_collectionViewLayout];
    }
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CustomCollectionview class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 40)];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
     [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setImage:nil forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 40)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
     [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, screecHeight-49, screenWidth, 49)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:(30/255.0) green:(34/255.0) blue:(39/255.0) alpha:1.0]];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    
    UIView *divideLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    [divideLine setBackgroundColor:[UIColor grayColor]];
    [bottomView addSubview:divideLine];
    
    _picNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 30, 20)];
    [_picNumLabel setTextColor:[UIColor whiteColor]];
    [bottomView addSubview:_picNumLabel];
    
    _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width-70, 10, 60, 29)];
     [_confirmBtn setBackgroundColor:[UIColor colorWithRed:(30/255.0) green:(161/255.0) blue:(20/255.0) alpha:1.0]];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.enabled = NO;
    [bottomView addSubview:_confirmBtn];
    
}

//获取相机胶卷中所有的图片
- (void)loadPictureSource:(NSString *)albumName{
    if (_groupMarray.count > 0) {
        [_groupMarray removeAllObjects];
    }
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            //相册中只留下图片
            [group setAssetsFilter:_pictureType];
            
            if ([albumName isEqualToString:@""]) {
                if ((group.numberOfAssets>0)&&([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]||[[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"]||[[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"所有照片"])) {
                    [_groupMarray addObject:group];
                }
            }else{
                self.title = albumName;
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                    [_groupMarray addObject:group];
                }

            }
            
        }else{
            if ([_groupMarray count] > 0) {
                [self allPictureInAlbum:_groupMarray[0]];
            }
        }

        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"获取相册失败");
    }];
    
}

//将某相册中的图片加入数据源
- (void)allPictureInAlbum:(ALAssetsGroup *)albumGroup{
    if (_dataSourceMarray.count > 0) {
        [_dataSourceMarray removeAllObjects];
    }
    
    [albumGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            AssetModel *picModel = [[AssetModel alloc]init];
            picModel.asset = result;
            picModel.flag = @"0";
            [_dataSourceMarray addObject:picModel];
        }else{
            [_collectionView reloadData];
        }
    }];
    
}

- (void)back{
    AlbumListViewController *albumVc = [[AlbumListViewController alloc]init];
    albumVc.delegate = self;
    CATransition *pushAnimation = [[CATransition alloc] init];
    pushAnimation.duration = .4;
    pushAnimation.type = kCATransitionPush;
    pushAnimation.subtype = kCATransitionFromLeft;
    //将动画效果添加到视图层
    [self.navigationController.view.layer addAnimation:pushAnimation forKey:nil];
    [self.navigationController pushViewController:albumVc animated:YES];
    
}

- (void)cancel{

    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)confirmBtnClick{
    [self.selectDelegate sendSelectImgArray:_selectPicArray tag:_tag];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSourceMarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    CustomCollectionview *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    AssetModel *subModel = [_dataSourceMarray objectAtIndex:indexPath.row];
    if ([subModel.flag isEqualToString:@"0"]) {
        cell.pressImg.image = [UIImage imageNamed:@"photo_def_photoPickerVc@2x.png"];
    }else{
        cell.pressImg.image = [UIImage imageNamed:@"photo_sel_photoPickerVc@2x.png"];
    }
    cell.pictureImg.image = [UIImage imageWithCGImage:subModel.asset.thumbnail];
    
    return cell;
}



#pragma mark - collectionView deleaget
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth/4-1, screenWidth/4-1);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssetModel *subModel = [_dataSourceMarray objectAtIndex:indexPath.row];
    if ([subModel.flag isEqualToString:@"1"]) {
        subModel.flag = @"0";
        [self.selectPicArray removeObject:subModel.asset];
    }else{
        subModel.flag = @"1";
        [self.selectPicArray addObject:subModel.asset];
    }
    
    if ([_selectPicArray count]>0){
        _confirmBtn.enabled = YES;
        [_picNumLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_selectPicArray count]]];
    }
    else{
        _confirmBtn.enabled = NO;
        [_picNumLabel setText:@""];
    }
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    
}

#pragma mark - albumSendNametype delegate
- (void)sendAlbumType:(NSString *)albumName{
    [self loadPictureSource:albumName];
    self.title = albumName;
}


//获取原大图
//- (void)getOriginalImages
//{
//    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
//    }
//    
//    // 获得相机胶卷
//    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    // 遍历相机胶卷,获取大图
//    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
//}
//
////获取缩略图
//- (void)getThumbnailImages
//{
//    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
//    }
//    // 获得相机胶卷
//    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
//}
//
///**
// *  遍历相簿中的所有图片
// *  @param assetCollection 相簿
// *  @param original        是否要原图
// */
//- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
//{
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
//    
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    // 同步获得图片, 只会返回1张图片
//    options.synchronous = YES;
//    
//    // 获得某个相簿中的所有PHAsset对象
//    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
//    for (PHAsset *asset in assets) {
//        // 是否要原图
//        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
//        
//        // 从asset中获得图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"%@", result);
//            model *subModel = [[model alloc]init];
//            subModel.flag = @"0";
//            subModel.orignImgData = UIImagePNGRepresentation(result);
//            [_dataSourceMarray addObject:subModel];
//        }];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_collectionView reloadData];
//    });
//}



#pragma mark - 懒加载
- (NSMutableArray *)selectPicArray{
    if (!_selectPicArray) {
        _selectPicArray = [[NSMutableArray alloc]init];
    }
    return _selectPicArray;
}


@end
