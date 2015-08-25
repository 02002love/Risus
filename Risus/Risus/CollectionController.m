
//
//  CollectionController.m
//  Risus
//
//  Created by JinWei on 15/8/25.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "CollectionController.h"
#import "CustomCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CollectionController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;

}
@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    _tableView.separatorStyle = 0;
    
}

#pragma mark  创建TableView
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
}
#pragma mark  tabelView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return   self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID =@"cellId";
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NewModel * model = self.dataArray[indexPath.row];
    
    [cell configWithModel:model];
    cell.myBlock = ^(NSString* url){
        
        MPMoviePlayerViewController * voiceViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
        voiceViewController.hidesBottomBarWhenPushed = YES;
        voiceViewController.title = @"正在播放";
        voiceViewController.view.frame =(CGRect){0,0,WIDTH,HEIGHT*0.5};
        //播放加载
        [voiceViewController.moviePlayer prepareToPlay];
        //播放
        [voiceViewController.moviePlayer play];
        [self.navigationController pushViewController:voiceViewController animated:YES];
        
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewModel * model = self.dataArray[indexPath.row];
    return  model.cellHeight + SPACE;
    
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
