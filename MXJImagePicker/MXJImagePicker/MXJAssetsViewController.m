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
    
    UIButton *previewButton;
    UIButton *chooseButton;
}

@end

@implementation MXJAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItems];
    
    assetList = [NSMutableArray new];
    selectedAssetList = [NSMutableArray new];
    
    self.title = @"相机胶卷";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 55, 5);
    mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [mainCollectionView registerNib:[UINib nibWithNibName:@"MXJAssetCell" bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:@"MXJAssetCell"];
    [self.view addSubview:mainCollectionView];
    
    [self fetchAssets];
    
    [self setupToolBar];
}

- (void)setupNavigationItems
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancel;
    
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                            target:self action:@selector(done)];
//    self.navigationItem.rightBarButtonItem = done;
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupToolBar
{
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    bar.backgroundColor = [UIColor whiteColor];
    bar.layer.borderColor = [[UIColor grayColor] CGColor];
    bar.layer.borderWidth = 0.5;
    [self.view addSubview:bar];
    
    previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previewButton.frame = CGRectMake(10, 0, 44, 44);
    [previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:previewButton];
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseButton setTitle:@"完成" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:0.227f green:0.682f blue:0.263f alpha:1.00f] forState:UIControlStateNormal];
    chooseButton.frame = CGRectMake(self.view.bounds.size.width - 54, 0, 44, 44);
    [chooseButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:chooseButton];
    
    [self changeButtonsState];
}

- (void)done
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)preview:(id)sender
{
    NSLog(@"预览");
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
    
    [self changeButtonsState];
}

- (void)changeButtonsState
{
    chooseButton.enabled = ([selectedAssetList count] > 0);
    previewButton.enabled = ([selectedAssetList count] > 0);
    chooseButton.alpha = ([selectedAssetList count] > 0)? 1.0:0.6;
    previewButton.alpha = ([selectedAssetList count] > 0)? 1.0:0.6;
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
