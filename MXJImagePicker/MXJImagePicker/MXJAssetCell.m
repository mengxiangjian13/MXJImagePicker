//
//  MXJAssetCell.m
//  MXJImagePicker
//
//  Created by Xiangjian Meng on 15/4/30.
//  Copyright (c) 2015年 cn.com.modernmedia. All rights reserved.
//

#import "MXJAssetCell.h"

@interface MXJAssetCell ()
{
    BOOL isChecked;
}

@property (weak, nonatomic) IBOutlet UIImageView *assetView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation MXJAssetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showCellWithImage:(UIImage *)image
                 selected:(BOOL)selected
{
    isChecked = selected;
    
    self.assetView.image = image;
    
    [self setCheckButtonBackImageWithIsChecked:selected];
}

- (void)setCheckButtonBackImageWithIsChecked:(BOOL)_isChecked
{
    if (_isChecked)
    {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"asset_check"]
                                    forState:UIControlStateNormal];
    }
    else
    {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"asset_uncheck"]
                                    forState:UIControlStateNormal];
    }
}

- (IBAction)touchCheckButton:(id)sender
{
    isChecked = !isChecked;
    [self setCheckButtonBackImageWithIsChecked:isChecked];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCell:didTouchCheckButtonWithCheckFlag:)])
    {
        [self.delegate assetCell:self
didTouchCheckButtonWithCheckFlag:isChecked];
    }
}


@end
