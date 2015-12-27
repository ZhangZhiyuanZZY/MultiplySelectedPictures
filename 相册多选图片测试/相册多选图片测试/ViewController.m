//
//  ViewController.m
//  相册多选图片测试
//
//  Created by 章芝源 on 15/12/25.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ViewController.h"
#import "ELCImagePickerHeader.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()<ELCImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

//单张图片点击
- (IBAction)onePicture:(id)sender {
    
    NSLog(@"为实现");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

//多张图片
- (IBAction)MultiplisePictureClick:(id)sender {
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100;  //最大选择数
    elcPicker.returnsOriginalImage = YES;  //返回未编辑的图片
    elcPicker.returnsImage = YES;  //返回的是图片
    elcPicker.onOrder = YES;  //是否多选

    
    elcPicker.imagePickerDelegate = self;
    
    //modal出相册控制器
    [self presentViewController:elcPicker animated:YES completion:nil];

}

#pragma mark -ELCImagePickerController代理方法
//demo代理方法,  当选择完图片点击 Done的时候会被调用
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    //每次点击, 进来照片都从 x=0 开始 让下一张图片, x都大一倍的宽度
    CGRect imageFrame = self.scrollView.frame;
    imageFrame.origin.x = 0;
    
    //遍历字典, 对比字典中媒体资源类型
    for (NSDictionary *dict in info) {
        if (dict[UIImagePickerControllerMediaType] == ALAssetTypePhoto) {
            if (dict[UIImagePickerControllerOriginalImage]) {
                UIImage *image = dict[UIImagePickerControllerOriginalImage];
                UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
                imageview.frame = imageFrame;
                //将选择的图片添加到, scrollView上展示
                [self.scrollView addSubview:imageview];
                imageFrame.origin.x += self.scrollView.bounds.size.width;
            } else {
                NSLog(@"error");
            }
        }else if (dict[UIImagePickerControllerMediaType] == ALAssetTypeVideo) {
            if (dict[UIImagePickerControllerOriginalImage]) {
                UIImage *image = dict[UIImagePickerControllerOriginalImage];
                UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
                imageview.frame = imageFrame;
                //添加到scrollView上
                [self.scrollView addSubview:imageview];
                imageFrame.origin.x += self.scrollView.bounds.size.width;
            } else {
                NSLog(@"error");
            }
        } else {
            NSLog(@"unknown asset type");
        }
    }
    //分页
    self.scrollView.pagingEnabled = YES;
    //scrollView范围
    self.scrollView.contentSize = CGSizeMake(info.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
}

//点击取消, 退出整个控制器
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
