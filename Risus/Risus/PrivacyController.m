//
//  PrivacyController.m
//  Risus
//
//  Created by JinWei on 15/8/23.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "PrivacyController.h"

@interface PrivacyController ()

@end

@implementation PrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私政策";
    NSString * path = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    UIWebView *  showView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [showView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    [self.view addSubview:showView];
    // Do any additional setup after loading the view.
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
