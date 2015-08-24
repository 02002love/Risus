//
//  MainTabbarController.m
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "MainTabbarController.h"
#import "PictureController.h"
#import "JokeController.h"
#import "VoiceController.h"
#import "VideoController.h"
#import "PushController.h"


@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavi];
    [self createTabbar];
    self.tabBar.translucent = NO;
    
    
}
-(void)createNavi{
    
    PictureController * picture = [[PictureController alloc]init];
    picture.type = 10;
    picture.data = @"data";
    picture.urlStr =NEW;
    picture.view.backgroundColor = [UIColor redColor];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:picture];
    picture.title = @"图片";
    
    JokeController * joke = [[JokeController alloc]init];
    joke.type = 29;
    joke.data = @"data";
    joke.urlStr =NEW;
    joke.view.backgroundColor = [UIColor grayColor];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:joke];
    joke.title = @"段子";
    
    VoiceController * voice = [[VoiceController alloc]init];
    voice.type = 10;
    voice.data = @"voice";
    voice.urlStr =NEW;
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:voice];
    voice.title = @"声音";
    
    VideoController * video = [[VideoController alloc]init];
    video.urlStr =VIDEONEW;
    UINavigationController * nav4= [[UINavigationController alloc]initWithRootViewController:video];
    nav4.navigationBar.translucent = NO;
    video.title = @"视频";
    
    //发布
    PushController * mine = [[PushController alloc]init];
    UINavigationController * nav5= [[UINavigationController alloc]initWithRootViewController:mine];
    
    self.viewControllers = @[nav1,nav2,nav5,nav3,nav4];
    
}

-(void)createTabbar{
    
    NSArray * name = @[@"图片",@"段子",@"来一发",@"声音",@"视频"];
    NSArray *unSelectImageName = @[@"tabbarQuotation.png",@"tabbarEssay.png",@"navigationButtonPublish",@"tabbarVoice.png",@"tabbarVideo.png"];
    NSArray *selectImageName = @[@"tabbarQuotationClick.png",@"tabbarEssayClick.png",@"navigationButtonPublish",@"tabbarVoiceClick.png",@"tabbarVideoClick.png"];
    
    for (int i=0; i<self.viewControllers.count; i++) {
        
        UITabBarItem * bar = self.tabBar.items[i];
        
        //设置图片
        
        UIImage * selectedimage = [UIImage imageNamed:selectImageName[i]];
        selectedimage  = [selectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * unselectedimage = [UIImage imageNamed:unSelectImageName[i]];
        unselectedimage = [unselectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        bar = [bar initWithTitle:name[i] image:unselectedimage selectedImage:selectedimage];

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
