
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
#import "FMDBManager.h"
#import "NewModel.h"

@interface CollectionController ()<UITableViewDataSource,UITableViewDelegate,reloadDataDelegate>
{
    UITableView * _tableView;
    NSIndexPath * path;
    FMDBManager * manager;
    
}
@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    _tableView.separatorStyle = 0;
    
    self.title = @"我的收藏";
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
    cell.isCollected = @"1";//取消收藏
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
    cell.delegate = self;
    cell.index = indexPath.row;
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

//编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==1) {
        
        path =indexPath;
        
    }
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"是否要删除?" message:nil delegate: self cancelButtonTitle:@"取消" otherButtonTitles: @"确认", nil];
    [alert show];
    
//    if (editingStyle==1) {
//        
//        path =indexPath;
//        
//    }
    [_tableView reloadData];
    
}

#pragma mark  ==alertView 代理==


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex ==0) {
        NSLog(@"%ld",(long)buttonIndex);
        return;
    }else{
        manager = [FMDBManager sharedFMDBManager];
        NSLog(@"%ld",(long)buttonIndex);
        NewModel * model = self.dataArray[path.row];
        [self.dataArray removeObjectAtIndex:path.row];
        [manager deleteData:model];
        //        [_tableView reloadData];
        [_tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    path =indexPath;

}

#pragma mark  cell 代理的刷新方法
-(void)refreshData:(CGFloat)index{
    
    SKLog(@"刷新数据==================");
//    [_tableView reloadData];
//    NSIndexPath * myIndex = [NSIndexPath indexPathForRow:index inSection:0];
//   [_tableView deleteRowsAtIndexPaths:@[myIndex]  withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.dataArray removeObjectAtIndex:index];
    [_tableView reloadData];
    
    
    
}
@end
