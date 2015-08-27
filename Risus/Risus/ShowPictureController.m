//
//  ShowPictureController.m
//  Risus
//
//  Created by JinWei on 15/8/24.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "ShowPictureController.h"

@interface ShowPictureController ()<UIActionSheetDelegate>
{
    UIView * headView;
    UIScrollView * myscrollView;
    UIImageView * showImage ; //展示图片
    UIImageView * saveImage ; //用来保存长按手势传递的图片
}
@end

@implementation ShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addPicture];
    [self createBack];
    
    
    
}

-(void)createBack{
    
    headView = [[UIView alloc]initWithFrame:(CGRect){0,0,WIDTH,64}];
    headView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0  blue:245/256.0  alpha:0.6];
    [self.view addSubview:headView];
    UIButton * backBtn = [[UIButton alloc]initWithFrame:(CGRect){10,20,44,60}];
    [backBtn setTitle:@"返回" forState: UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    
}

-(void)backBtnClick:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)addPicture{
    
    myscrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,0,WIDTH,HEIGHT}];
    myscrollView.contentSize = CGSizeMake(WIDTH, [self.pictureHeight floatValue]*WIDTH / [self.pictureWidth floatValue] +64);
    [self.view addSubview:myscrollView];
    
    showImage = [[UIImageView alloc]initWithFrame:(CGRect){0,64,WIDTH,[self.pictureHeight floatValue]*WIDTH / [self.pictureWidth floatValue] }];
    [showImage sd_setImageWithURL:[NSURL URLWithString:self.pictureName]];
    //设置图片的位置,如果图片高度小于屏幕高度,让图片居中
    if ([self.pictureHeight floatValue] < HEIGHT) {
        showImage.center = self.view.center;
    }
    //添加手势保存
    UILongPressGestureRecognizer * longPressPicture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    showImage.userInteractionEnabled = YES;
    [showImage addGestureRecognizer:longPressPicture];
    [myscrollView addSubview:showImage];
    
}

-(void)longPressClick:(UILongPressGestureRecognizer *)gesturer{
    
    if (gesturer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    saveImage = (UIImageView *)gesturer.view;
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"是否保存图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"确定", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
}

#pragma mark  ==actionsheet的代理方法==

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==0) {
        UIImageWriteToSavedPhotosAlbum(saveImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    
    
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError * )error contextInfo:(void*)contextInfo{
    
    if (error != nil) {
        
        [MBProgressHUD showError:@"保存失败"];
    }
    else
    {
        [MBProgressHUD showSuccess:@"保存成功"];
        
    }
    
    
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
