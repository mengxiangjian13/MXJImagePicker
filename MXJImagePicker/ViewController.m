//
//  ViewController.m
//  MXJImagePicker
//
//  Created by Xiangjian Meng on 15/4/30.
//  Copyright (c) 2015年 cn.com.modernmedia. All rights reserved.
//

#import "ViewController.h"
#import "MXJImagePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectImage:(id)sender
{
    NSLog(@"选择图片");
    
    MXJImagePicker *imagePicker = [[MXJImagePicker alloc] init];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
