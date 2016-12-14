//
//  PhotoViewController.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_collectionViewLayout;
    
    NSMutableArray *_dataSourceMarray;//相片数据源
    NSMutableArray *_groupMarray;//相册数据源
    
    ALAssetsFilter *_pictureType;//筛选相册中照片种类，是图片还是音频或视频
    ALAssetsLibrary *_assetsLibrary;//相册类实例化对象
}
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
    
    [self createUI];
    [self loadPictureSource];
    
//    dispatch_queue_t queue = dispatch_queue_create("com.test", NULL);
//    dispatch_async(queue, ^{
//        [self getOriginalImages];
//        [self getThumbnailImages];
//    });
}

- (void)createUI{
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionViewLayout.itemSize = CGSizeMake(self.view.frame.size.width/4, screenWidth/4-1);
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0.f, 0, 9.f, 0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20+44, screenWidth, screecHeight-20-44) collectionViewLayout:_collectionViewLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CustomCollectionview class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
}

//获取相机胶卷中所有的图片
- (void)loadPictureSource{
    if (_groupMarray.count > 0) {
        [_groupMarray removeAllObjects];
    }
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            //相册中只留下图片
            [group setAssetsFilter:_pictureType];

            if ((group.numberOfAssets>0)&&([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]||[[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"])) {
                [_groupMarray addObject:group];
            }
        }else{
            
            [self allPictureInAlbum:_groupMarray[0]];
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
            model *picModel = [[model alloc]init];
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
    [self.navigationController pushViewController:albumVc animated:YES];
}

- (void)cancel{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    model *subModel = [_dataSourceMarray objectAtIndex:indexPath.row];
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
    model *subModel = [_dataSourceMarray objectAtIndex:indexPath.row];
    if ([subModel.flag isEqualToString:@"1"]) {
        subModel.flag = @"0";
    }else{
        subModel.flag = @"1";
    }
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
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






@end
