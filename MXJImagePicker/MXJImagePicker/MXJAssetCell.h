//
//  MXJAssetCell.h
//  MXJImagePicker
//
//  Created by Xiangjian Meng on 15/4/30.
//  Copyright (c) 2015年 cn.com.modernmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXJAssetCellDelegate;

@interface MXJAssetCell : UICollectionViewCell

@property (nonatomic, weak) id <MXJAssetCellDelegate> delegate;

- (void)showCellWithImage:(UIImage *)image
                 selected:(BOOL)selected;

@end

@protocol MXJAssetCellDelegate <NSObject>

- (void)assetCell:(MXJAssetCell *)cell
didTouchCheckButtonWithCheckFlag:(BOOL)isChecked;

@end