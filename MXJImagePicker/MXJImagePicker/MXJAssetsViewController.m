//
//  MXJAssetsViewController.m
//  MXJImagePicker
//
//  Created by Xiangjian Meng on 15/4/30.
//  Copyright (c) 2015年 cn.com.modernmedia. All rights reserved.
//

#import "MXJAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MXJAssetCell.h"

@interface MXJAssetsViewController () <UICollectionViewDataSource,UICollectionViewDelegate,MXJAssetCellDelegate>
{
    NSMutableArray *assetList;
    UICollectionView *mainCollectionView;
    ALAssetsLibrary *library;
    NSMutableArray *selectedAssetList;
}

@end

@implementation MXJAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    assetList = [NSMutableArray new];
    selectedAssetList = [NSMutableArray new];
    
    self.title = @"相机胶卷";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [mainCollectionView registerNib:[UINib nibWithNibName:@"MXJAssetCell" bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:@"MXJAssetCell"];
    [self.view addSubview:mainCollectionView];
    
    [self fetchAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private method

- (void)fetchAssets
{
    library = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               if (group)
                               {
                                   // 筛选只取照片
                                   [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                   [groups addObject:group];
                               }
                               else
                               {
                                   // 完成遍历，继续遍历groups
                                   [weakSelf enumAssetGroups:groups];
                               }
                           } failureBlock:^(NSError *error) {
                               NSLog(@"没有权限");
                               
                               
                           }];
}

- (void)enumAssetGroups:(NSMutableArray *)groups
{
    for (ALAssetsGroup *group in groups)
    {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result)
            {
                [assetList addObject:result];
            }
            else
            {
                // 完成遍历
                [self reloadData];
            }
        }];
    }
}

- (void)reloadData
{
    // 刷新页面
    [mainCollectionView reloadData];
}

- (void)assetCell:(MXJAssetCell *)cell
didTouchCheckButtonWithCheckFlag:(BOOL)isChecked;
{
    NSIndexPath *indexPath = [mainCollectionView indexPathForCell:cell];
    if (indexPath.item >= 0 && indexPath.item < [assetList count])
    {
        ALAsset *asset = assetList[indexPath.item];
        if (isChecked)
        {
            if (![selectedAssetList containsObject:asset])
            {
                [selectedAssetList addObject:asset];
            }
        }
        else
        {
            [selectedAssetList removeObject:asset];
        }
    }
}


#pragma mark - 
#pragma makr UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assetList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MXJAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXJAssetCell" forIndexPath:indexPath];
    cell.delegate = self;
    ALAsset *asset = assetList[indexPath.item];
    [cell showCellWithImage:[UIImage imageWithCGImage:asset.thumbnail]
                   selected:[selectedAssetList containsObject:asset]];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
