//
//  MXJImagePicker.m
//  MXJImagePicker
//
//  Created by Xiangjian Meng on 15/4/30.
//  Copyright (c) 2015年 cn.com.modernmedia. All rights reserved.
//

#import "MXJImagePicker.h"
#import "MXJAssetsViewController.h"

@interface MXJImagePicker ()

@end

@implementation MXJImagePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = @[[MXJAssetsViewController new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
