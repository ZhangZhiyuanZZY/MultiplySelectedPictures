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

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@", [[UIDevice currentDevice] systemVersion]);
    
    
}

- (IBAction)onePictureClick:(id)sender {
    
    
    
}
- (IBAction)MultiplisePictureClick:(id)sender {
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];

}

#pragma mark -ELCImagePickerController代理方法
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
                //添加到scrollView上
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
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(info.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
